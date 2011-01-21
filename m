Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab1AUP2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:28:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:64550 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466Ab1AUP2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:28:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,358,1291622400"; 
   d="scan'208";a="595205533"
Message-ID: <4D39A621.7080007@intel.com>
Date: Fri, 21 Jan 2011 07:28:33 -0800
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Li, Shaohua" <shaohua.li@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Markus Trippelsdorf <markus@trippelsdorf.de>,
        "Lu, Hongjiu" <hongjiu.lu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Linux 2.6.38-rc1 doesn't boot
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>	 <20110119073905.GA1652@gentoo.trippels.de>	 <20110119074902.GA1670@gentoo.trippels.de>	 <1295424766.1949.879.camel@sli10-conroe> <4D36A759.60704@intel.com>	 <20110119090904.GA4927@elte.hu> <1295489286.1949.882.camel@sli10-conroe>	 <20110120112541.GA23661@elte.hu>	 <ADDEBCD9C145E542A8688C29F1FBDCB9C915F59E@orsmsx502.amr.corp.intel.com> <1295594339.1949.936.camel@sli10-conroe>
In-Reply-To: <1295594339.1949.936.camel@sli10-conroe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 11:18 PM, Li, Shaohua wrote:
>  		*(.jiffies)
>  	}
>  	jiffies = VVIRT(.jiffies);
> +	jiffies_64 = jiffies;
>  

OK, this is just messed up.  If we need jiffies in a special section
then we should declare it as such (see __jiffy_data), but it's not clear
to me why we would.  This seems like hack upon hack.

However, I suspect we may want to put jiffies into a .S file, and that
.S file needs to take into account architectures which need underscore
prefixes (which really sucks to have in ELF and is a major fail on those
ABI designers...)

	-hpa

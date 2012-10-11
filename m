Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518Ab2JKXLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 19:11:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:39036 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758462Ab2JKXLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 19:11:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,573,1344236400"; 
   d="scan'208";a="204562024"
Message-ID: <50775210.4060007@zytor.com>
Date: Fri, 12 Oct 2012 07:11:12 +0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Greg KH <greg@kroah.com>, Romain Francoise <romain@orebokech.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Linux 2.6.32.60
References: <20121009094453.GA4289@1wt.eu> <87y5jeqv6b.fsf@silenus.orebokech.com> <20121011062916.GG8938@1wt.eu> <20121011105804.GB28546@kroah.com> <20121011113106.GR8938@1wt.eu>
In-Reply-To: <20121011113106.GR8938@1wt.eu>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2012 07:31 PM, Willy Tarreau wrote:
> On Thu, Oct 11, 2012 at 07:58:04PM +0900, Greg KH wrote:
>> On Thu, Oct 11, 2012 at 08:29:16AM +0200, Willy Tarreau wrote:
>>> If you think these patches constitute a regression, I can revert them.
>>> However I'd like convincing arguments since they're here to help address
>>> a real issue.
>>
>> If I missed these when doing the random number generation backport for
>> 3.0, and I should add them there as well, please let me know.
> 
> At least I think they should not be in 2.6.32 without being in 3.0.
> Probably that Peter's opinion will help us decide whether they should
> go into 3.0 or 2.6.32 should revert them.
> 

I would strongly argue for at least one of the RDRAND-enabling versions
being in all supported kernels; the second (with Ted Ts'o's changes) is
better, but touches a *lot* of subsystems; the plain one is
self-contained but only helps RDRAND-enabled hardware.

Without these patches the random subsystem has a critical security flaw,
which puts it into the scope for stable.

	-hpa




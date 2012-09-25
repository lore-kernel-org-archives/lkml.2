Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab2IYNs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:48:27 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:53403 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab2IYNsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:48:23 -0400
X-IronPort-AV: E=Sophos;i="4.80,483,1344211200"; 
   d="scan'208";a="14752024"
Message-ID: <1348580900.11229.19.camel@zakaz.uk.xensource.com>
Subject: Re: [RFC PATCH] x86-32: Start out eflags and cr4 clean
From: Ian Campbell <Ian.Campbell@citrix.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Rusty Russell" <rusty@rustcorp.com.au>,
        David Woodhouse <dwmw2@infradead.org>, Vivek Goyal <vgoyal@in.ibm.com>,
        Andres Salomon <dilinger@queued.net>,
        Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 25 Sep 2012 14:48:20 +0100
In-Reply-To: <1348529239-17943-1-git-send-email-hpa@linux.intel.com>
References: <87sjaaj3cx.fsf@xmission.com>
	 <1348529239-17943-1-git-send-email-hpa@linux.intel.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 00:27 +0100, H. Peter Anvin wrote:
> From: "H. Peter Anvin" <hpa@linux.intel.com>
> 
> %cr4 is supposed to reflect a set of features into which the operating
> system is opting in.  If the BIOS or bootloader leaks bits here, this
> is not desirable.  Consider a bootloader passing in %cr4.pae set to a
> legacy paging kernel, for example -- it will not have any immediate
> effect, but the kernel would crash when turning paging on.
> 
> A similar argument applies to %eflags, and since we have to look for
> %eflags.id being settable we can use a sequence which clears %eflags
> as a side effect.
> 
> Note that we already do this for x86-64.
> 
> I would like opinions on this especially from the PV crowd

Xen PV guests don't pass through this code path so there is no danger
there AFAICT, so from that PoV:

Acked-by: Ian Campbell <ian.campbell@citrix.com>

FWIW it looks correct to me from the native PoV too, but you probably
already knew that ;-)

Ian.



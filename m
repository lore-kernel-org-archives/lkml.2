Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab2IZLlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 07:41:17 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:64216 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab2IZLlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 07:41:16 -0400
Date: Wed, 26 Sep 2012 07:29:56 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Woodhouse <dwmw2@infradead.org>, Vivek Goyal <vgoyal@in.ibm.com>,
        Andres Salomon <dilinger@queued.net>,
        Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH] x86-32: Start out eflags and cr4 clean
Message-ID: <20120926112955.GA7356@phenom.dumpdata.com>
References: <87sjaaj3cx.fsf@xmission.com>
 <1348529239-17943-1-git-send-email-hpa@linux.intel.com>
 <1348580900.11229.19.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348580900.11229.19.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 02:48:20PM +0100, Ian Campbell wrote:
> On Tue, 2012-09-25 at 00:27 +0100, H. Peter Anvin wrote:
> > From: "H. Peter Anvin" <hpa@linux.intel.com>
> > 
> > %cr4 is supposed to reflect a set of features into which the operating
> > system is opting in.  If the BIOS or bootloader leaks bits here, this
> > is not desirable.  Consider a bootloader passing in %cr4.pae set to a
> > legacy paging kernel, for example -- it will not have any immediate
> > effect, but the kernel would crash when turning paging on.
> > 
> > A similar argument applies to %eflags, and since we have to look for
> > %eflags.id being settable we can use a sequence which clears %eflags
> > as a side effect.
> > 
> > Note that we already do this for x86-64.
> > 
> > I would like opinions on this especially from the PV crowd
> 
> Xen PV guests don't pass through this code path so there is no danger
> there AFAICT, so from that PoV:
> 
> Acked-by: Ian Campbell <ian.campbell@citrix.com>
> 
> FWIW it looks correct to me from the native PoV too, but you probably
> already knew that ;-)

And sanity testing confirmed it.

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> Ian.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

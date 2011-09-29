Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab1I2XKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 19:10:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51801 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab1I2XKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 19:10:42 -0400
Date: Thu, 29 Sep 2011 16:10:40 -0700
From: Andrew Morton <akpm00@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH -next] x86 mrst: fix build error when X86_MRST is not
 enabled
Message-Id: <20110929161040.41f23573.akpm00@gmail.com>
In-Reply-To: <20110929235708.1bbd1166@lxorguk.ukuu.org.uk>
References: <20110929165730.661cf28c9bb27b8a85432cd2@canb.auug.org.au>
	<4E84D684.107@xenotime.net>
	<20110929235708.1bbd1166@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011 23:57:08 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Thu, 29 Sep 2011 13:35:16 -0700
> Randy Dunlap <rdunlap@xenotime.net> wrote:
> 
> > From: Randy Dunlap <rdunlap@xenotime.net>
> > 
> > Fix build when CONFIG_X86_INTEL_MID is enabled but
> > CONFIG_X86_MRST is not enabled.  Fixes this build error:
> 
> This looks wrong. Unfortunately until we get kernel.org back its hard to
> do much about it and see what is in all the trees.
> 
> > -#ifdef CONFIG_X86_INTEL_MID
> > +#ifdef CONFIG_X86_MRST
> >  
> >  static inline enum mrst_cpu_type mrst_identify_cpu(void)
> >  {
> >  	return __mrst_cpu_chip;
> >  }
> >  
> > -#else /* !CONFIG_X86_INTEL_MID */
> > +#else /* !CONFIG_X86_MRST */
> >  
> >  #define mrst_identify_cpu()    (0)
> >  
> > -#endif /* !CONFIG_X86_INTEL_MID */
> > +#endif /* !CONFIG_X86_MRST */
> 
> This breaks Medfield so NAK
> 
> The correct behaviour should be 
> 
> INTEL_MID defined -> mrst_cpu_chip has meaning
> INTEL_MID not defined -> mrst_identify_chip is 0
> 
> your change makes it 0 for Medfield which means it will crash on boot.

Randy's patch is an attempt to fix Mathias's "x86: rtc: don't register
a platform RTC device for Intel MID platforms".

I'm tempted to do a mass droppage, but then some of the patches might
get forever lost.

I am presently babysitting these x86 patches:

x86-fix-mmap-random-address-range.patch
arch-x86-kernel-e820c-eliminate-bubble-sort-from-sanitize_e820_map.patch
vrtc-change-its-year-offset-from-1960-to-1972.patch
x86-rtc-dont-register-a-platform-rtc-device-for-intel-mid-platforms.patch
x86-rtc-dont-register-a-platform-rtc-device-for-intel-mid-platforms-fix.patch
mrst-battery-fixes.patch
mrst-battery-fixes-fix.patch
x86mrst-add-mapping-for-bma023.patch
arch-x86-kernel-e820c-quiet-sparse-noise-about-plain-integer-as-null-pointer.patch
arch-x86-kernel-ptracec-quiet-sparse-noise.patch
arch-x86-mm-pageattrc-quiet-sparse-noise-local-functions-should-be-static.patch
x86-tlb-flush-avoid-superflous-leave_mm.patch

Could we please get some x86 maintainers on deck??

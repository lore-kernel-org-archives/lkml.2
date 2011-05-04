Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab1EDHzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 03:55:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39049 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab1EDHzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 03:55:08 -0400
Date: Wed, 4 May 2011 09:55:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, werner <w.landgraf@ru.ru>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110504075504.GC3589@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>, werner <w.landgraf@ru.ru>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <BANLkTikFqF1vzMq3L9zDB=MDnCOFYp+XEQ@mail.gmail.com>
 <web-516990066@zbackend1.aha.ru>
 <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com>
 <20110503190822.GA20520@elte.hu>
 <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
 <4DC06386.8090206@zytor.com>
 <20110503205051.GA28647@elte.hu>
 <BANLkTin0QqwmOw2xYic0MVgvm4Rk13-yHQ@mail.gmail.com>
 <20110504071929.GB3589@liondog.tnic>
 <20110504073854.GA25724@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110504073854.GA25724@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 09:38:54AM +0200, Ingo Molnar wrote:
> 
> * Borislav Petkov <bp@alien8.de> wrote:
> 
> > On Tue, May 03, 2011 at 02:45:10PM -0700, Linus Torvalds wrote:
> > > Now, Werner is actually _running_ on an AMD Opteron (or whatever
> > > family 15 is), I think.
> > 
> > http://marc.info/?l=linux-kernel&m=130438580705332 says it's a AMD
> > Athlon(tm) 64 X2 Dual Core Processor 4800+, i.e. a good old K8 desktop.
> > The X86_ELAN Kconfig option, however, says:
> > 
> > config X86_ELAN
> > 	bool "AMD Elan"
> > 	depends on X86_32
> > 	depends on X86_EXTENDED_PLATFORM
> > 	---help---
> > 	  Select this for an AMD Elan processor.
> > 
> > 	  Do not use this option for K6/Athlon/Opteron processors!
> > 
> > 	  If unsure, choose "PC-compatible" instead.
> > 
> > so if the sentence before last used to mean anything, this could be a
> > problem. Quick search about it gives http://lkml.org/lkml/2004/1/12/239
> > which introduces that different compiler arch for ELAN: -march=i486,
> > which could conflict with the generic selection?
> 
> Well, but CONFIG_X86_ELAN=y always worked/booted fine on generic hardware - 
> including later AMD CPUs. I have booted it on an AMD Athlon64 CPU today:
> 
>  config-Wed_May__4_09_26_50_CEST_2011.good:CONFIG_X86_32_SMP=y
>  config-Wed_May__4_09_26_50_CEST_2011.good:CONFIG_MELAN=y
>  config-Wed_May__4_09_26_50_CEST_2011.good:CONFIG_SMP=y
> 
> When it comes to regressions it's past behavior that counts, not the Kconfig 
> help text.

Right, I was referring to the odd problem Linus was talking about:

"He had CONFIG_X86_EXTENDED_PLATTFORM and CONFIG_X86_ELAN on, and that
has apparently worked for him (and a lot of other people - he does a
distribution) up until 2.6.38. But as of 2.6.39-rc1 it causes some
really odd problems under IO (his test-case is "unzip", but that's
probably fairly random). The problem seems to show up as a bogus IO list
for SATA, causing a big WARN_ON() or oops and then a dead machine due to
IO problems."

So booting might've not triggered it. But reportedly .38 was fine so
yeah, the Kconfig help text might not even mean anything anymore.

Maybe I should run the same .config and test case on a K8 box here to
see what happens.

@Werner: can you send me the exact .config and the testcase that
triggers the issue?

Thanks.

-- 
Regards/Gruss,
    Boris.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131Ab1EDHTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 03:19:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47754 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab1EDHTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 03:19:36 -0400
Date: Wed, 4 May 2011 09:19:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        werner <w.landgraf@ru.ru>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110504071929.GB3589@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	werner <w.landgraf@ru.ru>, Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <web-516671337@zbackend1.aha.ru>
 <BANLkTikFqF1vzMq3L9zDB=MDnCOFYp+XEQ@mail.gmail.com>
 <web-516990066@zbackend1.aha.ru>
 <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com>
 <20110503190822.GA20520@elte.hu>
 <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
 <4DC06386.8090206@zytor.com>
 <20110503205051.GA28647@elte.hu>
 <BANLkTin0QqwmOw2xYic0MVgvm4Rk13-yHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BANLkTin0QqwmOw2xYic0MVgvm4Rk13-yHQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 02:45:10PM -0700, Linus Torvalds wrote:
> Now, Werner is actually _running_ on an AMD Opteron (or whatever
> family 15 is), I think.

http://marc.info/?l=linux-kernel&m=130438580705332 says it's a AMD
Athlon(tm) 64 X2 Dual Core Processor 4800+, i.e. a good old K8 desktop.
The X86_ELAN Kconfig option, however, says:

config X86_ELAN
	bool "AMD Elan"
	depends on X86_32
	depends on X86_EXTENDED_PLATFORM
	---help---
	  Select this for an AMD Elan processor.

	  Do not use this option for K6/Athlon/Opteron processors!

	  If unsure, choose "PC-compatible" instead.

so if the sentence before last used to mean anything, this could be a
problem. Quick search about it gives http://lkml.org/lkml/2004/1/12/239
which introduces that different compiler arch for ELAN: -march=i486,
which could conflict with the generic selection?

Hmm.

-- 
Regards/Gruss,
    Boris.

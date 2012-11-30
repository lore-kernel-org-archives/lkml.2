Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287Ab2K3SKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:10:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51567 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759040Ab2K3SKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:10:40 -0500
Date: Fri, 30 Nov 2012 19:10:37 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mario Gzuk <mariogzuk@technikz.de>
Subject: Re: [PATCH 8/8] x86, cleanups: Simplify sync_core() in the case of
 no CPUID
Message-ID: <20121130181037.GE23034@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Mario Gzuk <mariogzuk@technikz.de>
References: <1354132230-21854-1-git-send-email-hpa@linux.intel.com>
 <1354132230-21854-9-git-send-email-hpa@linux.intel.com>
 <20121128204158.GC14635@liondog.tnic>
 <50B7D28A.4000401@linux.intel.com>
 <CA+55aFziiaWt1nU-EPKc=tFd0EvSm2iSBJ2MAqxNiWP5O0mv+w@mail.gmail.com>
 <50B8F4D7.2010204@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50B8F4D7.2010204@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 10:03:03AM -0800, H. Peter Anvin wrote:
> Well, the grand total of serializing instructions are:
> 
> INVD, INVEPT, INVLPG, INVVPID, LGDT, LIDT, LLDT, LTR, MOV to CR, MOV
> to DR, WBINVD, WRMSR, CPUID, IRET, RSM.

What about MFENCE with JMP 1f to kill prefetches? Probably too
expensive. Oh and MFENCE is an SSE2 insn so maybe not supported by 486
or something later ...

> >From all of the above, the alternatives case is kinda relevant for virt
> >where we do text_poke_early in a loop for every alternative section
> >so this could pile up to a bunch of vmexits depending on the emulated
> >hardware. Might be worth a replacement if it is noticeable in guests.
> 
> This is still boot time, and I really doubt it is measurable in the
> long run.  Yes, exists suck, but at least CPUID is generally a quick
> exit, since all the relevant state is in registers.

Agreed.

-- 
Regards/Gruss,
    Boris.

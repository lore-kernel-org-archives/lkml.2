Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510Ab2K3R2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:28:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42134 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757230Ab2K3R2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:28:07 -0500
Date: Fri, 30 Nov 2012 18:28:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mario Gzuk <mariogzuk@technikz.de>
Subject: Re: [PATCH 8/8] x86, cleanups: Simplify sync_core() in the case of
 no CPUID
Message-ID: <20121130172804.GC23034@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Mario Gzuk <mariogzuk@technikz.de>
References: <1354132230-21854-1-git-send-email-hpa@linux.intel.com>
 <1354132230-21854-9-git-send-email-hpa@linux.intel.com>
 <20121128204158.GC14635@liondog.tnic>
 <50B7D28A.4000401@linux.intel.com>
 <CA+55aFziiaWt1nU-EPKc=tFd0EvSm2iSBJ2MAqxNiWP5O0mv+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFziiaWt1nU-EPKc=tFd0EvSm2iSBJ2MAqxNiWP5O0mv+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 09:01:50AM -0800, Linus Torvalds wrote:
> Hmm. The virtualization issue brings up another point: do we *really*
> want to use cpuid for serialization at all?
> 
> Exactly because under _real_ virtualization (as opposed to para-virt),
> it can cause unnecessary exits in a virtualized environment, no?

Well, in that case the function performs as advertized although it is a
very expensive serialization for virt. And virt guys hate exits.

> So I'm wondering if there is any better synchronizing instruction..
> 
> I guess sync_core() isn't used *that* much, so maybe we don't care,
> but I thought I'd ask...

Well, we use it in alternatives, MCE, intel_early_init, Intel
ucode, ftrace, and SGI's GRU thing.

>From all of the above, the alternatives case is kinda relevant for virt
where we do text_poke_early in a loop for every alternative section
so this could pile up to a bunch of vmexits depending on the emulated
hardware. Might be worth a replacement if it is noticeable in guests.

Hmm...

-- 
Regards/Gruss,
    Boris.

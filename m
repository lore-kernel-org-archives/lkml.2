Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab1GCVeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 17:34:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57723 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab1GCVeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 17:34:19 -0400
Date: Sun, 3 Jul 2011 23:34:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, Brian Gerst <brgerst@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: add missing verify_cpu to 32bit wakeup
Message-ID: <20110703213407.GA2687@elf.ucw.cz>
References: <20110701211943.GA7042@outflux.net>
 <20110703121549.GA21127@elf.ucw.cz>
 <20110703191522.GX32221@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110703191522.GX32221@outflux.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2011-07-03 12:15:22, Kees Cook wrote:
> Hi Pavel,
> 
> On Sun, Jul 03, 2011 at 02:15:49PM +0200, Pavel Machek wrote:
> > > Some BIOSes will reset the Intel XD_DISABLE MSR bit when resuming from S3,
> > > which can interact poorly with ebba638ae723d8a8fc2f7abce5ec18b688b791d7.
> > > In 32bit PAE mode, this can lead to a fault when EFER is restored by
> > > the kernel wakeup routines, due to it setting the NX bit for a CPU
> > > that (thanks to the BIOS reset) now incorrectly thinks it lacks the NX
> > > feature. 64bit wakeup already handled this through its common call path
> > > that would hit verify_cpu(). 32bit has a separate path for restoring
> > > CPU state on S3 wakeup, and needed to call verify_cpu() to handle this
> > > situation.
> > > 
> > > Signed-off-by: Kees Cook <kees.cook@canonical.com>
> > > Cc: stable@kernel.org
> > 
> > Looks ok to me, but I'm not sure it is stable material.
> 
> Well, I figured anything that shipped with
> ebba638ae723d8a8fc2f7abce5ec18b688b791d7 should get it, since it is
> a regression in the 32bit PAE with BIOS-disabled NX corner-case.

Aha, if it is an regression it makes sense for stable..

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

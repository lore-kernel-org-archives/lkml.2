Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab1GCM0B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 08:26:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34790 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab1GCM0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 08:26:00 -0400
X-Greylist: delayed 609 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Jul 2011 08:26:00 EDT
Date: Sun, 3 Jul 2011 14:15:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, Brian Gerst <brgerst@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: add missing verify_cpu to 32bit wakeup
Message-ID: <20110703121549.GA21127@elf.ucw.cz>
References: <20110701211943.GA7042@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701211943.GA7042@outflux.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Some BIOSes will reset the Intel XD_DISABLE MSR bit when resuming from S3,
> which can interact poorly with ebba638ae723d8a8fc2f7abce5ec18b688b791d7.
> In 32bit PAE mode, this can lead to a fault when EFER is restored by
> the kernel wakeup routines, due to it setting the NX bit for a CPU
> that (thanks to the BIOS reset) now incorrectly thinks it lacks the NX
> feature. 64bit wakeup already handled this through its common call path
> that would hit verify_cpu(). 32bit has a separate path for restoring
> CPU state on S3 wakeup, and needed to call verify_cpu() to handle this
> situation.
> 
> Signed-off-by: Kees Cook <kees.cook@canonical.com>
> Cc: stable@kernel.org

Looks ok to me, but I'm not sure it is stable material.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

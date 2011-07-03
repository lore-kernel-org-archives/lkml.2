Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab1GCTS0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 15:18:26 -0400
Received: from smtp.outflux.net ([198.145.64.163]:32984 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707Ab1GCTSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 15:18:23 -0400
Date: Sun, 3 Jul 2011 12:15:22 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, Brian Gerst <brgerst@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: add missing verify_cpu to 32bit wakeup
Message-ID: <20110703191522.GX32221@outflux.net>
References: <20110701211943.GA7042@outflux.net>
 <20110703121549.GA21127@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110703121549.GA21127@elf.ucw.cz>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Sun, Jul 03, 2011 at 02:15:49PM +0200, Pavel Machek wrote:
> > Some BIOSes will reset the Intel XD_DISABLE MSR bit when resuming from S3,
> > which can interact poorly with ebba638ae723d8a8fc2f7abce5ec18b688b791d7.
> > In 32bit PAE mode, this can lead to a fault when EFER is restored by
> > the kernel wakeup routines, due to it setting the NX bit for a CPU
> > that (thanks to the BIOS reset) now incorrectly thinks it lacks the NX
> > feature. 64bit wakeup already handled this through its common call path
> > that would hit verify_cpu(). 32bit has a separate path for restoring
> > CPU state on S3 wakeup, and needed to call verify_cpu() to handle this
> > situation.
> > 
> > Signed-off-by: Kees Cook <kees.cook@canonical.com>
> > Cc: stable@kernel.org
> 
> Looks ok to me, but I'm not sure it is stable material.

Well, I figured anything that shipped with
ebba638ae723d8a8fc2f7abce5ec18b688b791d7 should get it, since it is
a regression in the 32bit PAE with BIOS-disabled NX corner-case.

-Kees

-- 
Kees Cook
Ubuntu Security Team

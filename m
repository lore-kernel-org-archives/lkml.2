Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab1GAWjC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 18:39:02 -0400
Received: from smtp.outflux.net ([198.145.64.163]:44465 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757598Ab1GAWjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 18:39:00 -0400
Date: Fri, 1 Jul 2011 15:36:23 -0700
From: Kees Cook <kees.cook@canonical.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Brian Gerst <brgerst@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: add missing verify_cpu to 32bit wakeup
Message-ID: <20110701223623.GV32221@outflux.net>
References: <20110701211943.GA7042@outflux.net>
 <4E0E3B83.3000403@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0E3B83.3000403@zytor.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jul 01, 2011 at 02:26:27PM -0700, H. Peter Anvin wrote:
> On 07/01/2011 02:19 PM, Kees Cook wrote:
> > Some BIOSes will reset the Intel XD_DISABLE MSR bit when resuming from S3,
> > which can interact poorly with ebba638ae723d8a8fc2f7abce5ec18b688b791d7.
> > In 32bit PAE mode, this can lead to a fault when EFER is restored by
> > the kernel wakeup routines, due to it setting the NX bit for a CPU
> > that (thanks to the BIOS reset) now incorrectly thinks it lacks the NX
> > feature. 64bit wakeup already handled this through its common call path
> > that would hit verify_cpu(). 32bit has a separate path for restoring
> > CPU state on S3 wakeup, and needed to call verify_cpu() to handle this
> > situation.
> 
> For S3, we should save/restore MISC_ENABLE instead... in fact, we
> already save it, we just restore it too late.

Given that MISC_ENABLE may not be available for a given CPU, it seems that
it's basically the same detection code as in verify_cpu() already. Since
this bit is the only part that is needed that early, I think the patch is
good the way it is (especially since it balances the 64bit path which
already calls this logic). I don't think doing the full early MISC_ENABLE
save/restore this early is worth it. Thoughts?

-Kees

-- 
Kees Cook
Ubuntu Security Team

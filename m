Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab0JGWvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 18:51:33 -0400
Received: from trent.utfs.org ([194.246.123.103]:48717 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab0JGWvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 18:51:32 -0400
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Oct 2010 18:51:32 EDT
Date: Thu, 7 Oct 2010 15:43:55 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: takedakn@nttdata.co.jp, penguin-kernel@I-love.SAKURA.ne.jp
Subject: 2.6.36-rc7: kernel panic with SECURITY_TOMOYO=y
Message-ID: <alpine.DEB.2.01.1010071534370.21082@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wanted to test Tomoyo, so I enabled CONFIG_SECURITY_TOMOYO in my 
.config, wich enabled also:

+CONFIG_SECURITY=y
+CONFIG_SECURITYFS=y
+CONFIG_SECURITY_PATH=y
+CONFIG_SECURITY_TOMOYO=y

However, during boot the machine (PowerPC G4, 32 bit) now panics:

   http://nerdbynature.de/bits/2.6.36-rc7/

I don't have a serial console, so I ran the image of the oops through some 
OCR converter:

Kernel panic - not syncing: Profile uersion 0 is not supported
Call Trace:
[efB4fd60] [c0008c88] show_stack+0x48/0x168 (unreliable)
[ef84fda0] [c0375fe01 panic+0xa4/0x1ec
[ef84fdf0] [c01c5f30] tomoyo_close_control+0x0/0xa4
[efB4fe00] [c01cc2f0] tomoyo_load_policy+0xeB/0x11c
[ef84fe40] [c01cdd30] tomoyo_bprm_set_creds+0x84/0x88
[ef84fe50] [c01c37bc] security_bprm_set_creds+0x20/0x30
[ef84fe60] [c00a02cc] prepare_binprm+0x9e/0x128
[ef84fe90] [c00a0a10] do_execve+0x198/0x260
[ef84fed0] [e0009748] sys_execve+0x58/0x84
[efB4fef0] [c0010c1c] ret_from_syscall+0x0/0x38
--- Exception: C01 at kernel_execve+0x8/0x14
    LR = init_post+0x7c/0x138
[ef84ffb0] [c000405c] init_post+0x20/0x138 (unreliable)
[cfB4ffd0] [c043a25c] kernel_init+0x13c/0x174
[ef84fff0] [c0010974] kernel_thread+0x4c/0x68
Rebooting in 180 seconds..


(Don't trust the numbers in the first two rows though (the ones in "[]" 
brackets) the other ones should be fine)

I've not bisected the issue yet (compiling one kernel takes about ~40min 
on this box), any ideas what might have caused this?

Christian.
-- 
BOFH excuse #380:

Operators killed when huge stack of backup tapes fell over.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab1HYKjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 06:39:36 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:52325 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752414Ab1HYKjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 06:39:35 -0400
Subject: 3.1-rc3 fails to boot on my pandaboard
From: Luciano Coelho <coelho@ti.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 13:39:29 +0300
Message-ID: <1314268769.2296.283.camel@cumari>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There seems to be a problem with 3.1-rc3, which prevents it from booting
on my PandaBoard (ARM OMAP4).

3.1-rc2 works fine, so I have bisected the problem and it turns out to
be caused by this:

commit f3637a5f2e2eb391ff5757bc83fb5de8f9726464
Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date:   Thu Jul 7 22:32:17 2011 +0200

    irq: Always set IRQF_ONESHOT if no primary handler is specified

After reverting this commit, -rc3 boots fine.  I'm not sure where
exactly the problem is.  Maybe it's something in the omap code which is
broken and this patch causes the bug to show up?

What happens is that the booting process hangs after printing out this:

[...] 
[    7.408477] EXT3-fs: barriers not enabled
[    7.415008] kjournald starting.  Commit interval 5 seconds
[    7.446228] EXT3-fs (mmcblk0p5): using internal journal
[    7.452087] EXT3-fs (mmcblk0p5): mounted filesystem with ordered data mode
[    7.459625] VFS: Mounted root (ext3 filesystem) on device 179:5.
[    7.466094] Freeing init memory: 312K
[    7.471710] Failed to execute /init.  Attempting defaults...
[   10.254333] EXT3-fs (mmcblk0p5): using internal journal

The full boot logs can be found here:

http://pastebin.pandaboard.org/index.php/view/88995306

Any ideas what may be going wrong?

-- 
Cheers,
Luca.


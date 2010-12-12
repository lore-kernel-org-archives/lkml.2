Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab0LLQs3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 11:48:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:45344 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab0LLQs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 11:48:27 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCHSET] workqueue: another assorted flush_scheduled_work() removals
Date: Sun, 12 Dec 2010 17:48:13 +0100
Message-Id: <1292172499-21633-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 12 Dec 2010 16:48:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is another set of patches to remove flush_scheduled_work() users.

 0001-init-don-t-call-flush_scheduled_work-from-do_initcal.patch
 0002-ioc4-use-static-work_struct-for-ioc4_load_modules.patch
 0003-media-video-explicitly-flush-request_module-work.patch
 0004-media-video-don-t-use-flush_scheduled_work.patch
 0005-speedtch-don-t-abuse-struct-delayed_work.patch
 0006-usb-don-t-use-flush_scheduled_work.patch

Andrew, implementing proper work function in init text test requires
tracking an additional state for each worker.  I don't think it'll be
worth the effort or complexity as removal of init sections itself will
make the bugs, if exists, quite visible anyway, so I just updated
patch description of 0001.  What do you think?

0002 updates the ioc4 driver to use static work_struct and removes
flush_scheduled_work() call in the process.

0003-0004 convert the video drivers and 0005-0006 usb.

These patches are available in the following git tree.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git net-dev-kill-flush_scheduled_work

Note that the branch is on top of the previous set of
flush_scheduled_work() removal patches; however, they're independent
and this series cleanly applies on top of 2.6.37-rc5
(6313e3c21743cc88bb5bd8aa72948ee1e83937b6).

diffstat follows.  Thanks.

 drivers/media/video/bt8xx/bttv-driver.c       |    9 ++++++++
 drivers/media/video/bt8xx/bttv-input.c        |    5 ----
 drivers/media/video/cx18/cx18-driver.c        |    8 +++++++
 drivers/media/video/cx231xx/cx231xx-cards.c   |    8 +++++++
 drivers/media/video/cx23885/cx23885-input.c   |    2 -
 drivers/media/video/cx88/cx88-mpeg.c          |    8 +++++++
 drivers/media/video/em28xx/em28xx-cards.c     |    8 +++++++
 drivers/media/video/omap24xxcam.c             |    6 ++---
 drivers/media/video/saa7134/saa7134-core.c    |   11 ++++++++-
 drivers/media/video/saa7134/saa7134-empress.c |    2 -
 drivers/misc/ioc4.c                           |   29 ++++++++------------------
 drivers/usb/atm/speedtch.c                    |   27 ++++++++++++------------
 drivers/usb/gadget/u_ether.c                  |    4 ---
 drivers/usb/host/ohci-hcd.c                   |    3 +-
 drivers/usb/otg/isp1301_omap.c                |    2 -
 drivers/usb/serial/oti6858.c                  |    5 +---
 drivers/video/fb_defio.c                      |    5 +---
 init/main.c                                   |    3 --
 18 files changed, 86 insertions(+), 59 deletions(-)

--
tejun

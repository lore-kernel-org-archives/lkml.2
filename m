Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab0HXEFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 00:05:49 -0400
Received: from kroah.org ([198.145.64.141]:39654 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab0HXEF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 00:05:29 -0400
Date: Mon, 23 Aug 2010 21:05:13 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [GIT PATCH] STAGING fixes for .36-rc2
Message-ID: <20100824040513.GD16749@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some staging drivers fixes for the .36-rc2 kernel.

Some batman-adv fixes (one due to a merge I messed up), some spectra
driver build issues that lots of people are hitting, and the removal of
the "sep" driver due to the request of the original submitter (Alan
Cox.)

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

All of these patches have been in the linux-next and mm trees.

The patches will be sent as a follow-on to this message to the
driver-devel list for people to see.

thanks,

greg k-h

--------------

 drivers/staging/Kconfig                     |    2 -
 drivers/staging/Makefile                    |    1 -
 drivers/staging/batman-adv/bat_sysfs.c      |    4 +
 drivers/staging/batman-adv/hard-interface.c |   29 +-
 drivers/staging/batman-adv/icmp_socket.c    |   12 +-
 drivers/staging/batman-adv/main.c           |    7 +-
 drivers/staging/batman-adv/originator.c     |   14 +-
 drivers/staging/batman-adv/routing.c        |   16 +-
 drivers/staging/batman-adv/types.h          |    1 +
 drivers/staging/sep/Kconfig                 |   10 -
 drivers/staging/sep/Makefile                |    2 -
 drivers/staging/sep/TODO                    |    8 -
 drivers/staging/sep/sep_dev.h               |  110 --
 drivers/staging/sep/sep_driver.c            | 2742 ---------------------------
 drivers/staging/sep/sep_driver_api.h        |  425 -----
 drivers/staging/sep/sep_driver_config.h     |  225 ---
 drivers/staging/sep/sep_driver_hw_defs.h    |  232 ---
 drivers/staging/spectra/ffsport.c           |   29 +-
 drivers/staging/spectra/flash.c             |  420 +----
 19 files changed, 70 insertions(+), 4219 deletions(-)
 delete mode 100644 drivers/staging/sep/Kconfig
 delete mode 100644 drivers/staging/sep/Makefile
 delete mode 100644 drivers/staging/sep/TODO
 delete mode 100644 drivers/staging/sep/sep_dev.h
 delete mode 100644 drivers/staging/sep/sep_driver.c
 delete mode 100644 drivers/staging/sep/sep_driver_api.h
 delete mode 100644 drivers/staging/sep/sep_driver_config.h
 delete mode 100644 drivers/staging/sep/sep_driver_hw_defs.h

---------------

Greg Kroah-Hartman (1):
      Staging: sep: remove driver

Javier Martinez Canillas (7):
      Staging: spectra: removes q->prepare_flush_fn, fix build breakage
      Staging: use new REQ_FLUSH flag, fix build breakage
      Staging: spectra: don't use locked_ioctl, fix build
      Staging: spectra: remove duplicate GLOB_VERSION definition
      Staging: spectra: removes unused variable
      Staging: spectra: initializa lblk variable
      Staging: spectra: removes unused functions

Marek Lindner (4):
      Staging: batman-adv: unify orig_hash_lock spinlock handling to avoid deadlocks
      Staging: batman-adv: fix batman icmp originating from secondary interface
      Staging: batman-adv: always reply batman icmp packets with primary mac
      Staging: batman-adv: fix own mac address detection

Sven Eckelmann (4):
      Staging: batman-adv: Fix merge of linus tree
      Staging: batman-adv: Create batman_if only on register event
      Staging: batman-adv: Don't use net_dev after dev_put
      Staging: batman-adv: Don't write in not allocated packet_buff


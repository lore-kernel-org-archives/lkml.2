Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761661Ab0GTUnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:43:01 -0400
Received: from claw.goop.org ([74.207.240.146]:50927 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761584Ab0GTUmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:42:49 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Xen-devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/16] xen/blkfront: various bugfixes and patches for blkfront
Date: Tue, 20 Jul 2010 13:42:07 -0700
Message-Id: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Hi Jens,

This series has various updates to blkfront, including:
 - support for dynamic device resizing
 - bugfixes for device hotplug
 - various races and bugs fixed

It can be pulled from:

git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/blkfront

Thanks,
	J

Daniel Stodden (10):
  xenbus: Make xenbus_switch_state transactional
  blkfront: Fix backtrace in del_gendisk
  blkfront: Fix gendisk leak
  blkfront: Clean up vbd release
  blkfront: Lock blkfront_info when closing
  blkfront: Fix blkfront backend switch race (bdev open)
  blkfront: Fix blkfront backend switch race (bdev release)
  blkfront: Lock blockfront_info during xbdev removal
  blkfront: Remove obsolete info->users
  blkfront: Klog the unclean release path

Ian Campbell (1):
  xen: use less generic names in blkfront driver.

Jan Beulich (2):
  blkfront: fixes for 'xm block-detach ... --force'
  blkfront: don't access freed struct xenbus_device

Jeremy Fitzhardinge (1):
  xen/blkfront: avoid compiler warning from missing cases

K. Y. Srinivasan (2):
  xen/front: Propagate changed size of VBDs
  xen/blkfront: revalidate after setting capacity

 drivers/block/xen-blkfront.c       |  343 ++++++++++++++++++++++++++----------
 drivers/xen/xenbus/xenbus_client.c |   90 +++++++---
 2 files changed, 320 insertions(+), 113 deletions(-)


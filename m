Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab0LBAK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 19:10:57 -0500
Received: from cobra.newdream.net ([66.33.216.30]:36883 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab0LBAK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 19:10:56 -0500
Date: Wed, 1 Dec 2010 16:15:35 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, greg@kroah.com
Subject: [GIT PULL?] RBD sysfs interface snafu
Message-ID: <Pine.LNX.4.64.1012011350030.6260@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The sysfs interface for RBD (rados block device, merged in 2.6.37-rc1) was 
based on that of osdblk.  After seeing the SCST sysfs thread, though, I 
realized that was a poor example and that the existing RBD sysfs interface 
was bad news (multiple lines/items per file, incorrectly placed in 
/sys/class, etc.).  The sysfs portion of RBD really should have been 
explicitly reviewed by Greg KH beforehand--that was my fault for not 
involving him sooner.

We've fixed the interface, and now have an Acked-by from Greg, but it's 
pretty late in the cycle.  You could

 1- pull in the updated interface (changelog/diffstat below) from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git rbd-sysfs

 2- make RBD depend on CONFIG_BROKEN (Greg's suggestion)
 3- drop RBD altogether and pull it again for .38

I don't think keeping the current interface for .37 is an option.  I 
obviously prefer #1 (we're still in CONFIG_EXPERIMENTAL territory here), 
but it's clearly your call.

Thanks!
sage

---

Yehuda Sadeh (1):
      rbd: replace the rbd sysfs interface

 Documentation/ABI/testing/sysfs-bus-rbd |   83 ++++
 drivers/block/rbd.c                     |  748 +++++++++++++++++++------------
 2 files changed, 554 insertions(+), 277 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-rbd


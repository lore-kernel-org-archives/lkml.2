Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551Ab1CCRVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:21:21 -0500
Received: from adelie.canonical.com ([91.189.90.139]:44694 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758503Ab1CCRVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:21:20 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [2.6.32+drm33-longterm] Linux 2.6.32.31+drm33.14
Date: Thu,  3 Mar 2011 18:21:13 +0100
Message-Id: <1299172873-6700-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: linux-kernel@vger.kernel.org
To: stable@kernel.org
To: kernel-team@lists.ubuntu.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 2.6.32.31+drm33.14 longterm tree.

This tree is based on 2.6.32 and generally has all of the stable updates
applied. Except those to the DRM subsystem, which was based on 2.6.33 and
took updates from that upstream stable as long as that existed. It will
continue to add patches to the DRM subsystem as long as they are valid
according to the stable update rules (Documentation/stable_kernel_rules.txt).
DRM patches for this tree should be sent to kernel-team@lists.ubuntu.com.

This release contains patches from upstream 2.6.32.31, but dropped any patches
to the DRM subsystem.

The updated 2.6.32.y-drm33.z tree can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git
and can be browsed through git web via:
  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=summary

-Stefan

------

* Revert "swiotlb: fix wrong panic"
* Linux 2.6.32.31

 Makefile      |    2 +-
 lib/swiotlb.c |    6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 0789e7c..ddc0ce4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .30+drm33.14
+EXTRAVERSION = .31+drm33.14
 NAME = Man-Eating Seals of Antiquity

 # *DOCUMENTATION*
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 7740ee8..ac25cd2 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -631,10 +631,8 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	/*
 	 * Ensure that the address returned is DMA'ble
 	 */
-	if (!dma_capable(dev, dev_addr, size)) {
-		swiotlb_tbl_unmap_single(dev, map, size, dir);
-		dev_addr = swiotlb_virt_to_bus(dev, io_tlb_overflow_buffer);
-	}
+	if (!dma_capable(dev, dev_addr, size))
+		panic("map_single: bounce buffer is not DMA'ble");

 	return dev_addr;
 }

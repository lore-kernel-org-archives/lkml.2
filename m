Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab0CSPTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:19:06 -0400
Received: from kroah.org ([198.145.64.141]:45895 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348Ab0CSPS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:18:58 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@csn.ul.ie>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/12] sysfs: Initialised pci bus legacy_mem field before use
Date: Fri, 19 Mar 2010 08:18:45 -0700
Message-Id: <1269011935-8886-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <20100319151311.GA8541@kroah.com>
References: <20100319151311.GA8541@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mel@csn.ul.ie>

PPC64 is failing to boot the latest mmotm due to an uninitialised pointer in
pci_create_legacy_files(). The surprise is that machines boot at all and it
would appear to affect current mainline as well.  This patch fixes the problem.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/pci-sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index de29645..9976685 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -655,8 +655,8 @@ void pci_create_legacy_files(struct pci_bus *b)
 		goto legacy_io_err;
 
 	/* Allocated above after the legacy_io struct */
-	sysfs_bin_attr_init(b->legacy_mem);
 	b->legacy_mem = b->legacy_io + 1;
+	sysfs_bin_attr_init(b->legacy_mem);
 	b->legacy_mem->attr.name = "legacy_mem";
 	b->legacy_mem->size = 1024*1024;
 	b->legacy_mem->attr.mode = S_IRUSR | S_IWUSR;
-- 
1.7.0.2


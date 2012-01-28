Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab2A1Pdy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 10:33:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab2A1Pc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 10:32:57 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv2 06/16] edac_mc_sysfs: Fix error handling
Date: Sat, 28 Jan 2012 13:32:41 -0200
Message-Id: <1327764771-28649-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
References: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for the current csrow's nr_pages, and not for the last
csrow's nr_pages.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc_sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index fed653a..a439bed 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -957,7 +957,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 	/* CSROW error: backout what has already been registered,  */
 fail1:
 	for (i--; i >= 0; i--) {
-		if (csrow->nr_pages > 0) {
+		if (mci->csrows[i].nr_pages > 0) {
 			kobject_put(&mci->csrows[i].kobj);
 		}
 	}
-- 
1.7.8


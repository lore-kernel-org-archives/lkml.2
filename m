Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab0I3LAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 07:00:54 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41661 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab0I3LAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:00:50 -0400
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/8] EDAC: Fix error return
Date: Thu, 30 Sep 2010 13:01:42 +0200
Message-Id: <1285844509-27120-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285844509-27120-1-git-send-email-bp@amd64.org>
References: <1285844509-27120-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

We should return a negative value when we cannot get the toplevel edac
sysfs class.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/edac_mc_sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 8aad94d..aa93ad8 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -1011,7 +1011,7 @@ void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
  */
 int edac_sysfs_setup_mc_kset(void)
 {
-	int err = 0;
+	int err = -EINVAL;
 	struct sysdev_class *edac_class;
 
 	debugf1("%s()\n", __func__);
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab1EBAuH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 20:50:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab1EBAtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 20:49:40 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 1/2] vga_switcheroo: Remove unbalanced pci_enable_device
To: airlied@linux.ie, dri-devel@lists.freedesktop.org
Cc: alex.williamson@redhat.com, linux-kernel@vger.kernel.org
Date: Sun, 01 May 2011 18:49:33 -0600
Message-ID: <20110502004928.2307.25274.stgit@ul30vt.home>
In-Reply-To: <20110502004806.2307.34136.stgit@ul30vt.home>
References: <20110502004806.2307.34136.stgit@ul30vt.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is unbalanced and probably more fitting for the client
to take care of.  Remove it.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/gpu/vga/vga_switcheroo.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index e01cacb..f0f244d 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -215,7 +215,6 @@ static int vga_switchoff(struct vga_switcheroo_client *client)
 /* stage one happens before delay */
 static int vga_switchto_stage1(struct vga_switcheroo_client *new_client)
 {
-	int ret;
 	int i;
 	struct vga_switcheroo_client *active = NULL;
 
@@ -231,11 +230,6 @@ static int vga_switchto_stage1(struct vga_switcheroo_client *new_client)
 	if (!active)
 		return 0;
 
-	/* power up the first device */
-	ret = pci_enable_device(new_client->pdev);
-	if (ret)
-		return ret;
-
 	if (new_client->pwr_state == VGA_SWITCHEROO_OFF)
 		vga_switchon(new_client);
 


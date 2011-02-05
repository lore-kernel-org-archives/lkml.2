Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab1BEWjy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 17:39:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36142 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab1BEWjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 17:39:53 -0500
Date: Sun, 6 Feb 2011 01:39:45 +0300
From: Stanislav Fomichev <kernel@fomichev.me>
To: linux-kernel@vger.kernel.org
Cc: dsd@laptop.org, sameo@linux.intel.com
Subject: [PATCH] vx855: fix gpo resource releasing
Message-ID: <4d4dd1b6.83a0df0a.406e.3ed9@mx.google.com>
Mail-Followup-To: Stanislav Fomichev <kernel@fomichev.me>,
	linux-kernel@vger.kernel.org, dsd@laptop.org, sameo@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While 'if' statement checks for the vg->gpo_reserved, the wrong argument
is passed to the release_region.

Signed-off-by: Stanislav Fomichev <kernel@fomichev.me>
---
 drivers/gpio/vx855_gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/vx855_gpio.c b/drivers/gpio/vx855_gpio.c
index 8a98ee5..81d7256 100644
--- a/drivers/gpio/vx855_gpio.c
+++ b/drivers/gpio/vx855_gpio.c
@@ -277,7 +277,7 @@ out_release:
 	if (vg->gpi_reserved)
 		release_region(res_gpi->start, resource_size(res_gpi));
 	if (vg->gpo_reserved)
-		release_region(res_gpi->start, resource_size(res_gpo));
+		release_region(res_gpo->start, resource_size(res_gpo));
 	platform_set_drvdata(pdev, NULL);
 	kfree(vg);
 	return ret;
-- 
1.7.1

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab1JCBiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 21:38:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65066 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab1JCBin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 21:38:43 -0400
Subject: [PATCH] ASoC: txx9: Add __exit_p at necessary place
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Oct 2011 09:38:32 +0800
Message-ID: <1317605912.2588.0.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have __exit annotation for txx9aclc_generic_remove(),
thus add __devexit_p to wrap it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/txx9/txx9aclc-generic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/txx9/txx9aclc-generic.c b/sound/soc/txx9/txx9aclc-generic.c
index 6770e71..9b5e283 100644
--- a/sound/soc/txx9/txx9aclc-generic.c
+++ b/sound/soc/txx9/txx9aclc-generic.c
@@ -62,7 +62,7 @@ static int __exit txx9aclc_generic_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver txx9aclc_generic_driver = {
-	.remove = txx9aclc_generic_remove,
+	.remove = __exit_p(txx9aclc_generic_remove),
 	.driver = {
 		.name = "txx9aclc-generic",
 		.owner = THIS_MODULE,
-- 
1.7.4.1




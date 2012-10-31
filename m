Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935095Ab2JaIWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 04:22:23 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:38534 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935002Ab2JaIWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 04:22:16 -0400
Subject: [PATCH] hid-picolcd_cir: fix compilation
To: mchehab@infradead.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: sfr@canb.auug.org.au, bonbons@linux-vserver.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        jkosina@suse.cz
Date: Wed, 31 Oct 2012 09:22:08 +0100
Message-ID: <20121031082208.7522.22716.stgit@zeus.hardeman.nu>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c003ab1bedf0 ("[media] rc-core: add separate defines for
protocol bitmaps and numbers") overlooked hid-picolcd.

This patch (against git.linuxtv.org/media_tree.git, branch
staging/for_v3.8) fixes the compilation breakage.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/hid/hid-picolcd_cir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-picolcd_cir.c b/drivers/hid/hid-picolcd_cir.c
index 13ca919..a79e95b 100644
--- a/drivers/hid/hid-picolcd_cir.c
+++ b/drivers/hid/hid-picolcd_cir.c
@@ -116,7 +116,7 @@ int picolcd_init_cir(struct picolcd_data *data, struct hid_report *report)
 
 	rdev->priv             = data;
 	rdev->driver_type      = RC_DRIVER_IR_RAW;
-	rdev->allowed_protos   = RC_TYPE_ALL;
+	rdev->allowed_protos   = RC_BIT_ALL;
 	rdev->open             = picolcd_cir_open;
 	rdev->close            = picolcd_cir_close;
 	rdev->input_name       = data->hdev->name;


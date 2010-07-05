Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab0GEAyk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 20:54:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46510 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab0GEAyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 20:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wQ+Rs92I/p9RkoDCnVwgJkztD1eCmdIyXt+OgFKzdMUCd/+8o0ooow1g39QPQeYwKD
         6N1G+wTlIyFd6PKgOZ8nvO5OODdM15WLt3mKPGkENwEtt/sBWlGnXhIxLBMczSWnbTJS
         RbxlwM8g1RUKBJM29Kb6PRV87VN0cpwFwseN8=
Subject: [PATCH 2/2] asus_acpi: fix coding style to improve readability
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Corentin Chary <corentincj@iksaif.net>,
       Karol Kozimor <sziwan@users.sourceforge.net>,
       Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       acpi4asus-user@lists.sourceforge.net,
       platform-driver-x86@vger.kernel.org
In-Reply-To: <1278291181.12801.2.camel@mola>
References: <1278291181.12801.2.camel@mola>
Content-Type: text/plain
Date: Mon, 05 Jul 2010 08:54:40 +0800
Message-Id: <1278291280.12801.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of no match ( hotk->model == END_MODEL ),
the only posible case to return 0 is to have a Samsung P30 detected.
This patch improves readability by moving related code after if/else clause
to be inside if clause.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/asus_acpi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/asus_acpi.c b/drivers/platform/x86/asus_acpi.c
index ae0914d..e058c2b 100644
--- a/drivers/platform/x86/asus_acpi.c
+++ b/drivers/platform/x86/asus_acpi.c
@@ -1330,6 +1330,9 @@ static int asus_hotk_get_info(void)
 			hotk->model = P30;
 			printk(KERN_NOTICE
 			       "  Samsung P30 detected, supported\n");
+			hotk->methods = &model_conf[hotk->model];
+			kfree(model);
+			return 0;
 		} else {
 			hotk->model = M2E;
 			printk(KERN_NOTICE "  unsupported model %s, trying "
@@ -1339,9 +1342,6 @@ static int asus_hotk_get_info(void)
 			kfree(model);
 			return -ENODEV;
 		}
-		hotk->methods = &model_conf[hotk->model];
-		kfree(model);
-		return 0;
 	}
 	hotk->methods = &model_conf[hotk->model];
 	printk(KERN_NOTICE "  %s model detected, supported\n", string);
-- 
1.5.4.3




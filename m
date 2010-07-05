Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab0GEAxF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 20:53:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50434 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab0GEAxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 20:53:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=KRzSHb0dEIi/dzK4p/6HKf3AI5sQ8McTnJwP8S/4sEaFhXotAMbb120YBX7B9XMqNf
         e+QZwZOrxNgqAdNFChR3bH/vdaoKbNXJ7s5AU1RLS6jUtTNr0GqNDw6ExWNAbA2chW6B
         7728xspYKZgN9TLmkgRzs+tpKqr63TugY/OXk=
Subject: [PATCH 1/2] asus_acpi: fix a memory leask in asus_hotk_get_info
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
Content-Type: text/plain
Date: Mon, 05 Jul 2010 08:53:01 +0800
Message-Id: <1278291181.12801.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of no match ( hotk->model == END_MODEL ), model sholud be
kfreed before return AE_OK.
This patch includes below fixes:
1. adds a missing kfree(model) before return AE_OK.
2. asus_hotk_get_info should return int, thus return 0 instead of AE_OK.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/asus_acpi.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/asus_acpi.c b/drivers/platform/x86/asus_acpi.c
index 92fd30c..ae0914d 100644
--- a/drivers/platform/x86/asus_acpi.c
+++ b/drivers/platform/x86/asus_acpi.c
@@ -1340,7 +1340,8 @@ static int asus_hotk_get_info(void)
 			return -ENODEV;
 		}
 		hotk->methods = &model_conf[hotk->model];
-		return AE_OK;
+		kfree(model);
+		return 0;
 	}
 	hotk->methods = &model_conf[hotk->model];
 	printk(KERN_NOTICE "  %s model detected, supported\n", string);
@@ -1374,7 +1375,7 @@ static int asus_hotk_get_info(void)
 
 	kfree(model);
 
-	return AE_OK;
+	return 0;
 }
 
 static int asus_hotk_check(void)
-- 
1.5.4.3




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab0F0GsJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 02:48:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58213 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab0F0Grr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 02:47:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=C/P++AJAzXkDBwrpTbHJnqytKP0AykFaKf9OaUAvxHF24YMyYWMrF+OSCehPGwQAIy
         njVk3iou9JBbpuned3e2CypVcS/m4E2Csr32Q3WBdlC0vJVULc7WIaRHz7FWpYmzYbnW
         XI8+LaLKLDt2sow0dQybd52enMDcQKqnrfEn4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, sds@tycho.nsa.gov, lenb@kernel.org,
       linux-bluetooth@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/5]acpi:glue.c Fix warning: variable 'ret' set but not used
Date: Sat, 26 Jun 2010 23:47:24 -0700
Message-Id: <1277621246-10960-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1277621246-10960-1-git-send-email-justinmattock@gmail.com>
References: <1277621246-10960-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Im getting a warning message when building with gcc 4.6.0
  CC      drivers/acpi/glue.o
drivers/acpi/glue.c: In function 'acpi_bind_one':
drivers/acpi/glue.c:163:7: warning: variable 'ret' set but not used

The below fixes it for me. Please have a look when you have
time and let me know(bit confused with the backwardness of
&acpi_dev->dev.kobj, &dev->kobji with these two ret's)

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/acpi/glue.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 4af6301..f146165 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -166,6 +166,9 @@ static int acpi_bind_one(struct device *dev, acpi_handle handle)
 				"firmware_node");
 		ret = sysfs_create_link(&acpi_dev->dev.kobj, &dev->kobj,
 				"physical_node");
+		if (ret) {
+			printk(KERN_WARNING "dev%d: Failed to get exception\n", ret);
+		}
 		if (acpi_dev->wakeup.flags.valid) {
 			device_set_wakeup_capable(dev, true);
 			device_set_wakeup_enable(dev,
-- 
1.7.1.rc1.21.gf3bd6


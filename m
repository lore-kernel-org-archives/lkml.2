Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab0KSDBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 22:01:08 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64404 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0KSDBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 22:01:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=tbQbn9g+5P35UiAK7qEdyizqxuxIMGOAoNKTMjQvCr1TtoF8MGXC8n57nqjPcraflC
         oxQp7oODiWD1ug6m7rogm/N1EfQB672siNBEp4MgkiqGcGJCjDGjXSDQpORYZyATHaww
         jgablUmjF/9k+aj3uaq3kMBcgN2S0p50ZoPys=
Subject: [PATCH] EDAC, MCE: Fix edac_init_mce_inject error handling
From: Axel Lin <axel.lin@gmail.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 19 Nov 2010 11:05:43 +0800
Message-Id: <1290135943.23599.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, variable i will be -1 inside the latest iteration of the while loop.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/edac/mce_amd_inj.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/mce_amd_inj.c b/drivers/edac/mce_amd_inj.c
index 6db494f..733a7e7 100644
--- a/drivers/edac/mce_amd_inj.c
+++ b/drivers/edac/mce_amd_inj.c
@@ -140,7 +140,7 @@ static int __init edac_init_mce_inject(void)
 	return 0;
 
 err_sysfs_create:
-	while (i-- >= 0)
+	while (--i >= 0)
 		sysfs_remove_file(mce_kobj, &sysfs_attrs[i]->attr);
 
 	kobject_del(mce_kobj);
-- 
1.7.2




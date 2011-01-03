Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab1ACF5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 00:57:53 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59197 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab1ACF5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 00:57:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=d3c1C6WLPgoPFf0cvt/7EfSds04g1l9XTc3jjKza60okEXDC4UAjh3/XVK4bYCsc1A
         kzUXtMGBtSWoNw7Q7GSnwgaInxIz4F3LJ9zsEGVsj3IsQAEQVVRI395Gc0ChKGx2r9pH
         JbIGvFsI4j2AcGkW15EOa3u4dVtI1hxKLmakc=
Date: Mon, 3 Jan 2011 08:57:35 +0300
From: Dan Carpenter <error27@gmail.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [patch 1/2] [SCSI] target: remove an unused variable
Message-ID: <20110103055735.GU1886@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"Nicholas A. Bellinger" <nab@linux-iscsi.org>,
	James Bottomley <James.Bottomley@suse.de>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We never use "fabric_cg" and also we leak it on the success path.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 18d15ff..d7b977d 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -117,7 +117,6 @@ static struct config_group *target_core_register_fabric(
 	struct config_group *group,
 	const char *name)
 {
-	struct config_group *fabric_cg;
 	struct target_fabric_configfs *tf;
 	int ret;
 
@@ -131,9 +130,6 @@ static struct config_group *target_core_register_fabric(
 	if (transport_subsystem_check_init() < 0)
 		return ERR_PTR(-EINVAL);
 
-	fabric_cg = kzalloc(sizeof(struct config_group), GFP_KERNEL);
-	if (!(fabric_cg))
-		return ERR_PTR(-ENOMEM);
 	/*
 	 * Below are some hardcoded request_module() calls to automatically
 	 * local fabric modules when the following is called:
@@ -155,7 +151,6 @@ static struct config_group *target_core_register_fabric(
 		if (ret < 0) {
 			printk(KERN_ERR "request_module() failed for"
 				" iscsi_target_mod.ko: %d\n", ret);
-			kfree(fabric_cg);
 			return ERR_PTR(-EINVAL);
 		}
 	} else if (!(strncmp(name, "loopback", 8))) {
@@ -169,7 +164,6 @@ static struct config_group *target_core_register_fabric(
 		if (ret < 0) {
 			printk(KERN_ERR "request_module() failed for"
 				" tcm_loop.ko: %d\n", ret);
-			kfree(fabric_cg);
 			return ERR_PTR(-EINVAL);
 		}
 	}
@@ -178,7 +172,6 @@ static struct config_group *target_core_register_fabric(
 	if (!(tf)) {
 		printk(KERN_ERR "target_core_get_fabric() failed for %s\n",
 			name);
-		kfree(fabric_cg);
 		return ERR_PTR(-EINVAL);
 	}
 	printk(KERN_INFO "Target_Core_ConfigFS: REGISTER -> Located fabric:"

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab0CSPTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:19:01 -0400
Received: from kroah.org ([198.145.64.141]:45898 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab0CSPS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:18:59 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yinghai@kernel.org>,
       Eric Biederman <ebiederm@xmission.com>
Subject: [PATCH 03/12] sysfs: fix sysfs lockdep warning in ipmi code
Date: Fri, 19 Mar 2010 08:18:46 -0700
Message-Id: <1269011935-8886-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <20100319151311.GA8541@kroah.com>
References: <20100319151311.GA8541@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a sysfs lockdep warning in the ipmi code.

Thanks to Eric Biederman and Yinghai Lu for the original versions of the
patch, unfortunatly they did not submit them in a form they could be
applied in.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/ipmi/ipmi_msghandler.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index ec5e3f8..c6ad423 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -2272,42 +2272,52 @@ static int create_files(struct bmc_device *bmc)
 	bmc->device_id_attr.attr.name = "device_id";
 	bmc->device_id_attr.attr.mode = S_IRUGO;
 	bmc->device_id_attr.show = device_id_show;
+	sysfs_attr_init(&bmc->device_id_attr.attr);
 
 	bmc->provides_dev_sdrs_attr.attr.name = "provides_device_sdrs";
 	bmc->provides_dev_sdrs_attr.attr.mode = S_IRUGO;
 	bmc->provides_dev_sdrs_attr.show = provides_dev_sdrs_show;
+	sysfs_attr_init(&bmc->provides_dev_sdrs_attr.attr);
 
 	bmc->revision_attr.attr.name = "revision";
 	bmc->revision_attr.attr.mode = S_IRUGO;
 	bmc->revision_attr.show = revision_show;
+	sysfs_attr_init(&bmc->revision_attr.attr);
 
 	bmc->firmware_rev_attr.attr.name = "firmware_revision";
 	bmc->firmware_rev_attr.attr.mode = S_IRUGO;
 	bmc->firmware_rev_attr.show = firmware_rev_show;
+	sysfs_attr_init(&bmc->firmware_rev_attr.attr);
 
 	bmc->version_attr.attr.name = "ipmi_version";
 	bmc->version_attr.attr.mode = S_IRUGO;
 	bmc->version_attr.show = ipmi_version_show;
+	sysfs_attr_init(&bmc->version_attr.attr);
 
 	bmc->add_dev_support_attr.attr.name = "additional_device_support";
 	bmc->add_dev_support_attr.attr.mode = S_IRUGO;
 	bmc->add_dev_support_attr.show = add_dev_support_show;
+	sysfs_attr_init(&bmc->add_dev_support_attr.attr);
 
 	bmc->manufacturer_id_attr.attr.name = "manufacturer_id";
 	bmc->manufacturer_id_attr.attr.mode = S_IRUGO;
 	bmc->manufacturer_id_attr.show = manufacturer_id_show;
+	sysfs_attr_init(&bmc->manufacturer_id_attr.attr);
 
 	bmc->product_id_attr.attr.name = "product_id";
 	bmc->product_id_attr.attr.mode = S_IRUGO;
 	bmc->product_id_attr.show = product_id_show;
+	sysfs_attr_init(&bmc->product_id_attr.attr);
 
 	bmc->guid_attr.attr.name = "guid";
 	bmc->guid_attr.attr.mode = S_IRUGO;
 	bmc->guid_attr.show = guid_show;
+	sysfs_attr_init(&bmc->guid_attr.attr);
 
 	bmc->aux_firmware_rev_attr.attr.name = "aux_firmware_revision";
 	bmc->aux_firmware_rev_attr.attr.mode = S_IRUGO;
 	bmc->aux_firmware_rev_attr.show = aux_firmware_rev_show;
+	sysfs_attr_init(&bmc->aux_firmware_rev_attr.attr);
 
 	err = device_create_file(&bmc->dev->dev,
 			   &bmc->device_id_attr);
-- 
1.7.0.2


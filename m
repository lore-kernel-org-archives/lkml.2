Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab1FJW1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 18:27:21 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:47554 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab1FJW1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 18:27:17 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-132.messagelabs.com!1307744836!28534249!1
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.98]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs/partitions/check.c: make local symbols static
Date: Fri, 10 Jun 2011 15:26:59 -0700
User-Agent: KMail/1.9.9
CC: <jaxboe@fusionio.com>, <isimatu.yasuaki@jp.fujitsu.com>,
        <adobriyan@gmail.com>, <tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106101526.59686.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbols part_ro_show, part_alignment_offset_show, and
part_discard_alignment_show are not used outside this file and
should be marked static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>

---

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index d545e97..e3c63d1 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -237,22 +237,22 @@ ssize_t part_size_show(struct device *dev,
 	return sprintf(buf, "%llu\n",(unsigned long long)p->nr_sects);
 }
 
-ssize_t part_ro_show(struct device *dev,
-		       struct device_attribute *attr, char *buf)
+static ssize_t part_ro_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
 {
 	struct hd_struct *p = dev_to_part(dev);
 	return sprintf(buf, "%d\n", p->policy ? 1 : 0);
 }
 
-ssize_t part_alignment_offset_show(struct device *dev,
-				   struct device_attribute *attr, char *buf)
+static ssize_t part_alignment_offset_show(struct device *dev,
+					  struct device_attribute *attr, char *buf)
 {
 	struct hd_struct *p = dev_to_part(dev);
 	return sprintf(buf, "%llu\n", (unsigned long long)p->alignment_offset);
 }
 
-ssize_t part_discard_alignment_show(struct device *dev,
-				   struct device_attribute *attr, char *buf)
+static ssize_t part_discard_alignment_show(struct device *dev,
+					   struct device_attribute *attr, char *buf)
 {
 	struct hd_struct *p = dev_to_part(dev);
 	return sprintf(buf, "%u\n", p->discard_alignment);

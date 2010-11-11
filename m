Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab0KKIwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 03:52:30 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34499 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab0KKIw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 03:52:29 -0500
Subject: block: export 'ro' sysfs attribute for partitions
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 09:52:33 +0100
Message-ID: <1289465553.1486.4.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 6aae6b90a673b2921271c51d06a219be46ff0019
Author: Kay Sievers <kay.sievers@vrfy.org>
Date:   Thu Nov 11 09:42:23 2010 +0100

    block: export 'ro' sysfs attribute for partitions
    
    We already export 'ro' for the disk. This adds the same attribute
    for partitions.
    
    Cc: Karel Zak <kzak@redhat.com>
    Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 0a8b0ad..12213f7 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -237,6 +237,13 @@ ssize_t part_size_show(struct device *dev,
 	return sprintf(buf, "%llu\n",(unsigned long long)p->nr_sects);
 }
 
+ssize_t part_ro_show(struct device *dev,
+		       struct device_attribute *attr, char *buf)
+{
+	struct hd_struct *p = dev_to_part(dev);
+	return sprintf(buf, "%d\n", p->policy ? 1 : 0);
+}
+
 ssize_t part_alignment_offset_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -312,6 +319,7 @@ ssize_t part_fail_store(struct device *dev,
 static DEVICE_ATTR(partition, S_IRUGO, part_partition_show, NULL);
 static DEVICE_ATTR(start, S_IRUGO, part_start_show, NULL);
 static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
+static DEVICE_ATTR(ro, S_IRUGO, part_ro_show, NULL);
 static DEVICE_ATTR(alignment_offset, S_IRUGO, part_alignment_offset_show, NULL);
 static DEVICE_ATTR(discard_alignment, S_IRUGO, part_discard_alignment_show,
 		   NULL);
@@ -326,6 +334,7 @@ static struct attribute *part_attrs[] = {
 	&dev_attr_partition.attr,
 	&dev_attr_start.attr,
 	&dev_attr_size.attr,
+	&dev_attr_ro.attr,
 	&dev_attr_alignment_offset.attr,
 	&dev_attr_discard_alignment.attr,
 	&dev_attr_stat.attr,



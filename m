Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab1ARVDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 16:03:18 -0500
Received: from mail127.messagelabs.com ([216.82.250.115]:37584 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab1ARVDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 16:03:17 -0500
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-127.messagelabs.com!1295384591!7385432!32
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.32]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs/partitions/check.c: make local symbols static
Date: Tue, 18 Jan 2011 14:02:42 -0700
User-Agent: KMail/1.9.9
CC: <jaxboe@fusionio.com>, <tj@kernel.org>, <davem@davemloft.net>,
        <isimatu.yasuaki@jp.fujitsu.com>, <adobriyan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201101181402.42754.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbols part_alignment_offset_show and part_discard_alignment_show
are only used locally in this file and should be declared static.

Signed-off-by: H Hartley sweeten <hsweeten@visionengravers.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>

---

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 9c21119..de5a995 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -244,14 +244,14 @@ ssize_t part_ro_show(struct device *dev,
 	return sprintf(buf, "%d\n", p->policy ? 1 : 0);
 }
 
-ssize_t part_alignment_offset_show(struct device *dev,
+static ssize_t part_alignment_offset_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
 	struct hd_struct *p = dev_to_part(dev);
 	return sprintf(buf, "%llu\n", (unsigned long long)p->alignment_offset);
 }
 
-ssize_t part_discard_alignment_show(struct device *dev,
+static ssize_t part_discard_alignment_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
 	struct hd_struct *p = dev_to_part(dev);

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab2ELLBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 07:01:18 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:30042 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab2ELLBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 07:01:15 -0400
Date: Sat, 12 May 2012 14:01:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mfd: lm3533: silence a gcc warning
Message-ID: <20120512110104.GC19472@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is supposed to be umode_t.  It causes a GCC warning:
drivers/mfd/lm3533-core.c:440:2: warning: initialization from incompatible pointer type [enabled by default]
drivers/mfd/lm3533-core.c:440:2: warning: (near initialization for ‘lm3533_attribute_group.is_visible’) [enabled by default]

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/mfd/lm3533-core.c b/drivers/mfd/lm3533-core.c
index 75f4b7f..6f315d6 100644
--- a/drivers/mfd/lm3533-core.c
+++ b/drivers/mfd/lm3533-core.c
@@ -418,7 +418,7 @@ static struct attribute *lm3533_attributes[] = {
 #define to_dev_attr(_attr) \
 	container_of(_attr, struct device_attribute, attr)
 
-static mode_t lm3533_attr_is_visible(struct kobject *kobj,
+static umode_t lm3533_attr_is_visible(struct kobject *kobj,
 					     struct attribute *attr, int n)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);

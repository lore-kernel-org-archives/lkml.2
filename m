Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965485Ab2EOCSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:18:11 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53016 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964895Ab2EOCQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:30 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 038/179] atm: expose ATM device index in sysfs
Date: Mon, 14 May 2012 22:12:14 -0400
Message-ID: <1337048075-6132-39-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dcbw@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e7a46b4d0839c2a3aa2e0ae0b145f293f6738498 upstream.

It's currently exposed only through /proc which, besides requiring
screen-scraping, doesn't allow userspace to distinguish between two
identical ATM adapters with different ATM indexes.  The ATM device index
is required when using PPPoATM on a system with multiple ATM adapters.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Reviewed-by: Eric Dumazet <eric.dumazet@gmail.com>
Tested-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/atm/atm_sysfs.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/atm/atm_sysfs.c b/net/atm/atm_sysfs.c
index 799c631..67b5bcf 100644
--- a/net/atm/atm_sysfs.c
+++ b/net/atm/atm_sysfs.c
@@ -59,6 +59,14 @@ static ssize_t show_atmaddress(struct device *cdev,
 	return pos - buf;
 }
 
+static ssize_t show_atmindex(struct device *cdev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct atm_dev *adev = to_atm_dev(cdev);
+
+	return sprintf(buf, "%d\n", adev->number);
+}
+
 static ssize_t show_carrier(struct device *cdev,
 			    struct device_attribute *attr, char *buf)
 {
@@ -99,6 +107,7 @@ static ssize_t show_link_rate(struct device *cdev,
 
 static DEVICE_ATTR(address, S_IRUGO, show_address, NULL);
 static DEVICE_ATTR(atmaddress, S_IRUGO, show_atmaddress, NULL);
+static DEVICE_ATTR(atmindex, S_IRUGO, show_atmindex, NULL);
 static DEVICE_ATTR(carrier, S_IRUGO, show_carrier, NULL);
 static DEVICE_ATTR(type, S_IRUGO, show_type, NULL);
 static DEVICE_ATTR(link_rate, S_IRUGO, show_link_rate, NULL);
@@ -106,6 +115,7 @@ static DEVICE_ATTR(link_rate, S_IRUGO, show_link_rate, NULL);
 static struct device_attribute *atm_attrs[] = {
 	&dev_attr_atmaddress,
 	&dev_attr_address,
+	&dev_attr_atmindex,
 	&dev_attr_carrier,
 	&dev_attr_type,
 	&dev_attr_link_rate,
-- 
1.7.9.6


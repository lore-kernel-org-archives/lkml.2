Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805Ab1FWRid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:38:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:35506 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933756Ab1FWRi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:27 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Michal Schmidt <mschmidt@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 222/247] PCI: return correct value when writing to the "reset" attribute
Date: Thu, 23 Jun 2011 13:34:50 -0400
Message-Id: <1308850515-15242-163-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Schmidt <mschmidt@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 447c5dd7338638f526e9bcf7dcf69b4da5835c7d upstream.

A successful write() to the "reset" sysfs attribute should return the
number of bytes written, not 0. Otherwise userspace (bash) retries the
write over and over again.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/pci/pci-sysfs.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index e1783bb..4d49aea 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -971,7 +971,12 @@ static ssize_t reset_store(struct device *dev,
 
 	if (val != 1)
 		return -EINVAL;
-	return pci_reset_function(pdev);
+
+	result = pci_reset_function(pdev);
+	if (result < 0)
+		return result;
+
+	return count;
 }
 
 static struct device_attribute reset_attr = __ATTR(reset, 0200, NULL, reset_store);
-- 
1.7.4.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab0HDEZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:25:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39501 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab0HDEZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:25:38 -0400
Date: Wed, 4 Aug 2010 14:25:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Narendra K <Narendra_K@dell.com>,
        Jordan Hargrave <jordan_hargrave@dell.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: linux-next: build failure after merge of the driver-core tree
Message-Id: <20100804142531.aea95c0b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

After merging the driver-core tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/pci/pci-label.c:100: error: unknown field 'owner' specified in initializer
drivers/pci/pci-label.c:100: warning: initialization from incompatible pointer type
drivers/pci/pci-label.c:105: error: unknown field 'owner' specified in initializer
drivers/pci/pci-label.c:105: warning: initialization from incompatible pointer type

Caused by commit 60cc62ad579afa0eb5bded82e08dd0617d461d52 ("sysfs: Remove
owner field from sysfs struct attribute") interacting with commit
911e1c9b05a8e3559a7aa89083930700a0b9e7ee ("PCI: export SMBIOS provided
firmware instance and label to sysfs") from the pci tree.

I applied the following merge fix patch (Jesse, this patch can already be
applied to the pci tree without problems):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 4 Aug 2010 14:21:42 +1000
Subject: [PATCH] pci: update for owner removal from struct device_attribute

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/pci/pci-label.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
index 111500e..90c0a72 100644
--- a/drivers/pci/pci-label.c
+++ b/drivers/pci/pci-label.c
@@ -97,12 +97,12 @@ smbiosinstance_show(struct device *dev,
 }
 
 static struct device_attribute smbios_attr_label = {
-	.attr = {.name = "label", .mode = 0444, .owner = THIS_MODULE},
+	.attr = {.name = "label", .mode = 0444},
 	.show = smbioslabel_show,
 };
 
 static struct device_attribute smbios_attr_instance = {
-	.attr = {.name = "index", .mode = 0444, .owner = THIS_MODULE},
+	.attr = {.name = "index", .mode = 0444},
 	.show = smbiosinstance_show,
 };
 
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

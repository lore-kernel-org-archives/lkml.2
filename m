Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab1AER0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:26:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab1AER0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:26:42 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] PCI: sysfs: Update ROM to include default owner write access
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        alex.williamson@redhat.com, chrisw@redhat.com, avi@redhat.com
Date: Wed, 05 Jan 2011 10:26:41 -0700
Message-ID: <20110105172615.20107.20267.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI sysfs ROM interface requires an enabling write to access
the ROM image, but the default file mode is 0400.  The original
proposed patch adding sysfs ROM support was a true read-only
interface, with the enabling bit coming in as a feature request.
I suspect it was simply an oversight that the file mode didn't
get updated to match the API.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/pci/pci-sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 63d5042..8ecaac9 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1149,7 +1149,7 @@ int __must_check pci_create_sysfs_dev_files (struct pci_dev *pdev)
 		sysfs_bin_attr_init(attr);
 		attr->size = rom_size;
 		attr->attr.name = "rom";
-		attr->attr.mode = S_IRUSR;
+		attr->attr.mode = S_IRUSR | S_IWUSR;
 		attr->read = pci_read_rom;
 		attr->write = pci_write_rom;
 		retval = sysfs_create_bin_file(&pdev->dev.kobj, attr);


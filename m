Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab0IIHiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 03:38:12 -0400
Received: from mail.perches.com ([173.55.12.10]:1545 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521Ab0IIHiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 03:38:07 -0400
Subject: [PATCH] include/linux/pci.h: Make struct pci_driver.name const
 char *
From: Joe Perches <joe@perches.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <shemminger@vyatta.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 00:38:04 -0700
Message-ID: <1284017884.24986.93.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I can tell, name is never modified.

This would allow names to be assigned
from variables in non-writable sections.

static const foo[] = "bar";

struct pci_driver baz = {
	.name = foo;
};

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/include/linux/pci.h b/include/linux/pci.h
index b1d1795..acdd032 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -541,7 +541,7 @@ struct pci_error_handlers {
 struct module;
 struct pci_driver {
 	struct list_head node;
-	char *name;
+	const char *name;
 	const struct pci_device_id *id_table;	/* must be non-NULL for probe to be called */
 	int  (*probe)  (struct pci_dev *dev, const struct pci_device_id *id);	/* New device inserted */
 	void (*remove) (struct pci_dev *dev);	/* Device removed (NULL if not a hot-plug capable driver) */



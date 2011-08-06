Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab1HFJGK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 05:06:10 -0400
Received: from www17.your-server.de ([213.133.104.17]:37435 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab1HFJGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 05:06:07 -0400
Subject: [PATCH] xen/pciback: use resource_size()
From: Thomas Meyer <thomas@m3y3r.de>
To: konrad.wilk@oracle.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Date: Sat, 06 Aug 2011 11:05:35 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312621538.5589.45.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Use resource_size function on resource object
 instead of explicit computation.

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/resource_size.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/xen/xen-pciback/conf_space_header.c b/drivers/xen/xen-pciback/conf_space_header.c
--- a/drivers/xen/xen-pciback/conf_space_header.c 2011-07-26 00:46:09.730171570 +0200
+++ b/drivers/xen/xen-pciback/conf_space_header.c 2011-08-01 23:02:39.180421787 +0200
@@ -187,7 +187,7 @@ static inline void read_dev_bar(struct p
 
 	bar_info->val = res[pos].start |
 			(res[pos].flags & PCI_REGION_FLAG_MASK);
-	bar_info->len_val = res[pos].end - res[pos].start + 1;
+	bar_info->len_val = resource_size(&res[pos]);
 }
 
 static void *bar_init(struct pci_dev *dev, int offset)



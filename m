Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab2HGTxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:53:39 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:49817 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab2HGTxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:53:37 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        J Freyensee <james_p_freyensee@linux.intel.com>
Subject: [PATCH 04/41] misc: pti, add const to pci_device_id table
Date: Tue,  7 Aug 2012 21:47:29 +0200
Message-Id: <1344368886-24033-5-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is annotated as __devinitconst. Despite the annotation is useless
in most cases, const keyword is misssing there. So we are placing
non-const data into rodata section. Fix that now.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/misc/pti.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index b7eb545..5cb61f7 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -76,7 +76,7 @@ struct pti_dev {
  */
 static DEFINE_MUTEX(alloclock);
 
-static struct pci_device_id pci_ids[] __devinitconst = {
+static const struct pci_device_id pci_ids[] __devinitconst = {
 		{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x82B)},
 		{0}
 };
-- 
1.7.10.4



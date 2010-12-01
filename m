Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab0LAUwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 15:52:33 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:65005 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174Ab0LAUwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 15:52:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=ejxZzMV64dFLM9xCyKptBvSMpccQUoQQG1UaJ8JI3pUg7+QWAeOXzvJFJarqQen18l
         HPQh3auaUM8HumTiXHXDafEf20f11VgokZbhSkIk3JdaExvk8OdcQNNR8hhqLkk/VQrX
         605J13oG06L5ABdmnKzZk4tvjMdXifMox4rog=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@csr.com>
Subject: [PATCH v2 1/2] uwb: fix compiler warning on whcrc_id_table
Date: Thu,  2 Dec 2010 05:52:21 +0900
Message-Id: <1291236742-2080-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annotate whcrc_id_table as '__used' to fix following warning:

  CC      drivers/uwb/whc-rc.o
drivers/uwb/whc-rc.c:452: warning: ‘whcrc_id_table’ defined but not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: David Vrabel <david.vrabel@csr.com>
---
 drivers/uwb/whc-rc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/uwb/whc-rc.c b/drivers/uwb/whc-rc.c
index 7349558..70a004a 100644
--- a/drivers/uwb/whc-rc.c
+++ b/drivers/uwb/whc-rc.c
@@ -449,7 +449,7 @@ static int whcrc_post_reset(struct umc_dev *umc)
 }
 
 /* PCI device ID's that we handle [so it gets loaded] */
-static struct pci_device_id whcrc_id_table[] = {
+static struct pci_device_id __used whcrc_id_table[] = {
 	{ PCI_DEVICE_CLASS(PCI_CLASS_WIRELESS_WHCI, ~0) },
 	{ /* empty last entry */ }
 };
-- 
1.7.0.4


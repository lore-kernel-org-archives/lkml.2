Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab0LGPbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:31:53 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:37701 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab0LGPbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:31:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=yBuWVRHE+9MzPRE0e45ZQit2jnXrPZI93KpSGvCtxdGPf6NKmNkMWzwVvNfnXDcVKA
         v/8EiGS7/nQcajbbn+3MEuTvXsfSweyJ7O/Uv8hoVZbl9938dUcu/E3iEVRSONuJi7my
         3c0zjJ0cTTWfkeU67kfSWOuAiS3C6FJ3hP42Y=
From: Namhyung Kim <namhyung@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Subject: [PATCH 1/3] [SCSI] dpt_i2o: fix compiler warning on dptids
Date: Wed,  8 Dec 2010 00:31:34 +0900
Message-Id: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annotate dptids as '__used' to fix following warning:

  CC      drivers/scsi/dpt_i2o.o
drivers/scsi/dpt_i2o.c:183: warning: ‘dptids’ defined but not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
---
 drivers/scsi/dpt_i2o.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index cffcb10..b276077 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -180,7 +180,7 @@ static u8 adpt_read_blink_led(adpt_hba* host)
  *============================================================================
  */
 
-static struct pci_device_id dptids[] = {
+static struct pci_device_id dptids[] __used = {
 	{ PCI_DPT_VENDOR_ID, PCI_DPT_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,},
 	{ PCI_DPT_VENDOR_ID, PCI_DPT_RAPTOR_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,},
 	{ 0, }
-- 
1.7.0.4


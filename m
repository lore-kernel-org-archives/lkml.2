Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0LGPb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:31:58 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51392 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab0LGPbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:31:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=kyM2VTJYDMh+SBrBeVImgci4kAcQcA220fgulvAZjbhN7YNyhI7e8Q9xbThqK169Ef
         cTCa6UpKpjrqHlWlqDi1b/WlppiXbnwFleXHaCa8oamfRXs7DUhDY5irqjiR4VgGBHgh
         H3RL2kBUsReXEGi/woi06MXvTVAHPsdOh+mag=
From: Namhyung Kim <namhyung@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik Faith <faith@cs.unc.edu>
Subject: [PATCH 2/3] [SCSI] fdomain: fix compiler warning on fdomain_pci_tbl
Date: Wed,  8 Dec 2010 00:31:35 +0900
Message-Id: <1291735896-14541-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
References: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annotate fdomain_pci_tbl as '__used' to fix following warning:

  CC      drivers/scsi/fdomain.o
drivers/scsi/fdomain.c:1775: warning: ‘fdomain_pci_tbl’ defined but not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Rik Faith <faith@cs.unc.edu>
---
 drivers/scsi/fdomain.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 69b7aa5..974c0d9 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -1772,7 +1772,7 @@ struct scsi_host_template fdomain_driver_template = {
 #ifndef PCMCIA
 #ifdef CONFIG_PCI
 
-static struct pci_device_id fdomain_pci_tbl[] __devinitdata = {
+static struct pci_device_id fdomain_pci_tbl[] __devinitdata __used = {
 	{ PCI_VENDOR_ID_FD, PCI_DEVICE_ID_FD_36C70,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
 	{ }
-- 
1.7.0.4


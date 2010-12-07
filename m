Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab0LGO16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:27:58 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:41505 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab0LGO1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:27:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=n5FLnDe4p6dVJdWJXQkCH1kS4izHE5kvJQRh2NxnnD4MzQD7b1Zq24yS0bRCtvTyC8
         9VGfVqawbgmGfjRopaoZSnQvQZUK6lZnDlSoCon0bVAaO6cBq3+xgHCgXDhlvzGK3V9R
         N+AmWTpdXTi1QBxNxgjck1YEQJ2zVcZ5RVfFw=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Roger Wolff <R.E.Wolff@BitWizard.nl>
Subject: [PATCH 2/3] specialix: fix compiler warning on specialix_pci_tbl
Date: Tue,  7 Dec 2010 23:27:42 +0900
Message-Id: <1291732063-10384-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291732063-10384-1-git-send-email-namhyung@gmail.com>
References: <1291732063-10384-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annotate specialx_pci_tbl as '__used' to fix following warning:

  CC      drivers/char/specialix.o
drivers/char/specialix.c:2358: warning: ‘specialx_pci_tbl’ defined but not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Roger Wolff <R.E.Wolff@BitWizard.nl>
---
 drivers/char/specialix.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index a7616d2..c2bca3f 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -2355,7 +2355,7 @@ static void __exit specialix_exit_module(void)
 	func_exit();
 }
 
-static struct pci_device_id specialx_pci_tbl[] __devinitdata = {
+static struct pci_device_id specialx_pci_tbl[] __devinitdata __used = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SPECIALIX, PCI_DEVICE_ID_SPECIALIX_IO8) },
 	{ }
 };
-- 
1.7.0.4


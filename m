Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0LGO1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:27:51 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:41505 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab0LGO1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:27:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=EFwDagyu08Qr1olvepQC5gxGl72E8UXdxUW47h0IYk1DEwsufSMZQWVsRe0J7Kkfg0
         3eSMdhW1Gkn2Um8BbTGxmC2SUGQcTMnjPQyOAIu3pkPlXMOKScbZZaNMp9c1GpD0G4nJ
         AZGW7/EmPkaYm0oZ7+MbTckS1ryDTLvOtnSDk=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] rocket: fix compiler warning on rocket_pci_ids
Date: Tue,  7 Dec 2010 23:27:41 +0900
Message-Id: <1291732063-10384-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annotate rocket_pci_ids as '__used' to fix following warning:

  CC      drivers/char/rocket.o
drivers/char/rocket.c:1767: warning: ‘rocket_pci_ids’ defined but not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/char/rocket.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 8630883..3e4e73a 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -1764,7 +1764,7 @@ static void rp_flush_buffer(struct tty_struct *tty)
 
 #ifdef CONFIG_PCI
 
-static struct pci_device_id __devinitdata rocket_pci_ids[] = {
+static struct pci_device_id __devinitdata __used rocket_pci_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_RP, PCI_ANY_ID) },
 	{ }
 };
-- 
1.7.0.4


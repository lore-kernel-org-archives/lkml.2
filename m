Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab0LGQ1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 11:27:46 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48070 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab0LGQ1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 11:27:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=VAnzHP4WbXfMoVeB9VryleCkM5gNv05D0uvwwvcERnBivZnKWb4VeHYyy/sMNLJfmd
         XdkJf29ZUwvqdaR5ER1iQIn5R4V5uN4ZG31rnBAYws77uIyd7iQU3XdrWec0KJ4IfDve
         Hs/AOabp5klp1pyNnAA+4UC7VcLhRwf2yHUjk=
From: Namhyung Kim <namhyung@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] [WATCHDOG] fix compiler warning on ali_pci_tbl
Date: Wed,  8 Dec 2010 01:27:35 +0900
Message-Id: <1291739256-16380-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annotate ali_pci_tbl as '__used' to fix following warning:

  CC      drivers/watchdog/alim1535_wdt.o
drivers/watchdog/alim1535_wdt.c:304: warning: ‘ali_pci_tbl’ defined but not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/watchdog/alim1535_wdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index 1e9caea..fa4d360 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -301,7 +301,7 @@ static int ali_notify_sys(struct notifier_block *this,
  *	want to register another driver on the same PCI id.
  */
 
-static struct pci_device_id ali_pci_tbl[] = {
+static struct pci_device_id ali_pci_tbl[] __used = {
 	{ PCI_VENDOR_ID_AL, 0x1533, PCI_ANY_ID, PCI_ANY_ID,},
 	{ PCI_VENDOR_ID_AL, 0x1535, PCI_ANY_ID, PCI_ANY_ID,},
 	{ 0, },
-- 
1.7.0.4


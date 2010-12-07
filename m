Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab0LGQ1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 11:27:50 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53895 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab0LGQ1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 11:27:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=SgiRbpb0r/Oz7I9yXrTOaJoTuiz2DwPrclmCU3qSxoPrChWP+29ACzD90Ms0HLOMsQ
         LqbMIX+O3kzHVnBH8BDzgMm05aSjqZ7GotLNUYEKax04uab7UM/HDIQqwNWnW4MEILWa
         K4wAc7UsCD6f9nnKXXH/XThcF2tQNG0GZdYv4=
From: Namhyung Kim <namhyung@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] [WATCHDOG] fix compiler warning on alim7101_pci_tbl
Date: Wed,  8 Dec 2010 01:27:36 +0900
Message-Id: <1291739256-16380-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291739256-16380-1-git-send-email-namhyung@gmail.com>
References: <1291739256-16380-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annotate alim7101_pci_tbl as '__used' to fix following warning:

  CC      drivers/watchdog/alim7101_wdt.o
drivers/watchdog/alim7101_wdt.c:433: warning: ‘alim7101_pci_tbl’ defined but not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/watchdog/alim7101_wdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index d8d4da9..4b7a2b4 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -430,7 +430,7 @@ err_out:
 module_init(alim7101_wdt_init);
 module_exit(alim7101_wdt_unload);
 
-static struct pci_device_id alim7101_pci_tbl[] __devinitdata = {
+static struct pci_device_id alim7101_pci_tbl[] __devinitdata __used = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101) },
 	{ }
-- 
1.7.0.4


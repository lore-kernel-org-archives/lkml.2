Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab0LGPuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:50:05 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:50475 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab0LGPuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:50:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=HBcYuNqLaqPTvYn/mUJXELSa/Cr7gwLs42G6ecCkZcf8jGyoWA5S0eiG1OKLVTxuJo
         S5Kx/NhAnG8Gc0MdE8NqZJnjuFn0yKSY+qbqfJa5zeFiQ43NgvWByR36g2T+eeUE5W+Z
         qqblQJKGhk9VbXx9XrD1dvCsb85Kcwl5wUugg=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] telephony/ixj: fix compiler warning on ixj_pci_tbl
Date: Wed,  8 Dec 2010 00:49:53 +0900
Message-Id: <1291736993-15278-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annotate ixj_pci_tbl as '__used' to fix following warning:

  CC      drivers/telephony/ixj.o
drivers/telephony/ixj.c:287: warning: ‘ixj_pci_tbl’ defined but not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/telephony/ixj.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index 0d236f4..de92133 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -284,7 +284,7 @@ static int samplerate = 100;
 
 module_param(ixjdebug, int, 0);
 
-static struct pci_device_id ixj_pci_tbl[] __devinitdata = {
+static struct pci_device_id ixj_pci_tbl[] __devinitdata __used = {
 	{ PCI_VENDOR_ID_QUICKNET, PCI_DEVICE_ID_QUICKNET_XJ,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ }
-- 
1.7.0.4


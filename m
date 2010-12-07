Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0LGO17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:27:59 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54813 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab0LGO16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:27:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=uTSblZuA1LZevh0QAYy2CyRZcSzONWTn11oNXQ4TOv+nsf4qgIvjT3hcWamMWiNBNo
         phv5Hl/SiLNBymp1MmviIAxtfAqMxJ88TBXCwBOsXK1jrboqT5JlrRM8A6yZr9rM0gYF
         dc/NP3Cvs4Yx4LoSk6lIP4JjDKCJ6Qjq2SZU8=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, "Michael H. Warfield" <mhw@wittsend.com>
Subject: [PATCH 3/3] ip2: fix compiler warning on ip2main_pci_tbl
Date: Tue,  7 Dec 2010 23:27:43 +0900
Message-Id: <1291732063-10384-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291732063-10384-1-git-send-email-namhyung@gmail.com>
References: <1291732063-10384-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annotate ip2main_pci_tbl as '__used' to fix following warning:

  CC      drivers/char/ip2/ip2main.o
drivers/char/ip2/ip2main.c:3227: warning: ‘ip2main_pci_tbl’ defined but not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: "Michael H. Warfield" <mhw@wittsend.com>
---
 drivers/char/ip2/ip2main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index fcd02ba..c3a0253 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -3224,7 +3224,7 @@ ip2trace (unsigned short pn, unsigned char cat, unsigned char label, unsigned lo
 
 MODULE_LICENSE("GPL");
 
-static struct pci_device_id ip2main_pci_tbl[] __devinitdata = {
+static struct pci_device_id ip2main_pci_tbl[] __devinitdata __used = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTONE, PCI_DEVICE_ID_COMPUTONE_IP2EX) },
 	{ }
 };
-- 
1.7.0.4


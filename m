Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923Ab1CBDpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 22:45:53 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50686 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860Ab1CBDpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 22:45:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=la/u6nsOw0SkWUF4u7CDo32F+LbB0/CTw/rIYQS6pNrvAifM3G+Rs9UCQSF3QgD3Nx
         1a97DdZxsbJG7YokUTS51c/FbT76d9F+8cBpNvLqVNFMRWaRx2I+dsJf0KVjBnyCLuZv
         6u/stCKkzCj8PVhYSVE7a+9L+1QAhZ+eRWqTs=
Subject: [PATCH] watchdog: hpwdt: eliminate section mismatch warning
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Mingarelli <Thomas.Mingarelli@hp.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Content-Type: text/plain
Date: Wed, 02 Mar 2011 11:49:44 +0800
Message-Id: <1299037784.16464.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpwdt_init_nmi_decoding() is called in hpwdt_init_one error handling,
thus remove the  __devexit annotation of hpwdt_exit_nmi_decoding().

This patch fixes below warning:

WARNING: drivers/watchdog/hpwdt.o(.devinit.text+0x36f): Section mismatch in reference from the function hpwdt_init_one() to the function .devexit.text:hpwdt_exit_nmi_decoding()
The function __devinit hpwdt_init_one() references
a function __devexit hpwdt_exit_nmi_decoding().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __devexit annotation of
hpwdt_exit_nmi_decoding() so it may be used outside an exit section.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/watchdog/hpwdt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index d54d4ba..8cb2685 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -710,7 +710,7 @@ static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
 	return 0;
 }
 
-static void __devexit hpwdt_exit_nmi_decoding(void)
+static void hpwdt_exit_nmi_decoding(void)
 {
 	unregister_die_notifier(&die_notifier);
 	if (cru_rom_addr)
@@ -726,7 +726,7 @@ static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
 	return 0;
 }
 
-static void __devexit hpwdt_exit_nmi_decoding(void)
+static void hpwdt_exit_nmi_decoding(void)
 {
 }
 #endif /* CONFIG_HPWDT_NMI_DECODING */
-- 
1.7.2




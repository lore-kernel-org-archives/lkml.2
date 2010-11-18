Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093Ab0KRSRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 13:17:03 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63347 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758685Ab0KRSRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 13:17:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=i7kVDlQOLtr/OT7eqwGO1+mWLGwHR3eLxnlzy6UNPaPHc+H/8V4Q28/aJD6V/cyX8F
         MKc4dm66BovShZXvvkfU74QXAWAiSkqYToCViVT8vvH9YjVJTaDVMMLNZ8EL7dIpwgjV
         I0MB4izop1FawsNSAKgKqEc202iLE1iG8ndNM=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] x86: platform: olpc: fix potential NULL pointer dereference
Date: Thu, 18 Nov 2010 21:16:54 +0300
Message-Id: <1290104216-31326-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pdev is never NULL here, instead we should check pcidev as
it is returned from pci_get_device() and may be NULL.
This code dereferences NULL in pci_enable_device_io() call.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested.

 arch/x86/platform/olpc/olpc-xo1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/olpc/olpc-xo1.c b/arch/x86/platform/olpc/olpc-xo1.c
index f5442c0..c35d03a 100644
--- a/arch/x86/platform/olpc/olpc-xo1.c
+++ b/arch/x86/platform/olpc/olpc-xo1.c
@@ -94,7 +94,7 @@ static int __devinit olpc_xo1_probe(struct platform_device *pdev)
 
 	pcidev = pci_get_device(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA,
 				NULL);
-	if (!pdev)
+	if (!pcidev)
 		return -ENODEV;
 
 	r = setup_bases(pcidev);
-- 
1.7.0.4


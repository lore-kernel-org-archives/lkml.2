Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063Ab0KRSQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 13:16:56 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46620 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654Ab0KRSQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 13:16:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=xZU7KixCdKWx6vYPdGQLjZCbZA1hVkNUfuozXtqNizkiZDZEU2Wr+fEjj2l++y2Njd
         a7frwQuNbI2dQNFCOmLAqSjv8HOBOwM3x7SEV4vaxRHl18cfjQIkHauu6sne1+aM6GTi
         TOQHDwQ2QFabS6ixW5rB7pW45gmWkTAq08aSs=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Feng Tang <feng.tang@intel.com>, Alan Cox <alan@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] x86: platform: mrst: check platform_device_register() return code
Date: Thu, 18 Nov 2010 21:16:45 +0300
Message-Id: <1290104207-31279-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

platform_device_register() may fail, if so propagate the return
code from mrst_device_create().

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 I cannot compile this driver in next-20101117, so it is not tested at all.

 arch/x86/platform/mrst/vrtc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/mrst/vrtc.c b/arch/x86/platform/mrst/vrtc.c
index 4d3f770..32cd7ed 100644
--- a/arch/x86/platform/mrst/vrtc.c
+++ b/arch/x86/platform/mrst/vrtc.c
@@ -159,8 +159,7 @@ static int __init mrst_device_create(void)
 	vrtc_resources[1].start = sfi_mrtc_array[0].irq;
 	vrtc_resources[1].end = sfi_mrtc_array[0].irq;
 
-	platform_device_register(&vrtc_device);
-	return 0;
+	return platform_device_register(&vrtc_device);
 }
 
 module_init(mrst_device_create);
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399Ab0EYXYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 19:24:06 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:41756 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018Ab0EYXYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 19:24:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=J/TxO207lzkBYsMyt/2IUnY54nTkkMgrU+zfBiw+Tp5jTas9yShqUtWxaGeVZaQMFm
         9H3CMBUihrLUgxZrR2yoq4yLNoYS3r5H4TXuygpKZPHTTZQvvqdsNs9ZrXdgR04+2y2X
         c6fMen/9JKabR8aey7z3Mk7HDpluGm8XQ6QX4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: x86@kernel.org
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]X86:BUG_FIX iMac10,1 reboot issue.
Date: Tue, 25 May 2010 16:24:08 -0700
Message-Id: <1274829848-18964-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I somehow ran into this while doing a google search:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/499497

sounds vary similar to what my machine(iMac9,1) was doing.
keep in mind I dont have the hardware(if I had the cash I would),
nor the gentlemens e-mail address to contact them to test this
out.(so hopefully somebody on kernel.org, can supply the info
and/or test this out). 

cheers,

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 8e1aac8..6ed4231 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -469,6 +469,14 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
 		},
 	},
+	{	/* Handle problems with rebooting on the iMac10,1. */
+		.callback = set_pci_reboot,
+		.ident = "Apple iMac10,1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iMac10,1"),
+		},
+	},
 	{ }
 };
 
-- 
1.7.1.rc1.21.gf3bd6


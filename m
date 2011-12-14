Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab1LNVGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 16:06:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757007Ab1LNVGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 16:06:49 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mikew@google.com, x86@kernel.org, hpa@zytor.com,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/4] uefi: Populate runtime_version
Date: Wed, 14 Dec 2011 16:06:28 -0500
Message-Id: <1323896791-10858-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1323896791-10858-1-git-send-email-mjg@redhat.com>
References: <1323896791-10858-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The runtime_version field isn't getting populated, causing various UEFI
calls to fail. Fix.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/platform/efi/efi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 37718f0..4294cb5 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -552,6 +552,8 @@ void __init efi_init(void)
 		 * virtual mode.
 		 */
 		efi.get_time = phys_efi_get_time;
+
+		efi.runtime_version = runtime->hdr.revision;
 	} else
 		printk(KERN_ERR "Could not map the EFI runtime service "
 		       "table!\n");
-- 
1.7.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab2LMWF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:05:27 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:50497 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702Ab2LMWC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:02:56 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v6 21/27] x86, boot: Not need to check setup_header version
Date: Thu, 13 Dec 2012 14:02:15 -0800
Message-Id: <1355436141-8668-22-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That is for bootloader.

setup_data is in setup_header, and all bootloader is copying that
for bzImage. So for old bootloader should keep that as 0.

kexec till now for elf image, will set setup_data to 0.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/setup.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c4e7aaa..d0082a0 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -439,8 +439,6 @@ static void __init parse_setup_data(void)
 	struct setup_data *data;
 	u64 pa_data;
 
-	if (boot_params.hdr.version < 0x0209)
-		return;
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
 		u32 data_len, map_len;
@@ -476,8 +474,6 @@ static void __init e820_reserve_setup_data(void)
 	u64 pa_data;
 	int found = 0;
 
-	if (boot_params.hdr.version < 0x0209)
-		return;
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
 		data = early_memremap(pa_data, sizeof(*data));
@@ -501,8 +497,6 @@ static void __init memblock_x86_reserve_range_setup_data(void)
 	struct setup_data *data;
 	u64 pa_data;
 
-	if (boot_params.hdr.version < 0x0209)
-		return;
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
 		data = early_memremap(pa_data, sizeof(*data));
-- 
1.7.10.4


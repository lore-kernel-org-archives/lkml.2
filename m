Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab3ADAui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:50:38 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:27018 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab3ADAuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:50:35 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v7u1 24/31] x86, boot: Not need to check setup_header version for setup_data
Date: Thu,  3 Jan 2013 16:48:44 -0800
Message-Id: <1357260531-11115-25-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
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
index 2509efa..15ce495 100644
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


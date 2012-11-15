Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab2KOVzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:55:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54542 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2KOVzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:55:48 -0500
Date: Thu, 15 Nov 2012 13:55:01 -0800
From: tip-bot for Boris Ostrovsky <boris.ostrovsky@amd.com>
Message-ID: <tip-59e0b603b429d7fe654f5c7ea82f2ac7b427504c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stable@vger.kernel.org, boris.ostrovsky@amd.com,
        herrmann.der.user@googlemail.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        boris.ostrovsky@amd.com, herrmann.der.user@googlemail.com,
        tglx@linutronix.de, stable@vger.kernel.org, hpa@linux.intel.com
In-Reply-To: <1353004910-2204-1-git-send-email-boris.ostrovsky@amd.com>
References: <1353004910-2204-1-git-send-email-boris.ostrovsky@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, microcode, AMD:
  Add support for family 16h processors
Git-Commit-ID: 59e0b603b429d7fe654f5c7ea82f2ac7b427504c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 15 Nov 2012 13:55:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  59e0b603b429d7fe654f5c7ea82f2ac7b427504c
Gitweb:     http://git.kernel.org/tip/59e0b603b429d7fe654f5c7ea82f2ac7b427504c
Author:     Boris Ostrovsky <boris.ostrovsky@amd.com>
AuthorDate: Thu, 15 Nov 2012 13:41:50 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 15 Nov 2012 13:06:07 -0800

x86, microcode, AMD: Add support for family 16h processors

Add valid patch size for family 16h processors.

[ hpa: promoting to urgent/stable since it is hw enabling and trivial ]

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
Acked-by: Andreas Herrmann <herrmann.der.user@googlemail.com>
Link: http://lkml.kernel.org/r/1353004910-2204-1-git-send-email-boris.ostrovsky@amd.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@vger.kernel.org>
---
 arch/x86/kernel/microcode_amd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index b3e67ba..efdec7c 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -190,6 +190,7 @@ static unsigned int verify_patch_size(int cpu, u32 patch_size,
 #define F1XH_MPB_MAX_SIZE 2048
 #define F14H_MPB_MAX_SIZE 1824
 #define F15H_MPB_MAX_SIZE 4096
+#define F16H_MPB_MAX_SIZE 3458
 
 	switch (c->x86) {
 	case 0x14:
@@ -198,6 +199,9 @@ static unsigned int verify_patch_size(int cpu, u32 patch_size,
 	case 0x15:
 		max_size = F15H_MPB_MAX_SIZE;
 		break;
+	case 0x16:
+		max_size = F16H_MPB_MAX_SIZE;
+		break;
 	default:
 		max_size = F1XH_MPB_MAX_SIZE;
 		break;

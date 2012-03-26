Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790Ab2CZWV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 18:21:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59501 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757487Ab2CZWV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 18:21:27 -0400
Date: Mon, 26 Mar 2012 15:21:17 -0700
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-e47bb0bda46bf50f81671db502d0c903e0a32604@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jordan.l.justen@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        matt.fleming@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jordan.l.justen@intel.com, tglx@linutronix.de, matt.fleming@intel.com,
        hpa@linux.intel.com
In-Reply-To: <1332520506-6472-4-git-send-email-jordan.l.justen@intel.com>
References: <1332520506-6472-4-git-send-email-jordan.l.justen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86, efi:
  Fix NumberOfRvaAndSizes field in PE32 header for EFI_STUB
Git-Commit-ID: e47bb0bda46bf50f81671db502d0c903e0a32604
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 26 Mar 2012 15:21:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e47bb0bda46bf50f81671db502d0c903e0a32604
Gitweb:     http://git.kernel.org/tip/e47bb0bda46bf50f81671db502d0c903e0a32604
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Fri, 23 Mar 2012 09:35:06 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 26 Mar 2012 13:10:02 -0700

x86, efi: Fix NumberOfRvaAndSizes field in PE32 header for EFI_STUB

We've actually got six data directories in the header, not one. Even
though the firmware loader doesn't seem to mind, when we come to sign
the kernel image the signing tool thinks that there is no Certificate
Table data directory, even though we've allocated space for one.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1332520506-6472-4-git-send-email-jordan.l.justen@intel.com
Reviewed-by: Jordan Justen <jordan.l.justen@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/header.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 4ceb56e..8bbea6a 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -189,7 +189,7 @@ extra_header_fields:
 	.quad	0				# SizeOfHeapCommit
 #endif
 	.long	0				# LoaderFlags
-	.long	0x1				# NumberOfRvaAndSizes
+	.long	0x6				# NumberOfRvaAndSizes
 
 	.quad	0				# ExportTable
 	.quad	0				# ImportTable

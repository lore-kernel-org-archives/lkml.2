Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab1ABHXo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:23:44 -0500
Received: from mail.windriver.com ([147.11.1.11]:35746 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab1ABHXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:40 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Patrick Simmons <linuxrocks123@netscape.net>,
        Robert Richter <robert.richter@amd.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 130/260] oprofile: Add Support for Intel CPU Family 6 / Model 22 (Intel Celeron 540)
Date: Sun,  2 Jan 2011 02:17:06 -0500
Message-Id: <1293952756-15010-131-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:32.0103 (UTC) FILETIME=[D1E7E370:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Simmons <linuxrocks123@netscape.net>

commit c33f543d320843e1732534c3931da4bbd18e6c14 upstream.

This patch adds CPU type detection for the Intel Celeron 540, which is
part of the Core 2 family according to Wikipedia; the family and ID pair
is absent from the Volume 3B table referenced in the source code
comments.  I have tested this patch on an Intel Celeron 540 machine
reporting itself as Family 6 Model 22, and OProfile runs on the machine
without issue.

Spec:

 http://download.intel.com/design/mobile/SPECUPDT/317667.pdf

Signed-off-by: Patrick Simmons <linuxrocks123@netscape.net>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/oprofile/nmi_int.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 3130a4b..238526b 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -621,7 +621,9 @@ static int __init ppro_init(char **cpu_type)
 	case 14:
 		*cpu_type = "i386/core";
 		break;
-	case 15: case 23:
+	case 0x0f:
+	case 0x16:
+	case 0x17:
 		*cpu_type = "i386/core_2";
 		break;
 	case 0x1a:
-- 
1.7.3.3


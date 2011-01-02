Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab1ABHoH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:44:07 -0500
Received: from mail.windriver.com ([147.11.1.11]:36356 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab1ABHY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:28 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Robert Richter <robert.richter@amd.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 168/260] oprofile: Add Support for Intel CPU Family 6 / Model 29
Date: Sun,  2 Jan 2011 02:17:44 -0500
Message-Id: <1293952756-15010-169-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:14.0963 (UTC) FILETIME=[EB73CE30:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

commit bb7ab785ad05a97a2c9ffb3a06547ed39f3133e8 upstream.

This patch adds CPU type detection for dunnington processor (Family 6
/ Model 29) to be identified as core 2 family cpu type (wikipedia
source).

I tested oprofile on Intel(R) Xeon(R) CPU E7440 reporting itself as
model 29, and it runs without an issue.

Spec:

 http://www.intel.com/Assets/en_US/PDF/specupdate/320336.pdf

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/oprofile/nmi_int.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 238526b..ca6b336 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -624,6 +624,7 @@ static int __init ppro_init(char **cpu_type)
 	case 0x0f:
 	case 0x16:
 	case 0x17:
+	case 0x1d:
 		*cpu_type = "i386/core_2";
 		break;
 	case 0x1a:
-- 
1.7.3.3


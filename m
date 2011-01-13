Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab1AMWjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 17:39:15 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:33203 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752149Ab1AMWjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 17:39:05 -0500
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: [PATCH] oprofile: Add support for missing Intel core i7 models
Date: Thu, 13 Jan 2011 16:38:11 -0600
Message-Id: <1294958291-5626-1-git-send-email-sbohrer@rgmadvisors.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added missing core i7 models found in "Intel 64 and IA-32 Architectures
Software Developer's Manual Volume 3B: System Programming Guide",
Table B-1.  Tested with oprofile 0.9.6 on a:

model      : 44
model name : Intel(R) Xeon(R) CPU           X5680  @ 3.33GHz

Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
---
 arch/x86/oprofile/nmi_int.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index e2b7b0c..1523313 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -678,6 +678,9 @@ static int __init ppro_init(char **cpu_type)
 		break;
 	case 0x1a:
 	case 0x1e:
+	case 0x1f:
+	case 0x25:
+	case 0x2c:
 	case 0x2e:
 		spec = &op_arch_perfmon_spec;
 		*cpu_type = "i386/core_i7";
-- 
1.7.3.4


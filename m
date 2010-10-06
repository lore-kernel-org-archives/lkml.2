Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564Ab0JFXP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 19:15:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45115 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab0JFXP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 19:15:58 -0400
From: Sameer Nanda <snanda@chromium.org>
To: lenb@kernel.org, stefan.bader@canonical.com, brad.figg@canonical.com,
        gregkh@suse.de, apw@canonical.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sameer Nanda <snanda@chromium.org>
Subject: [PATCH] ACPI: Read TSC upon resume
Date: Wed,  6 Oct 2010 16:15:19 -0700
Message-Id: <1286406919-6236-1-git-send-email-snanda@chromium.org>
X-Mailer: git-send-email 1.7.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Read the TSC upon resuming and print it out. This is useful
in helping figure out amount of time spent in the BIOS when
resuming from suspend.

Change-Id: I1d6a32bd62421becddecd152d561763e5f3e1101
Signed-off-by: Sameer Nanda <snanda@chromium.org>
---
 drivers/acpi/sleep.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index c0fed2e..f0588fa 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -214,6 +214,7 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
 	acpi_status status = AE_OK;
 	unsigned long flags = 0;
 	u32 acpi_state = acpi_target_sleep_state;
+	u64 tsc;
 
 	ACPI_FLUSH_CPU_CACHE();
 
@@ -235,6 +236,9 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
 
 	case ACPI_STATE_S3:
 		do_suspend_lowlevel();
+		rdtscll(tsc);
+		printk(KERN_INFO "TSC at resume: %llu\n",
+				(unsigned long long)tsc);
 		break;
 	}
 
-- 
1.7.1


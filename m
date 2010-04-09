Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab0DIWUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:20:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:32993 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823Ab0DIWUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:20:21 -0400
Date: Fri, 9 Apr 2010 22:19:59 GMT
From: tip-bot for Mark Langsdorf <mark.langsdorf@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       mark.langsdorf@amd.com, trenn@suse.de, tglx@linutronix.de,
       borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mark.langsdorf@amd.com, tglx@linutronix.de, trenn@suse.de,
       borislav.petkov@amd.com
In-Reply-To: <1270065406-1814-6-git-send-email-bp@amd64.org>
References: <1270065406-1814-6-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] powernow-k8: Fix frequency reporting
Message-ID: <tip-679370641e3675633cad222449262abbe93a4a2a@git.kernel.org>
Git-Commit-ID: 679370641e3675633cad222449262abbe93a4a2a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 09 Apr 2010 22:19:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  679370641e3675633cad222449262abbe93a4a2a
Gitweb:     http://git.kernel.org/tip/679370641e3675633cad222449262abbe93a4a2a
Author:     Mark Langsdorf <mark.langsdorf@amd.com>
AuthorDate: Wed, 31 Mar 2010 21:56:45 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 9 Apr 2010 14:07:47 -0700

powernow-k8: Fix frequency reporting

With F10, model 10, all valid frequencies are in the ACPI _PST table.

Cc: <stable@kernel.org> # 33.x 32.x
Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
LKML-Reference: <1270065406-1814-6-git-send-email-bp@amd64.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Reviewed-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 52fce63..6f3dc8f 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -935,7 +935,8 @@ static int fill_powernow_table_pstate(struct powernow_k8_data *data,
 		powernow_table[i].index = index;
 
 		/* Frequency may be rounded for these */
-		if (boot_cpu_data.x86 == 0x10 || boot_cpu_data.x86 == 0x11) {
+		if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
+				 || boot_cpu_data.x86 == 0x11) {
 			powernow_table[i].frequency =
 				freq_from_fid_did(lo & 0x3f, (lo >> 6) & 7);
 		} else

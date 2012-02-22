Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab2BVS0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:26:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51836 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2BVS02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:26:28 -0500
Date: Wed, 22 Feb 2012 10:25:30 -0800
From: "tip-bot for Luck, Tony" <tony.luck@intel.com>
Message-ID: <tip-140f190bc3a3b6f200548d204befd998eadd63fd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tony.luck@intel.com, tglx@linutronix.de, bp@amd64.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, tony.luck@intel.com, bp@amd64.org
In-Reply-To: <4f452eb42507460426@agluck-desktop.sc.intel.com>
References: <4f452eb42507460426@agluck-desktop.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86:
  Remove some noise from boot log when starting cpus
Git-Commit-ID: 140f190bc3a3b6f200548d204befd998eadd63fd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Feb 2012 10:26:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  140f190bc3a3b6f200548d204befd998eadd63fd
Gitweb:     http://git.kernel.org/tip/140f190bc3a3b6f200548d204befd998eadd63fd
Author:     Luck, Tony <tony.luck@intel.com>
AuthorDate: Wed, 22 Feb 2012 10:06:44 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 22 Feb 2012 10:11:05 -0800

x86: Remove some noise from boot log when starting cpus

Printing the "start_ip" for every secondary cpu is very noisy on a large
system - and doesn't add any value. Drop this message.

Console log before:
Booting Node   0, Processors  #1
smpboot cpu 1: start_ip = 96000
 #2
smpboot cpu 2: start_ip = 96000
 #3
smpboot cpu 3: start_ip = 96000
 #4
smpboot cpu 4: start_ip = 96000
       ...
 #31
smpboot cpu 31: start_ip = 96000
Brought up 32 CPUs

Console log after:
Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
Booting Node   0, Processors  #16 #17 #18 #19 #20 #21 #22 #23 Ok.
Booting Node   1, Processors  #24 #25 #26 #27 #28 #29 #30 #31
Brought up 32 CPUs

Acked-by: Borislav Petkov <bp@amd64.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/4f452eb42507460426@agluck-desktop.sc.intel.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/smpboot.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 66d250c..6835752 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -740,8 +740,6 @@ do_rest:
 	 * the targeted processor.
 	 */
 
-	printk(KERN_DEBUG "smpboot cpu %d: start_ip = %lx\n", cpu, start_ip);
-
 	atomic_set(&init_deasserted, 0);
 
 	if (get_uv_system_type() != UV_NON_UNIQUE_APIC) {

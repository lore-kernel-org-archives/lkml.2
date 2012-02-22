Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab2BVUgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 15:36:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52402 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab2BVUgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 15:36:13 -0500
Date: Wed, 22 Feb 2012 12:34:28 -0800
From: "tip-bot for Luck, Tony" <tony.luck@intel.com>
Message-ID: <tip-55bc423c1274ba474b74155167d33a56ddf77558@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tony.luck@intel.com, tglx@linutronix.de, bp@amd64.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, tony.luck@intel.com, bp@amd64.org, mingo@elte.hu
In-Reply-To: <4f452eb42507460426@agluck-desktop.sc.intel.com>
References: <4f452eb42507460426@agluck-desktop.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86/debug:
  Remove ancient debugging noise from boot log when starting cpus
Git-Commit-ID: 55bc423c1274ba474b74155167d33a56ddf77558
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Feb 2012 12:34:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55bc423c1274ba474b74155167d33a56ddf77558
Gitweb:     http://git.kernel.org/tip/55bc423c1274ba474b74155167d33a56ddf77558
Author:     Luck, Tony <tony.luck@intel.com>
AuthorDate: Wed, 22 Feb 2012 10:06:44 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 22 Feb 2012 21:26:18 +0100

x86/debug: Remove ancient debugging noise from boot log when starting cpus

Printing the "start_ip" for every secondary cpu is very noisy on
a large system - and doesn't add any value. Drop this message.

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
 Booting Node   1, Processors  #24 #25 #26 #27 #28 #29 #30
 #31 Brought up 32 CPUs

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Borislav Petkov <bp@amd64.org>
Cc: castet.matthieu@free.fr
Cc: sfr@canb.auug.org.au
Cc: hpa@linux.intel.com
Cc: rjw@sisk.pl
Link: http://lkml.kernel.org/r/4f452eb42507460426@agluck-desktop.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/smpboot.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 257049d..f34f8b2 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -740,8 +740,6 @@ do_rest:
 	 * the targeted processor.
 	 */
 
-	printk(KERN_DEBUG "smpboot cpu %d: start_ip = %lx\n", cpu, start_ip);
-
 	atomic_set(&init_deasserted, 0);
 
 	if (get_uv_system_type() != UV_NON_UNIQUE_APIC) {

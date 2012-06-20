Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab2FTKmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:42:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34354 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2FTKmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:42:19 -0400
Date: Wed, 20 Jun 2012 03:42:04 -0700
From: tip-bot for Ido Yariv <ido@wizery.com>
Message-ID: <tip-abf71f3066740f3b59c3f731b4b68ed335f7b24d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, shai@scalemp.com, ido@wizery.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, shai@scalemp.com, tglx@linutronix.de,
        ido@wizery.com
In-Reply-To: <1339773055-27397-1-git-send-email-ido@wizery.com>
References: <1339773055-27397-1-git-send-email-ido@wizery.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/vsmp: Fix vector_allocation_domain'
 s return value
Git-Commit-ID: abf71f3066740f3b59c3f731b4b68ed335f7b24d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 03:42:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  abf71f3066740f3b59c3f731b4b68ed335f7b24d
Gitweb:     http://git.kernel.org/tip/abf71f3066740f3b59c3f731b4b68ed335f7b24d
Author:     Ido Yariv <ido@wizery.com>
AuthorDate: Fri, 15 Jun 2012 18:10:55 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Jun 2012 11:10:23 +0200

x86/vsmp: Fix vector_allocation_domain's return value

Commit 8637e38a ("x86/apic: Avoid useless scanning thru a
cpumask in assign_irq_vector()") modified
vector_allocation_domain() to return a boolean indicating if
cpumask is dynamic or static. Adjust vSMP's callback
implementation accordingly.

Signed-off-by: Ido Yariv <ido@wizery.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
Cc: Alexander Gordeev <agordeev@redhat.com>
Link: http://lkml.kernel.org/r/1339773055-27397-1-git-send-email-ido@wizery.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/vsmp_64.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index 3f0285a..fa5adb7 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -208,9 +208,10 @@ static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
  * In vSMP, all cpus should be capable of handling interrupts, regardless of
  * the APIC used.
  */
-static void fill_vector_allocation_domain(int cpu, struct cpumask *retmask)
+static bool fill_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	cpumask_setall(retmask);
+	return false;
 }
 
 static void vsmp_apic_post_init(void)

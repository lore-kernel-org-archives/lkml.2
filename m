Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553Ab2AHEkN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 23:40:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37180 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2AHEkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 23:40:11 -0500
Date: Sat, 7 Jan 2012 20:39:48 -0800
From: tip-bot for Don Zickus <dzickus@redhat.com>
Message-ID: <tip-e58d429209105e698e9d0357481d62b37fe9a7dd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1325866671-9797-1-git-send-email-dzickus@redhat.com>
References: <1325866671-9797-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86, reboot: Fix typo in nmi reboot path
Git-Commit-ID: e58d429209105e698e9d0357481d62b37fe9a7dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 07 Jan 2012 20:39:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e58d429209105e698e9d0357481d62b37fe9a7dd
Gitweb:     http://git.kernel.org/tip/e58d429209105e698e9d0357481d62b37fe9a7dd
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Fri, 6 Jan 2012 11:17:51 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 7 Jan 2012 12:19:37 +0100

x86, reboot: Fix typo in nmi reboot path

It was brought to my attention that my x86 change to use NMI in
the reboot path broke Intel Nehalem and Westmere boxes when
using kexec.

I realized I had mistyped the if statement in commit
3603a2512f9e69dc87914ba922eb4a0812b21cd6 and stuck the ')' in
the wrong spot.  Putting it in the right spot fixes kexec again.

Doh.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/1325866671-9797-1-git-send-email-dzickus@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 113acda..66c74f4 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -176,7 +176,7 @@ static void native_nmi_stop_other_cpus(int wait)
 	 */
 	if (num_online_cpus() > 1) {
 		/* did someone beat us here? */
-		if (atomic_cmpxchg(&stopping_cpu, -1, safe_smp_processor_id() != -1))
+		if (atomic_cmpxchg(&stopping_cpu, -1, safe_smp_processor_id()) != -1)
 			return;
 
 		if (register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,

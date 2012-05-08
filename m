Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab2EHEXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 00:23:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51292 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2EHEXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 00:23:45 -0400
Date: Mon, 7 May 2012 21:23:16 -0700
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-b2d6aba9657c7e3d027dd43ac7d7c405e0079d46@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de
In-Reply-To: <4F79D120020000780007C031@nat28.tlf.novell.com>
References: <4F79D120020000780007C031@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] x86: Allow multiple values to be specified with 
 "hpet="
Git-Commit-ID: b2d6aba9657c7e3d027dd43ac7d7c405e0079d46
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 07 May 2012 21:23:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2d6aba9657c7e3d027dd43ac7d7c405e0079d46
Gitweb:     http://git.kernel.org/tip/b2d6aba9657c7e3d027dd43ac7d7c405e0079d46
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Mon, 2 Apr 2012 15:17:36 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 7 May 2012 15:06:28 +0200

x86: Allow multiple values to be specified with "hpet="

This is particularly to be able to specify "hpet=force,verbose",
as "force" ought to be a primary candidate for also wanting to
use "verbose".

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/4F79D120020000780007C031@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/hpet.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 70bce5d..9cc7b43 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -94,13 +94,18 @@ static int hpet_verbose;
 
 static int __init hpet_setup(char *str)
 {
-	if (str) {
+	while (str) {
+		char *next = strchr(str, ',');
+
+		if (next)
+			*next++ = 0;
 		if (!strncmp("disable", str, 7))
 			boot_hpet_disable = 1;
 		if (!strncmp("force", str, 5))
 			hpet_force_user = 1;
 		if (!strncmp("verbose", str, 7))
 			hpet_verbose = 1;
+		str = next;
 	}
 	return 1;
 }

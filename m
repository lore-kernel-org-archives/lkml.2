Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab1LERwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:52:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58881 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab1LERwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:52:41 -0500
Date: Mon, 5 Dec 2011 09:52:17 -0800
From: tip-bot for Ludwig Nussel <ludwig.nussel@suse.de>
Message-ID: <tip-9af0c7a6fa860698d080481f24a342ba74b68982@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de, ludwig.nussel@suse.de, harvey.harrison@gmail.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de, ludwig.nussel@suse.de, harvey.harrison@gmail.com,
        mingo@elte.hu
In-Reply-To: <201111152246.pAFMklOB028527@wpaz5.hot.corp.google.com>
References: <201111152246.pAFMklOB028527@wpaz5.hot.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Fix mmap random address range
Git-Commit-ID: 9af0c7a6fa860698d080481f24a342ba74b68982
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 09:52:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9af0c7a6fa860698d080481f24a342ba74b68982
Gitweb:     http://git.kernel.org/tip/9af0c7a6fa860698d080481f24a342ba74b68982
Author:     Ludwig Nussel <ludwig.nussel@suse.de>
AuthorDate: Tue, 15 Nov 2011 14:46:46 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 17:07:23 +0100

x86: Fix mmap random address range

On x86_32 casting the unsigned int result of get_random_int() to
long may result in a negative value.  On x86_32 the range of
mmap_rnd() therefore was -255 to 255.  The 32bit mode on x86_64
used 0 to 255 as intended.

The bug was introduced by 675a081 ("x86: unify mmap_{32|64}.c")
in January 2008.

Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: harvey.harrison@gmail.com
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/201111152246.pAFMklOB028527@wpaz5.hot.corp.google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/mmap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 4b5ba85..845df68 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -75,9 +75,9 @@ static unsigned long mmap_rnd(void)
 	*/
 	if (current->flags & PF_RANDOMIZE) {
 		if (mmap_is_ia32())
-			rnd = (long)get_random_int() % (1<<8);
+			rnd = get_random_int() % (1<<8);
 		else
-			rnd = (long)(get_random_int() % (1<<28));
+			rnd = get_random_int() % (1<<28);
 	}
 	return rnd << PAGE_SHIFT;
 }

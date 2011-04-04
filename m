Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab1DDQEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 12:04:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:45767 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129Ab1DDQEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 12:04:47 -0400
Date: Mon, 4 Apr 2011 16:04:23 GMT
From: tip-bot for Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rakib.mullick@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rakib.mullick@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <AANLkTing52ntzRcHkODCWDKOfRF=0uhXw5-cCUhx6M54@mail.gmail.com>
References: <AANLkTing52ntzRcHkODCWDKOfRF=0uhXw5-cCUhx6M54@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mpparse: Put check_slot() into .init section
Message-ID: <tip-64d21fc194e12bdf7347019bf10325a4b3d77e7b@git.kernel.org>
Git-Commit-ID: 64d21fc194e12bdf7347019bf10325a4b3d77e7b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Apr 2011 16:04:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  64d21fc194e12bdf7347019bf10325a4b3d77e7b
Gitweb:     http://git.kernel.org/tip/64d21fc194e12bdf7347019bf10325a4b3d77e7b
Author:     Rakib Mullick <rakib.mullick@gmail.com>
AuthorDate: Sat, 2 Apr 2011 13:17:48 +0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 4 Apr 2011 17:17:19 +0200

x86, mpparse: Put check_slot() into .init section

check_slot() is only called from replace_intsrc_all() - which is
in the .init section.

So, put check_slot into the .init section as well, so it can be freed
after system boot.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
LKML-Reference: <AANLkTing52ntzRcHkODCWDKOfRF=0uhXw5-cCUhx6M54@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/mpparse.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 5a532ce..f1b2718 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -715,7 +715,7 @@ static void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare)
 	}
 }
 
-static int
+static int __init
 check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length, int count)
 {
 	int ret = 0;

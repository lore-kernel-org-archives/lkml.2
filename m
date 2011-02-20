Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab1BTNIc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 08:08:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:52641 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab1BTNI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 08:08:29 -0500
Date: Sun, 20 Feb 2011 13:07:36 GMT
From: tip-bot for Dan Carpenter <error27@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andreas.herrmann3@amd.com, amd64-microcode@amd64.org,
        error27@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        amd64-microcode@amd64.org, andreas.herrmann3@amd.com,
        error27@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        borislav.petkov@amd.com
In-Reply-To: <20110218091716.GA4384@bicker>
References: <20110218091716.GA4384@bicker>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode, AMD: Fix signedness bug in generic_load_microcode()
Message-ID: <tip-1396fa9cd2e34669253b7ca8c75f12103481f71c@git.kernel.org>
Git-Commit-ID: 1396fa9cd2e34669253b7ca8c75f12103481f71c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 20 Feb 2011 13:07:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1396fa9cd2e34669253b7ca8c75f12103481f71c
Gitweb:     http://git.kernel.org/tip/1396fa9cd2e34669253b7ca8c75f12103481f71c
Author:     Dan Carpenter <error27@gmail.com>
AuthorDate: Fri, 18 Feb 2011 12:17:16 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 20 Feb 2011 14:01:32 +0100

x86, microcode, AMD: Fix signedness bug in generic_load_microcode()

install_equiv_cpu_table() returns type int.  It uses negative
error codes so using an unsigned type breaks the error handling.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: open list:AMD MICROCODE UPD... <amd64-microcode@amd64.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
LKML-Reference: <20110218091716.GA4384@bicker>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/microcode_amd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 9fb8405..c561038 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -246,7 +246,7 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	struct microcode_header_amd *mc_hdr = NULL;
 	unsigned int mc_size, leftover;
-	unsigned long offset;
+	int offset;
 	const u8 *ucode_ptr = data;
 	void *new_mc = NULL;
 	unsigned int new_rev = uci->cpu_sig.rev;

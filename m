Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab0JZGqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 02:46:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:46069 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab0JZGqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 02:46:11 -0400
Date: Tue, 26 Oct 2010 06:45:46 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, tglx@linutronix.de, mingo@elte.hu,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, tglx@linutronix.de, borislav.petkov@amd.com,
        mingo@elte.hu
In-Reply-To: <1288015419-29543-5-git-send-email-robert.richter@amd.com>
References: <1288015419-29543-5-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mce] mce, amd: Remove goto in threshold_create_device()
Message-ID: <tip-0a17941e71f089b128514f7b5b486e20072ca7dc@git.kernel.org>
Git-Commit-ID: 0a17941e71f089b128514f7b5b486e20072ca7dc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Oct 2010 06:45:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0a17941e71f089b128514f7b5b486e20072ca7dc
Gitweb:     http://git.kernel.org/tip/0a17941e71f089b128514f7b5b486e20072ca7dc
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Mon, 25 Oct 2010 16:03:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 Oct 2010 18:59:43 +0200

mce, amd: Remove goto in threshold_create_device()

Removing the goto in threshold_create_device().

Signed-off-by: Robert Richter <robert.richter@amd.com>
Acked-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1288015419-29543-5-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index e316684..5bf2fac 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -622,9 +622,9 @@ static __cpuinit int threshold_create_device(unsigned int cpu)
 			continue;
 		err = threshold_create_bank(cpu, bank);
 		if (err)
-			goto out;
+			return err;
 	}
-out:
+
 	return err;
 }
 

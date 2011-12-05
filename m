Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab1LERgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:36:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58658 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932592Ab1LERgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:36:17 -0500
Date: Mon, 5 Dec 2011 09:35:54 -0800
From: tip-bot for Prarit Bhargava <prarit@redhat.com>
Message-ID: <tip-644ddf588f5dba34df483a6ea8abe639cc102289@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, rientjes@google.com, prarit@redhat.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, prarit@redhat.com, rientjes@google.com,
        mingo@elte.hu
In-Reply-To: <1318958650-12447-1-git-send-email-prarit@redhat.com>
References: <1318958650-12447-1-git-send-email-prarit@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] Add TAINT_FIRMWARE_WORKAROUND on MTRR fixup
Git-Commit-ID: 644ddf588f5dba34df483a6ea8abe639cc102289
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 09:35:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  644ddf588f5dba34df483a6ea8abe639cc102289
Gitweb:     http://git.kernel.org/tip/644ddf588f5dba34df483a6ea8abe639cc102289
Author:     Prarit Bhargava <prarit@redhat.com>
AuthorDate: Tue, 18 Oct 2011 13:24:10 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 13:48:50 +0100

Add TAINT_FIRMWARE_WORKAROUND on MTRR fixup

TAINT_FIRMWARE_WORKAROUND should be set when an MTRR fixup
is done.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Link: http://lkml.kernel.org/r/1318958650-12447-1-git-send-email-prarit@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mtrr/generic.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index a71efcdb..e1fe7f4 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -547,6 +547,7 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 
 		if (tmp != mask_lo) {
 			printk(KERN_WARNING "mtrr: your BIOS has configured an incorrect mask, fixing it.\n");
+			add_taint(TAINT_FIRMWARE_WORKAROUND);
 			mask_lo = tmp;
 		}
 	}

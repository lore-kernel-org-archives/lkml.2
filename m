Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab2AQRWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:22:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57344 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab2AQRWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:22:46 -0500
Date: Tue, 17 Jan 2012 09:22:33 -0800
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Message-ID: <tip-478c6e529e7bd7c6ef8994c55bd252c287c35893@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120116212050.GD5767@sgi.com>
References: <20120116212050.GD5767@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/UV2:
  Remove stale no-resources test for UV2 BAU
Git-Commit-ID: 478c6e529e7bd7c6ef8994c55bd252c287c35893
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 17 Jan 2012 09:22:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  478c6e529e7bd7c6ef8994c55bd252c287c35893
Gitweb:     http://git.kernel.org/tip/478c6e529e7bd7c6ef8994c55bd252c287c35893
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Mon, 16 Jan 2012 15:20:50 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Jan 2012 09:09:56 +0100

x86/UV2: Remove stale no-resources test for UV2 BAU

This patch removes an unnecessary test for a
no-destination-resources-available condition that looks like a
destination timeout in UV1, but is separately distinguishable in
UV2.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Link: http://lkml.kernel.org/r/20120116212050.GD5767@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/platform/uv/tlb_uv.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 9010ca7..affea50 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -642,16 +642,6 @@ static int uv2_wait_completion(struct bau_desc *bau_desc,
 		} else if (descriptor_stat == UV2H_DESC_DEST_TIMEOUT) {
 			stat->s_dtimeout++;
 			ttm = get_cycles();
-			/*
-			 * Our retries may be blocked by all destination
-			 * swack resources being consumed, and a timeout
-			 * pending.  In that case hardware returns the
-			 * ERROR that looks like a destination timeout.
-			 */
-			if (cycles_2_us(ttm - bcp->send_message) < timeout_us) {
-				bcp->conseccompletes = 0;
-				return FLUSH_RETRY_PLUGGED;
-			}
 			bcp->conseccompletes = 0;
 			return FLUSH_RETRY_TIMEOUT;
 		} else {

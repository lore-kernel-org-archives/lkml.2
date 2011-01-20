Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab1ATMTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 07:19:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:59436 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455Ab1ATMTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 07:19:12 -0500
Date: Thu, 20 Jan 2011 12:18:52 GMT
From: tip-bot for Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        arjan@linux.intel.com, davej@redhat.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, tglx@linutronix.de, davej@redhat.com,
        mingo@elte.hu
In-Reply-To: <20110120012055.GA15985@redhat.com>
References: <20110120012055.GA15985@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Update CPU cache attributes table descriptors
Message-ID: <tip-fb87ec382f9d95469df494bdee9db922594f5cd4@git.kernel.org>
Git-Commit-ID: fb87ec382f9d95469df494bdee9db922594f5cd4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 20 Jan 2011 12:18:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb87ec382f9d95469df494bdee9db922594f5cd4
Gitweb:     http://git.kernel.org/tip/fb87ec382f9d95469df494bdee9db922594f5cd4
Author:     Dave Jones <davej@redhat.com>
AuthorDate: Wed, 19 Jan 2011 20:20:56 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 20 Jan 2011 12:13:20 +0100

x86: Update CPU cache attributes table descriptors

Update to latest definitions in:

   http://www.intel.com/Assets/PDF/appnote/241618.pdf

[ Note, this update of the doc has removed some old values which
  we have listed.  I think until we have clarification that they
  were never used in production, they should be left there. ]

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
LKML-Reference: <20110120012055.GA15985@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 7283e98..ec2c19a 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -45,6 +45,7 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0x0a, LVL_1_DATA, 8 },	/* 2 way set assoc, 32 byte line size */
 	{ 0x0c, LVL_1_DATA, 16 },	/* 4-way set assoc, 32 byte line size */
 	{ 0x0d, LVL_1_DATA, 16 },	/* 4-way set assoc, 64 byte line size */
+	{ 0x0e, LVL_1_DATA, 24 },	/* 6-way set assoc, 64 byte line size */
 	{ 0x21, LVL_2,      256 },	/* 8-way set assoc, 64 byte line size */
 	{ 0x22, LVL_3,      512 },	/* 4-way set assoc, sectored cache, 64 byte line size */
 	{ 0x23, LVL_3,      MB(1) },	/* 8-way set assoc, sectored cache, 64 byte line size */
@@ -66,6 +67,7 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0x45, LVL_2,      MB(2) },	/* 4-way set assoc, 32 byte line size */
 	{ 0x46, LVL_3,      MB(4) },	/* 4-way set assoc, 64 byte line size */
 	{ 0x47, LVL_3,      MB(8) },	/* 8-way set assoc, 64 byte line size */
+	{ 0x48, LVL_2,      MB(3) },	/* 12-way set assoc, 64 byte line size */
 	{ 0x49, LVL_3,      MB(4) },	/* 16-way set assoc, 64 byte line size */
 	{ 0x4a, LVL_3,      MB(6) },	/* 12-way set assoc, 64 byte line size */
 	{ 0x4b, LVL_3,      MB(8) },	/* 16-way set assoc, 64 byte line size */
@@ -87,6 +89,7 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0x7c, LVL_2,      MB(1) },	/* 8-way set assoc, sectored cache, 64 byte line size */
 	{ 0x7d, LVL_2,      MB(2) },	/* 8-way set assoc, 64 byte line size */
 	{ 0x7f, LVL_2,      512 },	/* 2-way set assoc, 64 byte line size */
+	{ 0x80, LVL_2,      512 },	/* 8-way set assoc, 64 byte line size */
 	{ 0x82, LVL_2,      256 },	/* 8-way set assoc, 32 byte line size */
 	{ 0x83, LVL_2,      512 },	/* 8-way set assoc, 32 byte line size */
 	{ 0x84, LVL_2,      MB(1) },	/* 8-way set assoc, 32 byte line size */

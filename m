Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab1AKM3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:29:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:47455 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab1AKM3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:29:19 -0500
Date: Tue, 11 Jan 2011 12:28:58 GMT
From: tip-bot for Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, arjan@linux.intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, arjan@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110111105544.24448.27607.stgit@bob.linux.org.uk>
References: <20110111105544.24448.27607.stgit@bob.linux.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix Moorestown VRTC fixmap placement
Message-ID: <tip-fa36e956c5027d9a985d555d104d293c0a98d2c3@git.kernel.org>
Git-Commit-ID: fa36e956c5027d9a985d555d104d293c0a98d2c3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 11 Jan 2011 12:28:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa36e956c5027d9a985d555d104d293c0a98d2c3
Gitweb:     http://git.kernel.org/tip/fa36e956c5027d9a985d555d104d293c0a98d2c3
Author:     Arjan van de Ven <arjan@linux.intel.com>
AuthorDate: Tue, 11 Jan 2011 10:55:56 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 11 Jan 2011 12:46:16 +0100

x86: Fix Moorestown VRTC fixmap placement

The x86 fixmaps need to be all together... unfortunately the
VRTC one was misplaced.

This patch makes sure the MRST VRTC fixmap is put prior to the
__end_of_permanent_fixed_addresses marker.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
LKML-Reference: <20110111105544.24448.27607.stgit@bob.linux.org.uk>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/fixmap.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 0141b23..4729b2b 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -116,11 +116,11 @@ enum fixed_addresses {
 #endif
 	FIX_TEXT_POKE1,	/* reserve 2 pages for text_poke() */
 	FIX_TEXT_POKE0, /* first page is last, because allocation is backward */
-	__end_of_permanent_fixed_addresses,
-
 #ifdef	CONFIG_X86_MRST
 	FIX_LNW_VRTC,
 #endif
+	__end_of_permanent_fixed_addresses,
+
 	/*
 	 * 256 temporary boot-time mappings, used by early_ioremap(),
 	 * before ioremap() is functional.

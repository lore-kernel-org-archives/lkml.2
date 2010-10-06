Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826Ab0JFGFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 02:05:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:59448 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474Ab0JFGFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 02:05:12 -0400
Date: Wed, 6 Oct 2010 06:04:48 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, jeremy@goop.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        jeremy.fitzhardinge@citrix.com
In-Reply-To: <4C805EEA.1080205@goop.org>
References: <4C805EEA.1080205@goop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Add RESERVE_BRK_ARRAY() helper
Message-ID: <tip-161b0275e2311b8bd9609d5f32e2b703cf5d70a8@git.kernel.org>
Git-Commit-ID: 161b0275e2311b8bd9609d5f32e2b703cf5d70a8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 06 Oct 2010 06:04:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  161b0275e2311b8bd9609d5f32e2b703cf5d70a8
Gitweb:     http://git.kernel.org/tip/161b0275e2311b8bd9609d5f32e2b703cf5d70a8
Author:     Jeremy Fitzhardinge <jeremy@goop.org>
AuthorDate: Thu, 2 Sep 2010 19:35:22 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 5 Oct 2010 22:16:54 -0700

x86, mm: Add RESERVE_BRK_ARRAY() helper

This is useful when converting static arrays into boot-time brk
allocated objects.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
LKML-Reference: <4C805EEA.1080205@goop.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/setup.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index ef292c7..d6763b1 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -93,6 +93,11 @@ void *extend_brk(size_t size, size_t align);
 			: : "i" (sz));					\
 	}
 
+/* Helper for reserving space for arrays of things */
+#define RESERVE_BRK_ARRAY(type, name, entries)		\
+	type *name;					\
+	RESERVE_BRK(name, sizeof(type) * entries)
+
 #ifdef __i386__
 
 void __init i386_start_kernel(void);

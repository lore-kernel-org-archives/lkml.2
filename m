Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1DMMmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 08:42:09 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:60532 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab1DMMmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 08:42:07 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.com
Cc: slyich@gmail.com, linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/2] um: Disable CONFIG_CMPXCHG_LOCAL
Date: Wed, 13 Apr 2011 14:41:52 +0200
Message-Id: <1302698512-11979-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1302698512-11979-1-git-send-email-richard@nod.at>
References: <1302698512-11979-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8a5ec0ba "Lockless (and preemptless) fastpaths for slub"
makes use of this_cpu_cmpxchg_double() which needs
this_cpu_cmpxchg16b_emu() on x86_64.
Implementing cmpxchg16b emulation for UML would introduce
too much complexity. So just disable it.

LKML-Reference: <20110412192014.GF16342@mtj.dyndns.org>
Reported-by: Sergei Trofimovich <slyich@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/Kconfig.x86 |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/um/Kconfig.x86 b/arch/um/Kconfig.x86
index 02fb017..a9da516 100644
--- a/arch/um/Kconfig.x86
+++ b/arch/um/Kconfig.x86
@@ -4,6 +4,10 @@ menu "UML-specific options"
 
 menu "Host processor type and features"
 
+config CMPXCHG_LOCAL
+	bool
+	default n
+
 source "arch/x86/Kconfig.cpu"
 
 endmenu
-- 
1.6.6.1


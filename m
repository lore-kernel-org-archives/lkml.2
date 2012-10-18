Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab2JRTuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 15:50:24 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:57966 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab2JRTuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 15:50:21 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 2/3] kconfig: add a function to get the CONFIG_ prefix
Date: Thu, 18 Oct 2012 21:50:15 +0200
Message-Id: <1350589816-20447-3-git-send-email-yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1350589816-20447-1-git-send-email-yann.morin.1998@free.fr>
References: <1350589816-20447-1-git-send-email-yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we get the CONFIG_ prefix via the CONFIG_ macro, which means
the CONFIG_ prefix is hard-coded at compile time. This goes against
having a run-time defined CONFIG_ prefix.

Add a function that returns the CONFIG_ prefix to use (but keep the
current hard-coded behavior, to be changed in a later patch).

Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
---
 scripts/kconfig/lkc.h |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index c18f2bd..25862fd 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -36,9 +36,17 @@ extern "C" {
 #define _(text) gettext(text)
 #define N_(text) (text)
 
-#ifndef CONFIG_
-#define CONFIG_ "CONFIG_"
+/* Those two defines copied from include/linux/stringify.h */
+#define __stringify_1(x...)	#x
+#define __stringify(x...)	__stringify_1(x)
+static inline const char *CONFIG_prefix(void)
+{
+	return __stringify(CONFIG_);
+}
+#ifdef CONFIG_
+#undef CONFIG_
 #endif
+#define CONFIG_ CONFIG_prefix()
 
 #define TF_COMMAND	0x0001
 #define TF_PARAM	0x0002
-- 
1.7.2.5


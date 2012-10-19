Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157Ab2JSXHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 19:07:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45940 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478Ab2JSXGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 19:06:38 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 2/3] kconfig: add a function to get the CONFIG_ prefix
Date: Sat, 20 Oct 2012 01:06:24 +0200
Message-Id: <1350687985-21053-3-git-send-email-yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1350687985-21053-1-git-send-email-yann.morin.1998@free.fr>
References: <1350687985-21053-1-git-send-email-yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we get the CONFIG_ prefix via the CONFIG_ macro, which means
the CONFIG_ prefix is hard-coded at compile time. This goes against
having a run-time defined CONFIG_ prefix.

Add a function that returns the CONFIG_ prefix to use (but keep the
current hard-coded behavior, to be changed in a later patch).

To avoid touching all the code that uses the CONFIG_ macro, we just
undef it, and define it to be a call to the function.

Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
---
 scripts/kconfig/lkc.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index c18f2bd..7aa9db0 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -39,6 +39,12 @@ extern "C" {
 #ifndef CONFIG_
 #define CONFIG_ "CONFIG_"
 #endif
+static inline const char *CONFIG_prefix(void)
+{
+	return CONFIG_;
+}
+#undef CONFIG_
+#define CONFIG_ CONFIG_prefix()
 
 #define TF_COMMAND	0x0001
 #define TF_PARAM	0x0002
-- 
1.7.2.5


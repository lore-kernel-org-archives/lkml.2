Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1BOGL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 01:11:57 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:40737 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab1BOGLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 01:11:49 -0500
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-omap@vger.kernel.org,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Alexander Shishkin <virtuoso@slind.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] ARM: etm: Don't limit tracing to only non-secure code.
Date: Mon, 14 Feb 2011 22:11:10 -0800
Message-Id: <1297750276-12475-2-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1296701663-12168-1-git-send-email-arve@android.com>
References: <1296701663-12168-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some systems kernel code is considered secure, and this code
already limits tracing to the kernel text segment which results
in no trace data.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 arch/arm/kernel/etm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index d4ec368..6e15c48 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -55,7 +55,7 @@ static inline bool trace_isrunning(struct tracectx *t)
 static int etm_setup_address_range(struct tracectx *t, int n,
 		unsigned long start, unsigned long end, int exclude, int data)
 {
-	u32 flags = ETMAAT_ARM | ETMAAT_IGNCONTEXTID | ETMAAT_NSONLY | \
+	u32 flags = ETMAAT_ARM | ETMAAT_IGNCONTEXTID | ETMAAT_IGNSECURITY |
 		    ETMAAT_NOVALCMP;
 
 	if (n < 1 || n > t->ncmppairs)
-- 
1.7.3.1


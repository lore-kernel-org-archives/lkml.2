Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab0KDJZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 05:25:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49034 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab0KDJZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 05:25:00 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, stefani@seibold.net
Subject: [RESEND PATCH] tags: put function prototypes back!
Date: Thu,  4 Nov 2010 10:24:16 +0100
Message-Id: <1288862656-26707-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <4C176968.8070807@suse.cz>
References: <4C176968.8070807@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7db86dc (ctags: usability fix) removed function prototypes from
tags file claiming "It makes no real sense to include function
prototypes".
But it is useful for quickly determining which header file developer
needs to include to fix compilation.

Now if someone wants to remove forward declatations (which I agree are
baggage), write a postprocessing script.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 scripts/tags.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 8509bb5..e091db3 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -123,7 +123,7 @@ exuberant()
 	-I ____cacheline_internodealigned_in_smp                \
 	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL                      \
 	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
-	--extra=+f --c-kinds=-px                                \
+	--extra=+f --c-kinds=+px                                \
 	--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'                  \
 	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/'
 
-- 
1.7.2.3


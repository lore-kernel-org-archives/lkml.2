Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab0IURXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 13:23:25 -0400
Received: from mx1.spunky.mail.dreamhost.com ([208.97.132.47]:59617 "EHLO
	homiemail-a62.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754034Ab0IURXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 13:23:24 -0400
Subject: [PATCH] kmemleak: add unlikely() optimization to kmemleak_late_init
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: catalin.marinas@arm.com
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 13:23:17 -0400
Message-ID: <1285089797.2177.2.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmemleak: add unlikely() optimization to kmemleak_late_init()

Since there it is not very probable that kmemleak_disable() was called right after setting kmemleak_initialized, we could benefit from predicting it.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 mm/kmemleak.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index bd9bc21..7e2f260 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1728,7 +1728,7 @@ static int __init kmemleak_late_init(void)
 
 	atomic_set(&kmemleak_initialized, 1);
 
-	if (atomic_read(&kmemleak_error)) {
+	if (unlikely(atomic_read(&kmemleak_error))) {
 		/*
 		 * Some error occured and kmemleak was disabled. There is a
 		 * small chance that kmemleak_disable() was called immediately
-- 
1.7.0.4




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1DQUGB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 16:06:01 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51339 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab1DQUFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 16:05:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=JxI61kB0SiYx/v3Kbd5Ts1zcn+pmhBqEP8pXtB5TaRu1GkU4Xinr3ISRqZIIfg7grj
         8LYZCR8mEyl3O4v+Kteaaydu9iDJawfbTdEYSCq9/HxPGUZapATngQiuGvneWuPewT6o
         pRG63651N9XHZwtHk48EhGXlhfYa80Gw7rxy0=
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mattst88@gmail.com,
        linux-alpha@vger.kernel.org
Subject: [PATCH 4/4] alpha: Fix uninitialized value in read_persistent_clock.
Date: Sun, 17 Apr 2011 13:05:26 -0700
Message-Id: <1303070726-32155-5-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1303070726-32155-1-git-send-email-rth@twiddle.net>
References: <1303070726-32155-1-git-send-email-rth@twiddle.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/kernel/time.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index a58e84f..918e8e0 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -153,6 +153,7 @@ void read_persistent_clock(struct timespec *ts)
 		year += 100;
 
 	ts->tv_sec = mktime(year, mon, day, hour, min, sec);
+	ts->tv_nsec = 0;
 }
 
 
-- 
1.7.4.2


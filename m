Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab0IRPxj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 11:53:39 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:55044 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab0IRPxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 11:53:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VMQ3Bt+Utmn9pgj0HFyOmXJN1TF2+PwThYMDl9Mwg5GRF31Q0onKqZPVNJEFKZ2cV0
         antJ7TIE0UVKvpPHLDpttg13eJP57GGNxWsMPpb4SZs0qB96mV8K/h3pUrVVxRnfHTxX
         il/t6h+919HO7/K+SQw8oaQes3K8TRBAHFAAw=
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] printk: Change type of 'boot_delay' to int *
Date: Sun, 19 Sep 2010 00:53:01 +0900
Message-Id: <1284825182-32588-4-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284825182-32588-1-git-send-email-namhyung@gmail.com>
References: <1284825182-32588-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_option() takes its 2nd arg as int * so passing boot_delay to it
caused following warnings from sparse:

 kernel/printk.c:223:27: warning: incorrect type in argument 2 (different signedness)
 kernel/printk.c:223:27:    expected int *pint
 kernel/printk.c:223:27:    got unsigned int static [toplevel] *<noident>

Since boot_delay can't grow more than 10,000 changing it to 'int *'
will not produce any problem.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/printk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index a7aa858..e5a5c13 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -210,7 +210,7 @@ __setup("log_buf_len=", log_buf_len_setup);
 
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
-static unsigned int boot_delay; /* msecs delay after each printk during bootup */
+static int boot_delay; /* msecs delay after each printk during bootup */
 static unsigned long long loops_per_msec;	/* based on boot_delay */
 
 static int __init boot_delay_setup(char *str)
-- 
1.7.0.4


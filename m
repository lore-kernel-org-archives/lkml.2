Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab2JRJd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:33:28 -0400
Received: from smtp-out-124.synserver.de ([212.40.185.124]:1033 "EHLO
	smtp-out-124.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab2JRJd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:33:27 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 12705
From: Lars-Peter Clausen <lars@metafoo.de>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] time/jiffies: Make clocksource_jiffies static
Date: Thu, 18 Oct 2012 11:34:41 +0200
Message-Id: <1350552881-16356-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f1b8274 ("clocksource: Cleanup clocksource selection") removed all
external references to clocksource_jiffies so there is no need to have the
symbol globally visible.

Fixes the following sparse warning:
  CHECK   kernel/time/jiffies.c kernel/time/jiffies.c:61:20: warning: symbol 'clocksource_jiffies' was not declared. Should it be static?

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 kernel/time/jiffies.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index 6629bf7..25f5b26 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -58,7 +58,7 @@ static cycle_t jiffies_read(struct clocksource *cs)
 	return (cycle_t) jiffies;
 }
 
-struct clocksource clocksource_jiffies = {
+static struct clocksource clocksource_jiffies = {
 	.name		= "jiffies",
 	.rating		= 1, /* lowest valid rating*/
 	.read		= jiffies_read,
-- 
1.7.10.4


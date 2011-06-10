Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab1FJVnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 17:43:52 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:38982 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab1FJVns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 17:43:48 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-160.messagelabs.com!1307742213!25410744!22
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.99]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/time/jiffies.c: local symbols should be static
Date: Fri, 10 Jun 2011 14:43:31 -0700
User-Agent: KMail/1.9.9
CC: <torbenh@gmx.de>, <tglx@linutronix.de>, <lucas.demarchi@profusion.mobi>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106101443.31588.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol 'clocksource_jiffies' is not used outside this file and
should be marked static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Torben Hohn <torbenh@gmx.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>

---

diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index a470154..60e3ff7 100644
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

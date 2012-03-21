Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946Ab2CUS7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 14:59:53 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:28728 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799Ab2CUS7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 14:59:50 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-160.messagelabs.com!1332356387!1765191!8
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/time/jiffies.c: don't expose clocksource_jiffies globably
Date: Wed, 21 Mar 2012 11:59:37 -0700
User-Agent: KMail/1.9.9
CC: <lucas.demarchi@profusion.mobi>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201203211159.37802.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol clocksource_jiffies is only used in this file. Mark it static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
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

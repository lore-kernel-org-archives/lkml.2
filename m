Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab1HGW0W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 18:26:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52688 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab1HGW0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 18:26:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: lethal@linux-sh.org
Subject: [PATCH] sh: Fix boot crash related to SCI
Date: Mon, 8 Aug 2011 00:26:50 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108080026.50989.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Commit d006199e72a9cf9537ff567ffa07c3f343b9182a (serial:
sh-sci: Regtype probing doesn't need to be fatal.) made
sci_init_single() return when sci_probe_regmap() succeeds, although
it should return when sci_probe_regmap() fails.  This causes systems
using the serial sh-sci driver to crash during boot.

Fix the problem by using the right return condition.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/tty/serial/sh-sci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/tty/serial/sh-sci.c
===================================================================
--- linux-2.6.orig/drivers/tty/serial/sh-sci.c
+++ linux-2.6/drivers/tty/serial/sh-sci.c
@@ -1889,7 +1889,7 @@ static int __devinit sci_init_single(str
 
 	if (p->regtype == SCIx_PROBE_REGTYPE) {
 		ret = sci_probe_regmap(p);
-		if (unlikely(!ret))
+		if (unlikely(ret))
 			return ret;
 	}
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934383Ab0HEU3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:29:13 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:39096 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934330Ab0HEU3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:29:01 -0400
Date: Thu, 5 Aug 2010 22:28:59 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 39/42] drivers/mfd: Adjust confusing if indentation
Message-ID: <Pine.LNX.4.64.1008052228320.31692@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Move the call to twl4030_config_sleep_sequence into the if branch that it
is aligned with.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable braces4@
position p1,p2;
statement S1,S2;
@@

(
if (...) { ... }
|
if (...) S1@p1 S2@p2
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

if (p1[0].column == p2[0].column):
  cocci.print_main("branch",p1)
  cocci.print_secs("after",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This patch changes the semantics, and might not be what is intended.

 drivers/mfd/twl4030-power.c         |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index 7efa878..9ab5a20 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -451,12 +451,13 @@ static int __init load_twl4030_script(struct twl4030_script *tscript,
 		if (err)
 			goto out;
 	}
-	if (tscript->flags & TWL4030_SLEEP_SCRIPT)
+	if (tscript->flags & TWL4030_SLEEP_SCRIPT) {
 		if (order)
 			pr_warning("TWL4030: Bad order of scripts (sleep "\
 					"script before wakeup) Leads to boot"\
 					"failure on some boards\n");
 		err = twl4030_config_sleep_sequence(address);
+	}
 out:
 	return err;
 }

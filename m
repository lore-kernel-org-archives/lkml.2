Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0FTNkq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 09:40:46 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:58643 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567Ab0FTNkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 09:40:42 -0400
Date: Sun, 20 Jun 2010 15:40:37 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/3] drivers/media/dvb/frontends: remove duplicate structure
 field initialization
Message-ID: <Pine.LNX.4.64.1006201540210.6207@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The read_status field is initialized twice to the same value.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier I, s, fld;
position p0,p;
expression E;
@@

struct I s =@p0 { ... .fld@p = E, ...};

@s@
identifier I, s, r.fld;
position r.p0,p;
expression E;
@@

struct I s =@p0 { ... .fld@p = E, ...};

@script:python@
p0 << r.p0;
fld << r.fld;
ps << s.p;
pr << r.p;
@@

if int(ps[0].line)<int(pr[0].line) or int(ps[0].column)<int(pr[0].column):
  cocci.print_main(fld,p0)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/dvb/frontends/mb86a16.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/dvb/frontends/mb86a16.c b/drivers/media/dvb/frontends/mb86a16.c
index 599d1aa..33b6323 100644
--- a/drivers/media/dvb/frontends/mb86a16.c
+++ b/drivers/media/dvb/frontends/mb86a16.c
@@ -1833,7 +1833,6 @@ static struct dvb_frontend_ops mb86a16_ops = {
 
 	.get_frontend_algo		= mb86a16_frontend_algo,
 	.search				= mb86a16_search,
-	.read_status			= mb86a16_read_status,
 	.init				= mb86a16_init,
 	.sleep				= mb86a16_sleep,
 	.read_status			= mb86a16_read_status,

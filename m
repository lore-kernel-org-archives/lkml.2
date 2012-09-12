Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502Ab2ILM5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:57:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37861 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758355Ab2ILM42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:56:28 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/8] drivers/media/dvb-frontends/dvb_dummy_fe.c: Removes useless kfree()
Date: Wed, 12 Sep 2012 14:56:04 +0200
Message-Id: <1347454564-5178-8-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Remove useless kfree() and clean up code related to the removal.

The semantic patch that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
position p1,p2;
expression x;
@@

if (x@p1 == NULL) { ... kfree@p2(x); ... return ...; }

@unchanged exists@
position r.p1,r.p2;
expression e <= r.x,x,e1;
iterator I;
statement S;
@@

if (x@p1 == NULL) { ... when != I(x,...) S
                        when != e = e1
                        when != e += e1
                        when != e -= e1
                        when != ++e
                        when != --e
                        when != e++
                        when != e--
                        when != &e
   kfree@p2(x); ... return ...; }

@ok depends on unchanged exists@
position any r.p1;
position r.p2;
expression x;
@@

... when != true x@p1 == NULL
kfree@p2(x);

@depends on !ok && unchanged@
position r.p2;
expression x;
@@

*kfree@p2(x);
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/media/dvb-frontends/dvb_dummy_fe.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/media/dvb-frontends/dvb_dummy_fe.c b/drivers/media/dvb-frontends/dvb_dummy_fe.c
index dcfc902..d5acc30 100644
--- a/drivers/media/dvb-frontends/dvb_dummy_fe.c
+++ b/drivers/media/dvb-frontends/dvb_dummy_fe.c
@@ -121,16 +121,13 @@ struct dvb_frontend* dvb_dummy_fe_ofdm_attach(void)
 
 	/* allocate memory for the internal state */
 	state = kzalloc(sizeof(struct dvb_dummy_fe_state), GFP_KERNEL);
-	if (state == NULL) goto error;
+	if (!state)
+		return NULL;
 
 	/* create dvb_frontend */
 	memcpy(&state->frontend.ops, &dvb_dummy_fe_ofdm_ops, sizeof(struct dvb_frontend_ops));
 	state->frontend.demodulator_priv = state;
 	return &state->frontend;
-
-error:
-	kfree(state);
-	return NULL;
 }
 
 static struct dvb_frontend_ops dvb_dummy_fe_qpsk_ops;
@@ -141,16 +138,13 @@ struct dvb_frontend *dvb_dummy_fe_qpsk_attach(void)
 
 	/* allocate memory for the internal state */
 	state = kzalloc(sizeof(struct dvb_dummy_fe_state), GFP_KERNEL);
-	if (state == NULL) goto error;
+	if (!state)
+		return NULL;
 
 	/* create dvb_frontend */
 	memcpy(&state->frontend.ops, &dvb_dummy_fe_qpsk_ops, sizeof(struct dvb_frontend_ops));
 	state->frontend.demodulator_priv = state;
 	return &state->frontend;
-
-error:
-	kfree(state);
-	return NULL;
 }
 
 static struct dvb_frontend_ops dvb_dummy_fe_qam_ops;
@@ -161,16 +155,13 @@ struct dvb_frontend *dvb_dummy_fe_qam_attach(void)
 
 	/* allocate memory for the internal state */
 	state = kzalloc(sizeof(struct dvb_dummy_fe_state), GFP_KERNEL);
-	if (state == NULL) goto error;
+	if (!state)
+		return NULL;
 
 	/* create dvb_frontend */
 	memcpy(&state->frontend.ops, &dvb_dummy_fe_qam_ops, sizeof(struct dvb_frontend_ops));
 	state->frontend.demodulator_priv = state;
 	return &state->frontend;
-
-error:
-	kfree(state);
-	return NULL;
 }
 
 static struct dvb_frontend_ops dvb_dummy_fe_ofdm_ops = {


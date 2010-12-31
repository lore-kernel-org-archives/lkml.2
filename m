Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab1AAJcL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 04:32:11 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44191 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab1AAJcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 04:32:09 -0500
Message-ID: <4d1ef497.52790e0a.1192.06a8@mx.google.com>
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Fri, 31 Dec 2010 13:37:00 +0200
Subject: [PATCH 09/18] stv0367: Fix potential divide error
To: <mchehab@infradead.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>
---
 drivers/media/dvb/frontends/stv0367.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv0367.c b/drivers/media/dvb/frontends/stv0367.c
index 0575741..e6bee7f 100644
--- a/drivers/media/dvb/frontends/stv0367.c
+++ b/drivers/media/dvb/frontends/stv0367.c
@@ -3275,12 +3275,14 @@ static int stv0367cab_read_snr(struct dvb_frontend *fe, u16 *snr)
 		power = 1;
 		break;
 	}
+
 	for (i = 0; i < 10; i++) {
 		regval += (stv0367_readbits(state, F367CAB_SNR_LO)
 			+ 256 * stv0367_readbits(state, F367CAB_SNR_HI));
 	}
+
+	regval /= 10; /*for average over 10 times in for loop above*/
 	if (regval != 0) {
-		regval /= 10; /*for average over 10 times in for loop above*/
 		temp = power
 			* (1 << (3 + stv0367_readbits(state, F367CAB_SNR_PER)));
 		temp /= regval;
-- 
1.7.1


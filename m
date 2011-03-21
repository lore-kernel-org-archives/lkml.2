Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab1CUN0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 09:26:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33947 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753190Ab1CUN0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 09:26:24 -0400
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX1/ymwQoCy/y3+pcBdCEE6vIVy46B5s/HAbDXPnc6k
	4I/V0WkUs0X+84
From: =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: Greg Kroah-Hartman <gregkh@suse.de>, Pavel Machek <pavel@ucw.cz>
Cc: Pekka Enberg <penberg@kernel.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: [PATCH] staging: winbond/mto.c: remove unused variables
Date: Mon, 21 Mar 2011 14:24:03 +0100
Message-Id: <1300713844-8167-1-git-send-email-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are unused since commit a22517fec0b13b5813932a3583a2b11a2ee17f5d:

    Staging: w35und: remove dead code from mto.c

Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
---
 drivers/staging/winbond/mto.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/winbond/mto.c b/drivers/staging/winbond/mto.c
index c03e501..5250217 100644
--- a/drivers/staging/winbond/mto.c
+++ b/drivers/staging/winbond/mto.c
@@ -40,14 +40,9 @@ static u8 MTO_Data_Rate_Tbl[MTO_MAX_DATA_RATE_LEVELS] = {
 	2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108
 };
 
-static int TotalTxPkt;
-static int TotalTxPktRetry;
 /* this record the retry rate at different data rate */
 static int retryrate_rec[MTO_MAX_DATA_RATE_LEVELS];
 
-static int PeriodTotalTxPkt;
-static int PeriodTotalTxPktRetry;
-
 static u8 boSparseTxTraffic;
 
 void MTO_Init(struct wbsoft_priv *adapter);
@@ -174,9 +169,4 @@ void MTO_SetTxCount(struct wbsoft_priv *adapter, u8 tx_rate, u8 index)
 		MTO_HAL()->dto_tx_retry_count += index;
 		MTO_HAL()->dto_tx_frag_count += (index + 1);
 	}
-	TotalTxPkt++;
-	TotalTxPktRetry += (index + 1);
-
-	PeriodTotalTxPkt++;
-	PeriodTotalTxPktRetry += (index + 1);
 }
-- 
1.7.4.1


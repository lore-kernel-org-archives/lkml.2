Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab2E1D3n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:29:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52158 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754046Ab2E1D3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:38 -0400
Message-Id: <20120528031212.678300963@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:13 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Bagwell <chris@cnpbagwell.com>,
        Ping Cheng <pingc@wacom.com>, Dmitry Torokhov <dtor@mail.ru>
Subject: [ 071/117] Input: wacom - relax Bamboo stylus ID check
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Bagwell <chris@cnpbagwell.com>

commit c5981411f60c31f0dff6f0f98d2d3711384badaf upstream.

Bit 0x02 always means tip versus eraser. Bit 0x01 is something related
to version of stylus and different values are starting to be used.

Relaxing proximity check is required to be used with 3rd generation
Bamboo Pen and Touch tablets.

Signed-off-by: Chris Bagwell <chris@cnpbagwell.com>
Acked-by: Ping Cheng <pingc@wacom.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/input/tablet/wacom_wac.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 7fefd93..d1ced32 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -842,12 +842,7 @@ static int wacom_bpt_pen(struct wacom_wac *wacom)
 	unsigned char *data = wacom->data;
 	int prox = 0, x = 0, y = 0, p = 0, d = 0, pen = 0, btn1 = 0, btn2 = 0;
 
-	/*
-	 * Similar to Graphire protocol, data[1] & 0x20 is proximity and
-	 * data[1] & 0x18 is tool ID.  0x30 is safety check to ignore
-	 * 2 unused tool ID's.
-	 */
-	prox = (data[1] & 0x30) == 0x30;
+	prox = (data[1] & 0x20) == 0x20;
 
 	/*
 	 * All reports shared between PEN and RUBBER tool must be



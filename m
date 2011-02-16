Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946Ab1BPAsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:48:35 -0500
Received: from kroah.org ([198.145.64.141]:45424 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932913Ab1BPAsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:48:23 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:03 2011
Message-Id: <20110216002103.219765744@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:20:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chun-Yi Lee <jlee@novell.com>, Chien-Chia Chen <machen@novell.com>
Subject: [patch 041/176] Staging: rt3090: Fix RT3090 scan AP function
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chien-Chia Chen <machen@novell.com>

commit 1226056d9608d241db4b558a0d88a347ad5c66ae upstream.

Fix RT3090 scan AP function.

This patch fixes the rt3090 wireless module failed
to scan AP around due to  Windows driver causing
rt3090 module unable to scan AP in Linux.

Acked-by: Chun-Yi Lee <jlee@novell.com>
Signed-off-by: Chien-Chia Chen <machen@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rt2860/chips/rt3090.c |    3 ++-
 drivers/staging/rt2860/chips/rt30xx.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/staging/rt2860/chips/rt3090.c
+++ b/drivers/staging/rt2860/chips/rt3090.c
@@ -51,7 +51,8 @@ void NICInitRT3090RFRegisters(struct rt_
 	if (IS_RT3090(pAd)) {
 		/* Init RF calibration */
 		/* Driver should toggle RF R30 bit7 before init RF registers */
-		u32 RfReg = 0, data;
+		u8 RfReg;
+		u32 data;
 
 		RT30xxReadRFRegister(pAd, RF_R30, (u8 *)&RfReg);
 		RfReg |= 0x80;
--- a/drivers/staging/rt2860/chips/rt30xx.c
+++ b/drivers/staging/rt2860/chips/rt30xx.c
@@ -53,7 +53,7 @@ struct rt_reg_pair RT30xx_RFRegTable[] =
 	,
 	{RF_R06, 0x02}
 	,
-	{RF_R07, 0x70}
+	{RF_R07, 0x60}
 	,
 	{RF_R09, 0x0F}
 	,



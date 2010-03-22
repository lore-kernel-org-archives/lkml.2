Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab0CVU3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:29:08 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:52589 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab0CVU3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=roaSB7bIDzmeh6ZrTEOQK62l9hMUazOql6adWyXzT2Xe5tNfOG/nMbwH65DLI8H5Qw
         fnLFQeMVTb0qh+ativY7j5BjVIQM2Vf8p+RbolegS/WKSpCoj6q3N0LrtRXYT68KqeeT
         kOS0OLRh3WVbhrw02NSsYyDUjweW0amGuUiJE=
Message-ID: <4BA7D22A.6080300@gmail.com>
Date: Mon, 22 Mar 2010 21:25:14 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
       davem@davemloft.net
Subject: [PATCH] via-velocity: FLOW_CNTL_RX does not disable Asymmetric pause
 in set_mii_flow_control()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Asymmetric pause was not disabled in the RX case.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
I spotted this because In the FLOW_CNTL_RX and FLOW_CNTL_TX_RX
cases the same code is executed, is the amendment below required?

diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c
index 3a486f3..2d478cf 100644
--- a/drivers/net/via-velocity.c
+++ b/drivers/net/via-velocity.c
@@ -807,7 +807,7 @@ static void set_mii_flow_control(struct velocity_info *vptr)
 
 	case FLOW_CNTL_RX:
 		MII_REG_BITS_ON(ANAR_PAUSE, MII_REG_ANAR, vptr->mac_regs);
-		MII_REG_BITS_ON(ANAR_ASMDIR, MII_REG_ANAR, vptr->mac_regs);
+		MII_REG_BITS_OFF(ANAR_ASMDIR, MII_REG_ANAR, vptr->mac_regs);
 		break;
 
 	case FLOW_CNTL_TX_RX:

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab2KCLBD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 07:01:03 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:11958
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754397Ab2KCK6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 06:58:54 -0400
X-IronPort-AV: E=Sophos;i="4.80,705,1344204000"; 
   d="scan'208";a="161245675"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Michael Buesch <m@bues.ch>
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/16] drivers/ssb/main.c: use WARN
Date: Sat,  3 Nov 2012 11:58:35 +0100
Message-Id: <1351940317-14812-15-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use WARN rather than printk followed by WARN_ON(1), for conciseness.

A simplified version of the semantic patch that makes this transformation
is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression list es;
@@

-printk(
+WARN(1,
  es);
-WARN_ON(1);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/ssb/main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index df0f145..519688d 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -1118,8 +1118,7 @@ static u32 ssb_tmslow_reject_bitmask(struct ssb_device *dev)
 	case SSB_IDLOW_SSBREV_27:     /* same here */
 		return SSB_TMSLOW_REJECT;	/* this is a guess */
 	default:
-		printk(KERN_INFO "ssb: Backplane Revision 0x%.8X\n", rev);
-		WARN_ON(1);
+		WARN(1, KERN_INFO "ssb: Backplane Revision 0x%.8X\n", rev);
 	}
 	return (SSB_TMSLOW_REJECT | SSB_TMSLOW_REJECT_23);
 }


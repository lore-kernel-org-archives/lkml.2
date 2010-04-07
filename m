Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab0DGC65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 22:58:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52319 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755672Ab0DGC6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 22:58:47 -0400
Date: Wed, 7 Apr 2010 12:58:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: linux-next: manual merge of the net tree with Linus' tree
Message-Id: <20100407125845.c5308d84.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
drivers/net/via-velocity.c between commit
bcbe53682f65330bdd9ad7eed9575d2ff536353a ("via-velocity: Fix
FLOW_CNTL_TX_RX handling in set_mii_flow_control()") from Linus' tree and
commit 3a7f8681ffb27bcc540fb74cda15e39c9395737b ("via-velocity: remove
private #define") from the net tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/via-velocity.c
index bc278d4,078903f..0000000
--- a/drivers/net/via-velocity.c
+++ b/drivers/net/via-velocity.c
@@@ -811,8 -811,8 +811,8 @@@ static void set_mii_flow_control(struc
  		break;
  
  	case FLOW_CNTL_TX_RX:
- 		MII_REG_BITS_ON(ANAR_PAUSE, MII_REG_ANAR, vptr->mac_regs);
- 		MII_REG_BITS_OFF(ANAR_ASMDIR, MII_REG_ANAR, vptr->mac_regs);
+ 		MII_REG_BITS_ON(ADVERTISE_PAUSE_CAP, MII_ADVERTISE, vptr->mac_regs);
 -		MII_REG_BITS_ON(ADVERTISE_PAUSE_ASYM, MII_ADVERTISE, vptr->mac_regs);
++		MII_REG_BITS_OFF(ADVERTISE_PAUSE_ASYM, MII_ADVERTISE, vptr->mac_regs);
  		break;
  
  	case FLOW_CNTL_DISABLE:

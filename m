Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab2FEJrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:47:53 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58541 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932295Ab2FEJru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:47:50 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Henk de Groot <pe1dnn@amsat.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] staging: wlags49_h2: Remove direct declarations of KERN_<LEVEL> prefixes
Date: Tue,  5 Jun 2012 02:46:35 -0700
Message-Id: <f27fcf94d61f53e56e140bd8e0b5edf4a77eac5e.1338889067.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1338889066.git.joe@perches.com>
References: <cover.1338889066.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the standard KERN_<LEVEL> #defines instead of "<.>"

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/wlags49_h2/hcf.c     |    8 ++++----
 drivers/staging/wlags49_h2/wl_main.c |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
index 366e4a4..4235446 100644
--- a/drivers/staging/wlags49_h2/hcf.c
+++ b/drivers/staging/wlags49_h2/hcf.c
@@ -705,7 +705,7 @@ hcf_action( IFBP ifbp, hcf_16 action )
 			// 800 us latency before FW switches to high power
 			MSF_WAIT(800);                              // MSF-defined function to wait n microseconds.
 //OOR			if ( ifbp->IFB_DSLinkStat & CFG_LINK_STAT_DS_OOR ) { // OutOfRange
-//				printk( "<5>ACT_INT_OFF: Deepsleep phase terminated, enable and go to AwaitConnection\n" );     //;?remove me 1 day
+//				printk(KERN_NOTICE "ACT_INT_OFF: Deepsleep phase terminated, enable and go to AwaitConnection\n" );     //;?remove me 1 day
 //				hcf_cntl( ifbp, HCF_CNTL_ENABLE );
 //			}
 //			ifbp->IFB_DSLinkStat &= ~( CFG_LINK_STAT_DS_IR | CFG_LINK_STAT_DS_OOR); //clear IR/OOR state
@@ -2979,7 +2979,7 @@ hcf_service_nic( IFBP ifbp, wci_bufp bufp, unsigned int len )
 			ltv.typ = CFG_DDS_TICK_TIME;
 			ltv.tick_time = ( ( ifbp->IFB_DSLinkStat & CFG_LINK_STAT_TIMER ) + 0x10 ) *64; //78 is more right
 			hcf_put_info( ifbp, (LTVP)&ltv );
-			printk( "<5>Preparing for sleep, link_status: %04X, timer : %d\n",
+			printk(KERN_NOTICE "Preparing for sleep, link_status: %04X, timer : %d\n",
 				ifbp->IFB_DSLinkStat, ltv.tick_time );//;?remove me 1 day
 			ifbp->IFB_TickCnt++; //;?just to make sure we do not keep on printing above message
 			if ( ltv.tick_time < 300 * 125 ) ifbp->IFB_DSLinkStat += 0x0010;
@@ -4221,11 +4221,11 @@ isr_info( IFBP ifbp )
 // /*4*/    if ( info[1] == CFG_LINK_STAT ) {
 //          ifbp->IFB_DSLinkStat = IPW( HREG_DATA_1 ) | CFG_LINK_STAT_CHANGE;   //corrupts BAP !! ;?
 //          ifbp->IFB_LinkStat = ifbp->IFB_DSLinkStat & CFG_LINK_STAT_FW; //;? to be obsoleted
-//          printk( "<4>linkstatus: %04x\n", ifbp->IFB_DSLinkStat );        //;?remove me 1 day
+//          printk(KERN_ERR "linkstatus: %04x\n", ifbp->IFB_DSLinkStat );        //;?remove me 1 day
 // #if (HCF_SLEEP) & HCF_DDS
 //          if ( ( ifbp->IFB_DSLinkStat & CFG_LINK_STAT_CONNECTED ) == 0 ) {    //even values are disconnected etc.
 //              ifbp->IFB_TickCnt = 0;              //start 2 second period (with 1 tick uncertanty)
-//              printk( "<5>isr_info: AwaitConnection phase started, IFB_TickCnt = 0\n" );      //;?remove me 1 day
+//              printk(KERN_NOTICE "isr_info: AwaitConnection phase started, IFB_TickCnt = 0\n" );      //;?remove me 1 day
 //          }
 // #endif // HCF_DDS
 //      }
diff --git a/drivers/staging/wlags49_h2/wl_main.c b/drivers/staging/wlags49_h2/wl_main.c
index d5bf0a7..2041078 100644
--- a/drivers/staging/wlags49_h2/wl_main.c
+++ b/drivers/staging/wlags49_h2/wl_main.c
@@ -3822,7 +3822,7 @@ static int write_int(struct file *file, const char *buffer, unsigned long count,
 		lp->timer_oor.data = (unsigned long)lp;
 		lp->timer_oor.expires = RUN_AT( 3 * HZ );
 		add_timer( &lp->timer_oor );
-		printk( "<5>wl_enable: %ld\n", jiffies );		//;?remove me 1 day
+		printk(KERN_NOTICE "wl_enable: %ld\n", jiffies );		//;?remove me 1 day
 #endif //DN554
 #ifdef DN554
 /*******************************************************************************
@@ -3852,7 +3852,7 @@ void timer_oor( u_long arg )
     DBG_ENTER( DbgInfo );
     DBG_PARAM( DbgInfo, "arg", "0x%08lx", arg );
 
-	printk( "<5>timer_oor: %ld 0x%04X\n", jiffies, lp->timer_oor_cnt );		//;?remove me 1 day
+	printk(KERN_NOTICE "timer_oor: %ld 0x%04X\n", jiffies, lp->timer_oor_cnt );		//;?remove me 1 day
 	lp->timer_oor_cnt += 10;
     if ( (lp->timer_oor_cnt & ~DS_OOR) > 300 ) {
 		lp->timer_oor_cnt = 300;
-- 
1.7.8.111.gad25c.dirty


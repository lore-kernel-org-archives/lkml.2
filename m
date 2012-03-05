Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965093Ab2CEN6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:58:06 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34830 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964845Ab2CENx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:26 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 54/68] TTY: simserial, reindent some code
Date: Mon,  5 Mar 2012 14:52:41 +0100
Message-Id: <1330955575-26641-55-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the code to conform to the standard. Also make it readable.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |  120 ++++++++++++++++--------------------------
 1 file changed, 44 insertions(+), 76 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 24d6ca0..516ad09 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -62,28 +62,25 @@ static void receive_chars(struct tty_struct *tty)
 	static unsigned char seen_esc = 0;
 
 	while ( (ch = ia64_ssc(0, 0, 0, 0, SSC_GETCHAR)) ) {
-		if ( ch == 27 && seen_esc == 0 ) {
+		if (ch == 27 && seen_esc == 0) {
 			seen_esc = 1;
 			continue;
-		} else {
-			if ( seen_esc==1 && ch == 'O' ) {
-				seen_esc = 2;
-				continue;
-			} else if ( seen_esc == 2 ) {
-				if ( ch == 'P' ) /* F1 */
-					show_state();
+		} else if (seen_esc == 1 && ch == 'O') {
+			seen_esc = 2;
+			continue;
+		} else if (seen_esc == 2) {
+			if (ch == 'P') /* F1 */
+				show_state();
 #ifdef CONFIG_MAGIC_SYSRQ
-				if ( ch == 'S' ) { /* F4 */
-					do
-						ch = ia64_ssc(0, 0, 0, 0,
-							      SSC_GETCHAR);
-					while (!ch);
-					handle_sysrq(ch);
-				}
-#endif
-				seen_esc = 0;
-				continue;
+			if (ch == 'S') { /* F4 */
+				do {
+					ch = ia64_ssc(0, 0, 0, 0, SSC_GETCHAR);
+				} while (!ch);
+				handle_sysrq(ch);
 			}
+#endif
+			seen_esc = 0;
+			continue;
 		}
 		seen_esc = 0;
 
@@ -195,8 +192,8 @@ static void rs_flush_chars(struct tty_struct *tty)
 {
 	struct serial_state *info = tty->driver_data;
 
-	if (info->xmit.head == info->xmit.tail || tty->stopped || tty->hw_stopped ||
-	    !info->xmit.buf)
+	if (info->xmit.head == info->xmit.tail || tty->stopped ||
+			tty->hw_stopped || !info->xmit.buf)
 		return;
 
 	transmit_chars(tty, info, NULL);
@@ -232,10 +229,10 @@ static int rs_write(struct tty_struct * tty,
 	/*
 	 * Hey, we transmit directly from here in our case
 	 */
-	if (CIRC_CNT(info->xmit.head, info->xmit.tail, SERIAL_XMIT_SIZE)
-	    && !tty->stopped && !tty->hw_stopped) {
+	if (CIRC_CNT(info->xmit.head, info->xmit.tail, SERIAL_XMIT_SIZE) &&
+			!tty->stopped && !tty->hw_stopped)
 		transmit_chars(tty, info, NULL);
-	}
+
 	return ret;
 }
 
@@ -293,7 +290,8 @@ static void rs_send_xchar(struct tty_struct *tty, char ch)
  */
 static void rs_throttle(struct tty_struct * tty)
 {
-	if (I_IXOFF(tty)) rs_send_xchar(tty, STOP_CHAR(tty));
+	if (I_IXOFF(tty))
+		rs_send_xchar(tty, STOP_CHAR(tty));
 
 	printk(KERN_INFO "simrs_throttle called\n");
 }
@@ -322,48 +320,21 @@ static int rs_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
 	}
 
 	switch (cmd) {
-		case TIOCGSERIAL:
-			printk(KERN_INFO "simrs_ioctl TIOCGSERIAL called\n");
-			return 0;
-		case TIOCSSERIAL:
-			printk(KERN_INFO "simrs_ioctl TIOCSSERIAL called\n");
-			return 0;
-		case TIOCSERCONFIG:
-			printk(KERN_INFO "rs_ioctl: TIOCSERCONFIG called\n");
-			return -EINVAL;
-
-		case TIOCSERGETLSR: /* Get line status register */
-			printk(KERN_INFO "rs_ioctl: TIOCSERGETLSR called\n");
-			return  -EINVAL;
-
-		case TIOCSERGSTRUCT:
-			printk(KERN_INFO "rs_ioctl: TIOCSERGSTRUCT called\n");
-#if 0
-			if (copy_to_user((struct async_struct *) arg,
-					 info, sizeof(struct async_struct)))
-				return -EFAULT;
-#endif
-			return 0;
-
-		/*
-		 * Wait for any of the 4 modem inputs (DCD,RI,DSR,CTS) to change
-		 * - mask passed in arg for lines of interest
-		 *   (use |'ed TIOCM_RNG/DSR/CD/CTS for masking)
-		 * Caller should use TIOCGICOUNT to see which one it was
-		 */
-		case TIOCMIWAIT:
-			printk(KERN_INFO "rs_ioctl: TIOCMIWAIT: called\n");
-			return 0;
-		case TIOCSERGWILD:
-		case TIOCSERSWILD:
-			/* "setserial -W" is called in Debian boot */
-			printk (KERN_INFO "TIOCSER?WILD ioctl obsolete, ignored.\n");
-			return 0;
-
-		default:
-			return -ENOIOCTLCMD;
-		}
-	return 0;
+	case TIOCGSERIAL:
+	case TIOCSSERIAL:
+	case TIOCSERGSTRUCT:
+	case TIOCMIWAIT:
+		return 0;
+	case TIOCSERCONFIG:
+	case TIOCSERGETLSR: /* Get line status register */
+		return -EINVAL;
+	case TIOCSERGWILD:
+	case TIOCSERSWILD:
+		/* "setserial -W" is called in Debian boot */
+		printk (KERN_INFO "TIOCSER?WILD ioctl obsolete, ignored.\n");
+		return 0;
+	}
+	return -ENOIOCTLCMD;
 }
 
 #define RELEVANT_IFLAG(iflag) (iflag & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
@@ -387,14 +358,12 @@ static void shutdown(struct tty_port *port)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	{
-		if (info->irq)
-			free_irq(info->irq, info);
+	if (info->irq)
+		free_irq(info->irq, info);
 
-		if (info->xmit.buf) {
-			free_page((unsigned long) info->xmit.buf);
-			info->xmit.buf = NULL;
-		}
+	if (info->xmit.buf) {
+		free_page((unsigned long) info->xmit.buf);
+		info->xmit.buf = NULL;
 	}
 	local_irq_restore(flags);
 }
@@ -418,9 +387,8 @@ static int activate(struct tty_port *port, struct tty_struct *tty)
 {
 	struct serial_state *state = container_of(port, struct serial_state,
 			port);
-	unsigned long flags;
-	int	retval=0;
-	unsigned long page;
+	unsigned long flags, page;
+	int retval = 0;
 
 	page = get_zeroed_page(GFP_KERNEL);
 	if (!page)
-- 
1.7.9.2



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab1CWIur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 04:50:47 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:56914 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab1CWIuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 04:50:07 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 7/7] TTY: rocket, remove unused variables
Date: Wed, 23 Mar 2011 09:50:00 +0100
Message-Id: <1300870200-24405-7-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300870200-24405-1-git-send-email-jslaby@suse.cz>
References: <1300870200-24405-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/tty/rocket.c:1393:2: warning: Value stored to 'cp' is never read
        cp = &info->channel;
        ^    ~~~~~~~~~~~~~~
drivers/tty/rocket.c:1412:2: warning: Value stored to 'cp' is never read
        cp = &info->channel;
        ^    ~~~~~~~~~~~~~~
drivers/tty/rocket.c:1730:2: warning: Value stored to 'cp' is never read
        cp = &info->channel;
        ^    ~~~~~~~~~~~~~~
drivers/tty/rocket.c:1825:3: warning: Value stored to 'str' is never read
                str = "8";
                ^     ~~~
[many 'str' warnings stripped]
drivers/tty/rocket.c:2037:3: warning: Value stored to 'board_type' is never read
                board_type = "RocketModem";
                ^            ~~~~~~~~~~~~~
[some 'board_type' warnings stripped]

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/rocket.c |   47 -----------------------------------------------
 1 files changed, 0 insertions(+), 47 deletions(-)

diff --git a/drivers/tty/rocket.c b/drivers/tty/rocket.c
index 3780da8..c6c68b0 100644
--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -1380,7 +1380,6 @@ static void rp_send_xchar(struct tty_struct *tty, char ch)
 static void rp_throttle(struct tty_struct *tty)
 {
 	struct r_port *info = tty->driver_data;
-	CHANNEL_t *cp;
 
 #ifdef ROCKET_DEBUG_THROTTLE
 	printk(KERN_INFO "throttle %s: %d....\n", tty->name,
@@ -1390,7 +1389,6 @@ static void rp_throttle(struct tty_struct *tty)
 	if (rocket_paranoia_check(info, "rp_throttle"))
 		return;
 
-	cp = &info->channel;
 	if (I_IXOFF(tty))
 		rp_send_xchar(tty, STOP_CHAR(tty));
 
@@ -1400,7 +1398,6 @@ static void rp_throttle(struct tty_struct *tty)
 static void rp_unthrottle(struct tty_struct *tty)
 {
 	struct r_port *info = tty->driver_data;
-	CHANNEL_t *cp;
 #ifdef ROCKET_DEBUG_THROTTLE
 	printk(KERN_INFO "unthrottle %s: %d....\n", tty->name,
 	       tty->ldisc.chars_in_buffer(tty));
@@ -1409,7 +1406,6 @@ static void rp_unthrottle(struct tty_struct *tty)
 	if (rocket_paranoia_check(info, "rp_throttle"))
 		return;
 
-	cp = &info->channel;
 	if (I_IXOFF(tty))
 		rp_send_xchar(tty, START_CHAR(tty));
 
@@ -1722,13 +1718,10 @@ static int rp_write_room(struct tty_struct *tty)
 static int rp_chars_in_buffer(struct tty_struct *tty)
 {
 	struct r_port *info = tty->driver_data;
-	CHANNEL_t *cp;
 
 	if (rocket_paranoia_check(info, "rp_chars_in_buffer"))
 		return 0;
 
-	cp = &info->channel;
-
 #ifdef ROCKET_DEBUG_WRITE
 	printk(KERN_INFO "rp_chars_in_buffer returns %d...\n", info->xmit_cnt);
 #endif
@@ -1779,7 +1772,6 @@ static __init int register_PCI(int i, struct pci_dev *dev)
 {
 	int num_aiops, aiop, max_num_aiops, num_chan, chan;
 	unsigned int aiopio[MAX_AIOPS_PER_BOARD];
-	char *str, *board_type;
 	CONTROLLER_t *ctlp;
 
 	int fast_clock = 0;
@@ -1800,7 +1792,6 @@ static __init int register_PCI(int i, struct pci_dev *dev)
 	/*  Depending on the model, set up some config variables */
 	switch (dev->device) {
 	case PCI_DEVICE_ID_RP4QUAD:
-		str = "Quadcable";
 		max_num_aiops = 1;
 		ports_per_aiop = 4;
 		rocketModel[i].model = MODEL_RP4QUAD;
@@ -1808,42 +1799,36 @@ static __init int register_PCI(int i, struct pci_dev *dev)
 		rocketModel[i].numPorts = 4;
 		break;
 	case PCI_DEVICE_ID_RP8OCTA:
-		str = "Octacable";
 		max_num_aiops = 1;
 		rocketModel[i].model = MODEL_RP8OCTA;
 		strcpy(rocketModel[i].modelString, "RocketPort 8 port w/octa cable");
 		rocketModel[i].numPorts = 8;
 		break;
 	case PCI_DEVICE_ID_URP8OCTA:
-		str = "Octacable";
 		max_num_aiops = 1;
 		rocketModel[i].model = MODEL_UPCI_RP8OCTA;
 		strcpy(rocketModel[i].modelString, "RocketPort UPCI 8 port w/octa cable");
 		rocketModel[i].numPorts = 8;
 		break;
 	case PCI_DEVICE_ID_RP8INTF:
-		str = "8";
 		max_num_aiops = 1;
 		rocketModel[i].model = MODEL_RP8INTF;
 		strcpy(rocketModel[i].modelString, "RocketPort 8 port w/external I/F");
 		rocketModel[i].numPorts = 8;
 		break;
 	case PCI_DEVICE_ID_URP8INTF:
-		str = "8";
 		max_num_aiops = 1;
 		rocketModel[i].model = MODEL_UPCI_RP8INTF;
 		strcpy(rocketModel[i].modelString, "RocketPort UPCI 8 port w/external I/F");
 		rocketModel[i].numPorts = 8;
 		break;
 	case PCI_DEVICE_ID_RP8J:
-		str = "8J";
 		max_num_aiops = 1;
 		rocketModel[i].model = MODEL_RP8J;
 		strcpy(rocketModel[i].modelString, "RocketPort 8 port w/RJ11 connectors");
 		rocketModel[i].numPorts = 8;
 		break;
 	case PCI_DEVICE_ID_RP4J:
-		str = "4J";
 		max_num_aiops = 1;
 		ports_per_aiop = 4;
 		rocketModel[i].model = MODEL_RP4J;
@@ -1851,56 +1836,48 @@ static __init int register_PCI(int i, struct pci_dev *dev)
 		rocketModel[i].numPorts = 4;
 		break;
 	case PCI_DEVICE_ID_RP8SNI:
-		str = "8 (DB78 Custom)";
 		max_num_aiops = 1;
 		rocketModel[i].model = MODEL_RP8SNI;
 		strcpy(rocketModel[i].modelString, "RocketPort 8 port w/ custom DB78");
 		rocketModel[i].numPorts = 8;
 		break;
 	case PCI_DEVICE_ID_RP16SNI:
-		str = "16 (DB78 Custom)";
 		max_num_aiops = 2;
 		rocketModel[i].model = MODEL_RP16SNI;
 		strcpy(rocketModel[i].modelString, "RocketPort 16 port w/ custom DB78");
 		rocketModel[i].numPorts = 16;
 		break;
 	case PCI_DEVICE_ID_RP16INTF:
-		str = "16";
 		max_num_aiops = 2;
 		rocketModel[i].model = MODEL_RP16INTF;
 		strcpy(rocketModel[i].modelString, "RocketPort 16 port w/external I/F");
 		rocketModel[i].numPorts = 16;
 		break;
 	case PCI_DEVICE_ID_URP16INTF:
-		str = "16";
 		max_num_aiops = 2;
 		rocketModel[i].model = MODEL_UPCI_RP16INTF;
 		strcpy(rocketModel[i].modelString, "RocketPort UPCI 16 port w/external I/F");
 		rocketModel[i].numPorts = 16;
 		break;
 	case PCI_DEVICE_ID_CRP16INTF:
-		str = "16";
 		max_num_aiops = 2;
 		rocketModel[i].model = MODEL_CPCI_RP16INTF;
 		strcpy(rocketModel[i].modelString, "RocketPort Compact PCI 16 port w/external I/F");
 		rocketModel[i].numPorts = 16;
 		break;
 	case PCI_DEVICE_ID_RP32INTF:
-		str = "32";
 		max_num_aiops = 4;
 		rocketModel[i].model = MODEL_RP32INTF;
 		strcpy(rocketModel[i].modelString, "RocketPort 32 port w/external I/F");
 		rocketModel[i].numPorts = 32;
 		break;
 	case PCI_DEVICE_ID_URP32INTF:
-		str = "32";
 		max_num_aiops = 4;
 		rocketModel[i].model = MODEL_UPCI_RP32INTF;
 		strcpy(rocketModel[i].modelString, "RocketPort UPCI 32 port w/external I/F");
 		rocketModel[i].numPorts = 32;
 		break;
 	case PCI_DEVICE_ID_RPP4:
-		str = "Plus Quadcable";
 		max_num_aiops = 1;
 		ports_per_aiop = 4;
 		altChanRingIndicator++;
@@ -1910,7 +1887,6 @@ static __init int register_PCI(int i, struct pci_dev *dev)
 		rocketModel[i].numPorts = 4;
 		break;
 	case PCI_DEVICE_ID_RPP8:
-		str = "Plus Octacable";
 		max_num_aiops = 2;
 		ports_per_aiop = 4;
 		altChanRingIndicator++;
@@ -1920,7 +1896,6 @@ static __init int register_PCI(int i, struct pci_dev *dev)
 		rocketModel[i].numPorts = 8;
 		break;
 	case PCI_DEVICE_ID_RP2_232:
-		str = "Plus 2 (RS-232)";
 		max_num_aiops = 1;
 		ports_per_aiop = 2;
 		altChanRingIndicator++;
@@ -1930,7 +1905,6 @@ static __init int register_PCI(int i, struct pci_dev *dev)
 		rocketModel[i].numPorts = 2;
 		break;
 	case PCI_DEVICE_ID_RP2_422:
-		str = "Plus 2 (RS-422)";
 		max_num_aiops = 1;
 		ports_per_aiop = 2;
 		altChanRingIndicator++;
@@ -1943,7 +1917,6 @@ static __init int register_PCI(int i, struct pci_dev *dev)
 
 		max_num_aiops = 1;
 		ports_per_aiop = 6;
-		str = "6-port";
 
 		/*  If revision is 1, the rocketmodem flash must be loaded.
 		 *  If it is 2 it is a "socketed" version. */
@@ -1961,7 +1934,6 @@ static __init int register_PCI(int i, struct pci_dev *dev)
 	case PCI_DEVICE_ID_RP4M:
 		max_num_aiops = 1;
 		ports_per_aiop = 4;
-		str = "4-port";
 		if (dev->revision == 1) {
 			rcktpt_type[i] = ROCKET_TYPE_MODEMII;
 			rocketModel[i].loadrm2 = 1;
@@ -1974,7 +1946,6 @@ static __init int register_PCI(int i, struct pci_dev *dev)
 		rocketModel[i].numPorts = 4;
 		break;
 	default:
-		str = "(unknown/unsupported)";
 		max_num_aiops = 0;
 		break;
 	}
@@ -2000,14 +1971,12 @@ static __init int register_PCI(int i, struct pci_dev *dev)
 			if (!
 			    (sInW(ConfigIO + _PCI_9030_GPIO_CTRL) &
 			     PCI_GPIO_CTRL_8PORT)) {
-				str = "Quadcable";
 				ports_per_aiop = 4;
 				rocketModel[i].numPorts = 4;
 			}
 		}
 		break;
 	case PCI_DEVICE_ID_UPCI_RM3_8PORT:
-		str = "8 ports";
 		max_num_aiops = 1;
 		rocketModel[i].model = MODEL_UPCI_RM3_8PORT;
 		strcpy(rocketModel[i].modelString, "RocketModem III 8 port");
@@ -2018,7 +1987,6 @@ static __init int register_PCI(int i, struct pci_dev *dev)
 		rcktpt_type[i] = ROCKET_TYPE_MODEMIII;
 		break;
 	case PCI_DEVICE_ID_UPCI_RM3_4PORT:
-		str = "4 ports";
 		max_num_aiops = 1;
 		rocketModel[i].model = MODEL_UPCI_RM3_4PORT;
 		strcpy(rocketModel[i].modelString, "RocketModem III 4 port");
@@ -2032,21 +2000,6 @@ static __init int register_PCI(int i, struct pci_dev *dev)
 		break;
 	}
 
-	switch (rcktpt_type[i]) {
-	case ROCKET_TYPE_MODEM:
-		board_type = "RocketModem";
-		break;
-	case ROCKET_TYPE_MODEMII:
-		board_type = "RocketModem II";
-		break;
-	case ROCKET_TYPE_MODEMIII:
-		board_type = "RocketModem III";
-		break;
-	default:
-		board_type = "RocketPort";
-		break;
-	}
-
 	if (fast_clock) {
 		sClockPrescale = 0x12;	/* mod 2 (divide by 3) */
 		rp_baud_base[i] = 921600;
-- 
1.7.4.1



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab0CXXFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 19:05:23 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:44074 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab0CXXFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 19:05:22 -0400
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
       Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org,
       Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Subject: [PATCH 2/2] ARM: pcmcia: fix checkpatch.pl issues in soc_common.c
Date: Wed, 24 Mar 2010 20:04:58 -0300
Message-Id: <1269471898-26301-2-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1269471898-26301-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
References: <1269471898-26301-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes checkpatch.pl issues in soc_common.c.

Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
---
 drivers/pcmcia/soc_common.c |  129 +++++++++++++++++++++++--------------------
 1 files changed, 69 insertions(+), 60 deletions(-)

diff --git a/drivers/pcmcia/soc_common.c b/drivers/pcmcia/soc_common.c
index fd4c25a..22af8d2 100644
--- a/drivers/pcmcia/soc_common.c
+++ b/drivers/pcmcia/soc_common.c
@@ -31,20 +31,20 @@
 ======================================================================*/
 
 
-#include <linux/module.h>
-#include <linux/moduleparam.h>
+#include <linux/cpufreq.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
 #include <linux/kernel.h>
-#include <linux/timer.h>
 #include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/mutex.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
 #include <linux/spinlock.h>
-#include <linux/cpufreq.h>
+#include <linux/timer.h>
 
 #include <mach/hardware.h>
-#include <asm/io.h>
 #include <asm/system.h>
 
 #include "soc_common.h"
@@ -69,7 +69,8 @@ EXPORT_SYMBOL(soc_pcmcia_debug);
 
 #endif
 
-#define to_soc_pcmcia_socket(x)	container_of(x, struct soc_pcmcia_socket, socket)
+#define to_soc_pcmcia_socket(x)	\
+	container_of(x, struct soc_pcmcia_socket, socket)
 
 static unsigned short
 calc_speed(unsigned short *spds, int num, unsigned short dflt)
@@ -86,11 +87,15 @@ calc_speed(unsigned short *spds, int num, unsigned short dflt)
 	return speed;
 }
 
-void soc_common_pcmcia_get_timing(struct soc_pcmcia_socket *skt, struct soc_pcmcia_timing *timing)
+void soc_common_pcmcia_get_timing(struct soc_pcmcia_socket *skt,
+	struct soc_pcmcia_timing *timing)
 {
-	timing->io = calc_speed(skt->spd_io, MAX_IO_WIN, SOC_PCMCIA_IO_ACCESS);
-	timing->mem = calc_speed(skt->spd_mem, MAX_WIN, SOC_PCMCIA_3V_MEM_ACCESS);
-	timing->attr = calc_speed(skt->spd_attr, MAX_WIN, SOC_PCMCIA_3V_MEM_ACCESS);
+	timing->io =
+		calc_speed(skt->spd_io, MAX_IO_WIN, SOC_PCMCIA_IO_ACCESS);
+	timing->mem =
+		calc_speed(skt->spd_mem, MAX_WIN, SOC_PCMCIA_3V_MEM_ACCESS);
+	timing->attr =
+		calc_speed(skt->spd_attr, MAX_WIN, SOC_PCMCIA_3V_MEM_ACCESS);
 }
 EXPORT_SYMBOL(soc_common_pcmcia_get_timing);
 
@@ -132,8 +137,8 @@ static unsigned int soc_common_pcmcia_skt_state(struct soc_pcmcia_socket *skt)
  *
  * Convert PCMCIA socket state to our socket configure structure.
  */
-static int
-soc_common_pcmcia_config_skt(struct soc_pcmcia_socket *skt, socket_state_t *state)
+static int soc_common_pcmcia_config_skt(
+	struct soc_pcmcia_socket *skt, socket_state_t *state)
 {
 	int ret;
 
@@ -145,7 +150,8 @@ soc_common_pcmcia_config_skt(struct soc_pcmcia_socket *skt, socket_state_t *stat
 		 */
 		if (skt->irq_state != 1 && state->io_irq) {
 			skt->irq_state = 1;
-			set_irq_type(skt->socket.pci_irq, IRQ_TYPE_EDGE_FALLING);
+			set_irq_type(skt->socket.pci_irq,
+				IRQ_TYPE_EDGE_FALLING);
 		} else if (skt->irq_state == 1 && state->io_irq == 0) {
 			skt->irq_state = 0;
 			set_irq_type(skt->socket.pci_irq, IRQ_TYPE_NONE);
@@ -299,24 +305,25 @@ soc_common_pcmcia_get_status(struct pcmcia_socket *sock, unsigned int *status)
  * of power configuration, reset, &c. We also record the value of
  * `state' in order to regurgitate it to the PCMCIA core later.
  */
-static int
-soc_common_pcmcia_set_socket(struct pcmcia_socket *sock, socket_state_t *state)
+static int soc_common_pcmcia_set_socket(
+	struct pcmcia_socket *sock, socket_state_t *state)
 {
 	struct soc_pcmcia_socket *skt = to_soc_pcmcia_socket(sock);
 
-	debug(skt, 2, "mask: %s%s%s%s%s%sflags: %s%s%s%s%s%sVcc %d Vpp %d irq %d\n",
-			(state->csc_mask==0)?"<NONE> ":"",
-			(state->csc_mask&SS_DETECT)?"DETECT ":"",
-			(state->csc_mask&SS_READY)?"READY ":"",
-			(state->csc_mask&SS_BATDEAD)?"BATDEAD ":"",
-			(state->csc_mask&SS_BATWARN)?"BATWARN ":"",
-			(state->csc_mask&SS_STSCHG)?"STSCHG ":"",
-			(state->flags==0)?"<NONE> ":"",
-			(state->flags&SS_PWR_AUTO)?"PWR_AUTO ":"",
-			(state->flags&SS_IOCARD)?"IOCARD ":"",
-			(state->flags&SS_RESET)?"RESET ":"",
-			(state->flags&SS_SPKR_ENA)?"SPKR_ENA ":"",
-			(state->flags&SS_OUTPUT_ENA)?"OUTPUT_ENA ":"",
+	debug(skt, 2,	"mask: %s%s%s%s%s%s "
+			"flags: %s%s%s%s%s%s Vcc %d Vpp %d irq %d\n",
+			(state->csc_mask == 0)		? "<NONE> " :	"",
+			(state->csc_mask & SS_DETECT)	? "DETECT " :	"",
+			(state->csc_mask & SS_READY)	? "READY " :	"",
+			(state->csc_mask & SS_BATDEAD)	? "BATDEAD " :	"",
+			(state->csc_mask & SS_BATWARN)	? "BATWARN " :	"",
+			(state->csc_mask & SS_STSCHG)	? "STSCHG " :	"",
+			(state->flags == 0)		? "<NONE> " :	"",
+			(state->flags & SS_PWR_AUTO)	? "PWR_AUTO " :	"",
+			(state->flags & SS_IOCARD)	? "IOCARD " :	"",
+			(state->flags & SS_RESET)	? "RESET " :	"",
+			(state->flags & SS_SPKR_ENA)	? "SPKR_ENA " :	"",
+			(state->flags & SS_OUTPUT_ENA)	? "OUTPUT_ENA " : "",
 			state->Vcc, state->Vpp, state->io_irq);
 
 	return soc_common_pcmcia_config_skt(skt, state);
@@ -331,8 +338,8 @@ soc_common_pcmcia_set_socket(struct pcmcia_socket *sock, socket_state_t *state)
  *
  * Returns: 0 on success, -1 on error
  */
-static int
-soc_common_pcmcia_set_io_map(struct pcmcia_socket *sock, struct pccard_io_map *map)
+static int soc_common_pcmcia_set_io_map(
+	struct pcmcia_socket *sock, struct pccard_io_map *map)
 {
 	struct soc_pcmcia_socket *skt = to_soc_pcmcia_socket(sock);
 	unsigned short speed = map->speed;
@@ -341,14 +348,14 @@ soc_common_pcmcia_set_io_map(struct pcmcia_socket *sock, struct pccard_io_map *m
 		map->map, map->speed, (unsigned long long)map->start,
 		(unsigned long long)map->stop);
 	debug(skt, 2, "flags: %s%s%s%s%s%s%s%s\n",
-		(map->flags==0)?"<NONE>":"",
-		(map->flags&MAP_ACTIVE)?"ACTIVE ":"",
-		(map->flags&MAP_16BIT)?"16BIT ":"",
-		(map->flags&MAP_AUTOSZ)?"AUTOSZ ":"",
-		(map->flags&MAP_0WS)?"0WS ":"",
-		(map->flags&MAP_WRPROT)?"WRPROT ":"",
-		(map->flags&MAP_USE_WAIT)?"USE_WAIT ":"",
-		(map->flags&MAP_PREFETCH)?"PREFETCH ":"");
+		(map->flags == 0)		? "<NONE>"	: "",
+		(map->flags & MAP_ACTIVE)	? "ACTIVE "	: "",
+		(map->flags & MAP_16BIT)	? "16BIT "	: "",
+		(map->flags & MAP_AUTOSZ)	? "AUTOSZ "	: "",
+		(map->flags & MAP_0WS)		? "0WS "	: "",
+		(map->flags & MAP_WRPROT)	? "WRPROT "	: "",
+		(map->flags & MAP_USE_WAIT)	? "USE_WAIT "	: "",
+		(map->flags & MAP_PREFETCH)	? "PREFETCH "	: "");
 
 	if (map->map >= MAX_IO_WIN) {
 		printk(KERN_ERR "%s(): map (%d) out of range\n", __func__,
@@ -385,8 +392,8 @@ soc_common_pcmcia_set_io_map(struct pcmcia_socket *sock, struct pccard_io_map *m
  *
  * Returns: 0 on success, -ERRNO on error
  */
-static int
-soc_common_pcmcia_set_mem_map(struct pcmcia_socket *sock, struct pccard_mem_map *map)
+static int soc_common_pcmcia_set_mem_map(
+	struct pcmcia_socket *sock, struct pccard_mem_map *map)
 {
 	struct soc_pcmcia_socket *skt = to_soc_pcmcia_socket(sock);
 	struct resource *res;
@@ -395,14 +402,14 @@ soc_common_pcmcia_set_mem_map(struct pcmcia_socket *sock, struct pccard_mem_map
 	debug(skt, 2, "map %u speed %u card_start %08x\n",
 		map->map, map->speed, map->card_start);
 	debug(skt, 2, "flags: %s%s%s%s%s%s%s%s\n",
-		(map->flags==0)?"<NONE>":"",
-		(map->flags&MAP_ACTIVE)?"ACTIVE ":"",
-		(map->flags&MAP_16BIT)?"16BIT ":"",
-		(map->flags&MAP_AUTOSZ)?"AUTOSZ ":"",
-		(map->flags&MAP_0WS)?"0WS ":"",
-		(map->flags&MAP_WRPROT)?"WRPROT ":"",
-		(map->flags&MAP_ATTRIB)?"ATTRIB ":"",
-		(map->flags&MAP_USE_WAIT)?"USE_WAIT ":"");
+		(map->flags == 0)		? "<NONE>"	: "",
+		(map->flags & MAP_ACTIVE)	? "ACTIVE "	: "",
+		(map->flags & MAP_16BIT)	? "16BIT "	: "",
+		(map->flags & MAP_AUTOSZ)	? "AUTOSZ "	: "",
+		(map->flags & MAP_0WS)		? "0WS "	: "",
+		(map->flags & MAP_WRPROT)	? "WRPROT "	: "",
+		(map->flags & MAP_ATTRIB)	? "ATTRIB "	: "",
+		(map->flags & MAP_USE_WAIT)	? "USE_WAIT "	: "");
 
 	if (map->map >= MAX_WIN)
 		return -EINVAL;
@@ -457,8 +464,8 @@ static struct bittbl conf_bits[] = {
 	{ SS_OUTPUT_ENA,	"SS_OUTPUT_ENA"	},
 };
 
-static void
-dump_bits(char **p, const char *prefix, unsigned int val, struct bittbl *bits, int sz)
+static void dump_bits(char **p, const char *prefix,
+	unsigned int val, struct bittbl *bits, int sz)
 {
 	char *b = *p;
 	int i;
@@ -476,13 +483,14 @@ dump_bits(char **p, const char *prefix, unsigned int val, struct bittbl *bits, i
  *
  * Returns: the number of characters added to the buffer
  */
-static ssize_t show_status(struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t show_status(
+	struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct soc_pcmcia_socket *skt =
 		container_of(dev, struct soc_pcmcia_socket, socket.dev);
 	char *p = buf;
 
-	p+=sprintf(p, "slot     : %d\n", skt->nr);
+	p += sprintf(p, "slot     : %d\n", skt->nr);
 
 	dump_bits(&p, "status", skt->status,
 		  status_bits, ARRAY_SIZE(status_bits));
@@ -491,12 +499,12 @@ static ssize_t show_status(struct device *dev, struct device_attribute *attr, ch
 	dump_bits(&p, "cs_flags", skt->cs_state.flags,
 		  conf_bits, ARRAY_SIZE(conf_bits));
 
-	p+=sprintf(p, "Vcc      : %d\n", skt->cs_state.Vcc);
-	p+=sprintf(p, "Vpp      : %d\n", skt->cs_state.Vpp);
-	p+=sprintf(p, "IRQ      : %d (%d)\n", skt->cs_state.io_irq,
+	p += sprintf(p, "Vcc      : %d\n", skt->cs_state.Vcc);
+	p += sprintf(p, "Vpp      : %d\n", skt->cs_state.Vpp);
+	p += sprintf(p, "IRQ      : %d (%d)\n", skt->cs_state.io_irq,
 		skt->socket.pci_irq);
 	if (skt->ops->show_timing)
-		p+=skt->ops->show_timing(skt, p);
+		p += skt->ops->show_timing(skt, p);
 
 	return p-buf;
 }
@@ -589,7 +597,7 @@ soc_pcmcia_notifier(struct notifier_block *nb, unsigned long val, void *data)
 
 	mutex_lock(&soc_pcmcia_sockets_lock);
 	list_for_each_entry(skt, &soc_pcmcia_sockets, node)
-		if ( skt->ops->frequency_change )
+		if (skt->ops->frequency_change)
 			ret += skt->ops->frequency_change(skt, val, freqs);
 	mutex_unlock(&soc_pcmcia_sockets_lock);
 
@@ -615,7 +623,8 @@ fs_initcall(soc_pcmcia_cpufreq_register);
 
 static void soc_pcmcia_cpufreq_unregister(void)
 {
-	cpufreq_unregister_notifier(&soc_pcmcia_notifier_block, CPUFREQ_TRANSITION_NOTIFIER);
+	cpufreq_unregister_notifier(&soc_pcmcia_notifier_block,
+		CPUFREQ_TRANSITION_NOTIFIER);
 }
 module_exit(soc_pcmcia_cpufreq_unregister);
 
-- 
1.7.0.3


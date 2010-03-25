Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab0CYMGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 08:06:44 -0400
Received: from server78.greatnet.de ([83.133.96.102]:59282 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab0CYMGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:06:40 -0400
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: isdn@linux-pingi.de
Cc: davem@davemloft.net, linux@dominikbrodowski.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH 4/4] isdn: Cleanup Sections in PCMCIA driver elsa
Date: Thu, 25 Mar 2010 13:05:32 +0100
Message-Id: <1269518732-4515-4-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1269518732-4515-3-git-send-email-henne@nachtwindheim.de>
References: <1269518732-4515-1-git-send-email-henne@nachtwindheim.de>
 <1269518732-4515-2-git-send-email-henne@nachtwindheim.de>
 <1269518732-4515-3-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling this driver gave a section mismatch,
so I reviewed the init/exit paths of the driver
and made the correct changes.

WARNING: drivers/isdn/hisax/built-in.o(.text+0x55e37): Section mismatch
in reference from the function elsa_cs_config() to the function
.devinit.text:hisax_init_pcmcia()
The function elsa_cs_config() references
the function __devinit hisax_init_pcmcia().
This is often because elsa_cs_config lacks a __devinit
annotation or the annotation of hisax_init_pcmcia is wrong.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 drivers/isdn/hisax/elsa_cs.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/isdn/hisax/elsa_cs.c b/drivers/isdn/hisax/elsa_cs.c
index c9a30b1..c9f2279 100644
--- a/drivers/isdn/hisax/elsa_cs.c
+++ b/drivers/isdn/hisax/elsa_cs.c
@@ -76,7 +76,7 @@ module_param(protocol, int, 0);
    handler.
 */
 
-static int elsa_cs_config(struct pcmcia_device *link);
+static int elsa_cs_config(struct pcmcia_device *link) __devinit ;
 static void elsa_cs_release(struct pcmcia_device *link);
 
 /*
@@ -85,7 +85,7 @@ static void elsa_cs_release(struct pcmcia_device *link);
    needed to manage one actual PCMCIA card.
 */
 
-static void elsa_cs_detach(struct pcmcia_device *p_dev);
+static void elsa_cs_detach(struct pcmcia_device *p_dev) __devexit;
 
 /*
    A driver needs to provide a dev_node_t structure for each device
@@ -121,7 +121,7 @@ typedef struct local_info_t {
 
 ======================================================================*/
 
-static int elsa_cs_probe(struct pcmcia_device *link)
+static int __devinit elsa_cs_probe(struct pcmcia_device *link)
 {
     local_info_t *local;
 
@@ -166,7 +166,7 @@ static int elsa_cs_probe(struct pcmcia_device *link)
 
 ======================================================================*/
 
-static void elsa_cs_detach(struct pcmcia_device *link)
+static void __devexit elsa_cs_detach(struct pcmcia_device *link)
 {
 	local_info_t *info = link->priv;
 
@@ -210,7 +210,7 @@ static int elsa_cs_configcheck(struct pcmcia_device *p_dev,
 	return -ENODEV;
 }
 
-static int elsa_cs_config(struct pcmcia_device *link)
+static int __devinit elsa_cs_config(struct pcmcia_device *link)
 {
     local_info_t *dev;
     int i;
@@ -327,7 +327,7 @@ static struct pcmcia_driver elsa_cs_driver = {
 		.name	= "elsa_cs",
 	},
 	.probe		= elsa_cs_probe,
-	.remove		= elsa_cs_detach,
+	.remove		= __devexit_p(elsa_cs_detach),
 	.id_table	= elsa_ids,
 	.suspend	= elsa_suspend,
 	.resume		= elsa_resume,
-- 
1.6.3.3


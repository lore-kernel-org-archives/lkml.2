Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab0CYMGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 08:06:42 -0400
Received: from server78.greatnet.de ([83.133.96.102]:59265 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab0CYMGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:06:40 -0400
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: isdn@linux-pingi.de
Cc: davem@davemloft.net, linux@dominikbrodowski.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH 3/4] isdn: Cleanup Sections in PCMCIA driver avma1
Date: Thu, 25 Mar 2010 13:05:31 +0100
Message-Id: <1269518732-4515-3-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1269518732-4515-2-git-send-email-henne@nachtwindheim.de>
References: <1269518732-4515-1-git-send-email-henne@nachtwindheim.de>
 <1269518732-4515-2-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling this driver gave a section mismatch,
so I reviewed the init/exit paths of the driver
and made the correct changes.

WARNING: drivers/isdn/hisax/built-in.o(.text+0x56512): Section mismatch
in reference from the function avma1cs_config() to the function
.devinit.text:hisax_init_pcmcia()
The function avma1cs_config() references
the function __devinit hisax_init_pcmcia().
This is often because avma1cs_config lacks a __devinit
annotation or the annotation of hisax_init_pcmcia is wrong.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 drivers/isdn/hisax/avma1_cs.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/isdn/hisax/avma1_cs.c b/drivers/isdn/hisax/avma1_cs.c
index e5deb15..8d1d63a 100644
--- a/drivers/isdn/hisax/avma1_cs.c
+++ b/drivers/isdn/hisax/avma1_cs.c
@@ -50,7 +50,7 @@ module_param(isdnprot, int, 0);
    handler.
 */
 
-static int avma1cs_config(struct pcmcia_device *link);
+static int avma1cs_config(struct pcmcia_device *link) __devinit ;
 static void avma1cs_release(struct pcmcia_device *link);
 
 /*
@@ -59,7 +59,7 @@ static void avma1cs_release(struct pcmcia_device *link);
    needed to manage one actual PCMCIA card.
 */
 
-static void avma1cs_detach(struct pcmcia_device *p_dev);
+static void avma1cs_detach(struct pcmcia_device *p_dev) __devexit ;
 
 
 /*
@@ -99,7 +99,7 @@ typedef struct local_info_t {
     
 ======================================================================*/
 
-static int avma1cs_probe(struct pcmcia_device *p_dev)
+static int __devinit avma1cs_probe(struct pcmcia_device *p_dev)
 {
     local_info_t *local;
 
@@ -140,7 +140,7 @@ static int avma1cs_probe(struct pcmcia_device *p_dev)
 
 ======================================================================*/
 
-static void avma1cs_detach(struct pcmcia_device *link)
+static void __devexit avma1cs_detach(struct pcmcia_device *link)
 {
 	dev_dbg(&link->dev, "avma1cs_detach(0x%p)\n", link);
 	avma1cs_release(link);
@@ -174,7 +174,7 @@ static int avma1cs_configcheck(struct pcmcia_device *p_dev,
 }
 
 
-static int avma1cs_config(struct pcmcia_device *link)
+static int __devinit avma1cs_config(struct pcmcia_device *link)
 {
     local_info_t *dev;
     int i;
@@ -282,7 +282,7 @@ static struct pcmcia_driver avma1cs_driver = {
 		.name	= "avma1_cs",
 	},
 	.probe		= avma1cs_probe,
-	.remove		= avma1cs_detach,
+	.remove		= __devexit_p(avma1cs_detach),
 	.id_table	= avma1cs_ids,
 };
 
-- 
1.6.3.3


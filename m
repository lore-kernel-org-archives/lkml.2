Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab0CYMGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 08:06:17 -0400
Received: from server78.greatnet.de ([83.133.96.102]:59232 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab0CYMGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:06:16 -0400
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: isdn@linux-pingi.de
Cc: davem@davemloft.net, linux@dominikbrodowski.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH 1/4] isdn: Cleanup Sections in PCMCIA driver sedlbauer
Date: Thu, 25 Mar 2010 13:05:29 +0100
Message-Id: <1269518732-4515-1-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling this driver gave a section mismatch,
so I reviewed the init/exit paths of the driver
and made the correct changes.

WARNING: drivers/isdn/hisax/built-in.o(.text+0x558d6): Section mismatch
in reference from the function sedlbauer_config() to the function
.devinit.text:hisax_init_pcmcia()
The function sedlbauer_config() references
the function __devinit hisax_init_pcmcia().
This is often because sedlbauer_config lacks a __devinit
annotation or the annotation of hisax_init_pcmcia is wrong.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 drivers/isdn/hisax/sedlbauer_cs.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/isdn/hisax/sedlbauer_cs.c b/drivers/isdn/hisax/sedlbauer_cs.c
index 7836ec3..71b3dde 100644
--- a/drivers/isdn/hisax/sedlbauer_cs.c
+++ b/drivers/isdn/hisax/sedlbauer_cs.c
@@ -76,7 +76,7 @@ module_param(protocol, int, 0);
    event handler. 
 */
 
-static int sedlbauer_config(struct pcmcia_device *link);
+static int sedlbauer_config(struct pcmcia_device *link) __devinit ;
 static void sedlbauer_release(struct pcmcia_device *link);
 
 /*
@@ -85,7 +85,7 @@ static void sedlbauer_release(struct pcmcia_device *link);
    needed to manage one actual PCMCIA card.
 */
 
-static void sedlbauer_detach(struct pcmcia_device *p_dev);
+static void sedlbauer_detach(struct pcmcia_device *p_dev) __devexit;
 
 /*
    You'll also need to prototype all the functions that will actually
@@ -129,7 +129,7 @@ typedef struct local_info_t {
     
 ======================================================================*/
 
-static int sedlbauer_probe(struct pcmcia_device *link)
+static int __devinit sedlbauer_probe(struct pcmcia_device *link)
 {
     local_info_t *local;
 
@@ -177,7 +177,7 @@ static int sedlbauer_probe(struct pcmcia_device *link)
 
 ======================================================================*/
 
-static void sedlbauer_detach(struct pcmcia_device *link)
+static void __devexit sedlbauer_detach(struct pcmcia_device *link)
 {
 	dev_dbg(&link->dev, "sedlbauer_detach(0x%p)\n", link);
 
@@ -283,7 +283,7 @@ static int sedlbauer_config_check(struct pcmcia_device *p_dev,
 
 
 
-static int sedlbauer_config(struct pcmcia_device *link)
+static int __devinit sedlbauer_config(struct pcmcia_device *link)
 {
     local_info_t *dev = link->priv;
     win_req_t *req;
@@ -441,7 +441,7 @@ static struct pcmcia_driver sedlbauer_driver = {
 		.name	= "sedlbauer_cs",
 	},
 	.probe		= sedlbauer_probe,
-	.remove		= sedlbauer_detach,
+	.remove		= __devexit_p(sedlbauer_detach),
 	.id_table	= sedlbauer_ids,
 	.suspend	= sedlbauer_suspend,
 	.resume		= sedlbauer_resume,
-- 
1.6.3.3


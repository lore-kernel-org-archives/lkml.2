Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab1F3WJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:09:03 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:51953 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753161Ab1F3WER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:04:17 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/28] staging: ft1000-pcmcia: don't crash on load
Date: Fri,  1 Jul 2011 00:03:30 +0200
Message-Id: <1309471437-12633-2-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
References: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't crash with NULL pointer dereference on load because of empty .name.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
index 68ea035..eefaa65 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
@@ -295,9 +295,7 @@ MODULE_DEVICE_TABLE(pcmcia, ft1000_ids);
 
 static struct pcmcia_driver ft1000_cs_driver = {
 	.owner = THIS_MODULE,
-	.drv = {
-		.name = "ft1000_cs",
-		},
+	.name = "ft1000_cs",
 	.probe      = ft1000_attach,
 	.remove     = ft1000_detach,
 	.id_table	= ft1000_ids,
-- 
Ondrej Zary


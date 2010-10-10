Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708Ab0JJBzy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 21:55:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40710 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab0JJBzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 21:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Rc7CSGQVaLkXBis1So9kXnfEVU81O/c7Ay0vBm+YQ+/fr6fZnbAydoW0tjtrgOaW0l
         UZ3WvvjSNtpIE8g7cEHOf7DID4XdP0SKQD9QGAfkncdIkQhjGEV2sA8to7GoNTRtzW1f
         ppoBM3GfDbIjN4sbui21/m5HYuSyaATdoDOMY=
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, axel.lin@gmail.com, hartleys@visionengravers.com,
        ian@mnementh.co.uk, Marek Vasut <marek.vasut@gmail.com>
Subject: [PATCH] Remove __devinitdata from tc6393xb_mmc_resources
Date: Sun, 10 Oct 2010 03:55:43 +0200
Message-Id: <1286675743-7261-1-git-send-email-marek.vasut@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This static struct resource tc6393xb_mmc_resources[] is used in resume function,
therefore the data can not be wiped after init.

Also, this causes a section mismatch.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
---
 drivers/mfd/tc6393xb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index ef6c42c..1ea80d8 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -155,7 +155,7 @@ static struct resource __devinitdata tc6393xb_nand_resources[] = {
 	},
 };
 
-static struct resource __devinitdata tc6393xb_mmc_resources[] = {
+static struct resource tc6393xb_mmc_resources[] = {
 	{
 		.start	= 0x800,
 		.end	= 0x9ff,
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab2DQBE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 21:04:58 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:61817 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab2DQBE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 21:04:56 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-131.messagelabs.com!1334624693!16502777!3
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ata: libata-transport.c: local functions should not be exposed globally
Date: Mon, 16 Apr 2012 18:04:41 -0700
User-Agent: KMail/1.9.9
CC: <linux-ide@vger.kernel.org>, <jgarzik@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204161804.41337.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions not referenced outside of a source file should be marked
static to prevent it from being exposed globally.

This quiets the sparse warnings:

warning: symbol 'ata_is_port' was not declared. Should it be static?
warning: symbol 'ata_is_link' was not declared. Should it be static?
warning: symbol 'ata_is_ata_dev' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Jeff Garzik <jgarzik@pobox.com>

---

diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index 74aaee3..201672a 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -232,7 +232,7 @@ static void ata_tport_release(struct device *dev)
  * Returns:
  *	%1 if the device represents a ATA Port, %0 else
  */
-int ata_is_port(const struct device *dev)
+static int ata_is_port(const struct device *dev)
 {
 	return dev->release == ata_tport_release;
 }
@@ -354,7 +354,7 @@ static void ata_tlink_release(struct device *dev)
  * Returns:
  *	%1 if the device represents a ATA link, %0 else
  */
-int ata_is_link(const struct device *dev)
+static int ata_is_link(const struct device *dev)
 {
 	return dev->release == ata_tlink_release;
 }
@@ -571,7 +571,7 @@ static void ata_tdev_release(struct device *dev)
  * Returns:
  *	%1 if the device represents a ATA device, %0 else
  */
-int ata_is_ata_dev(const struct device *dev)
+static int ata_is_ata_dev(const struct device *dev)
 {
 	return dev->release == ata_tdev_release;
 }

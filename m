Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab1HFN3I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 09:29:08 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35382 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab1HFN3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 09:29:05 -0400
From: stufever@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org, lethal@linux-sh.org, FlorianSchandinat@gmx.de,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: [PATCH] viafb: fix pointer type missmatch
Date: Sat,  6 Aug 2011 21:26:20 +0800
Message-Id: <1312637180-6107-1-git-send-email-wangshaoyan.pt@taobao.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Shaoyan <wangshaoyan.pt@taobao.com>

  drivers/video/via/via-core.c: In function 'via_pci_probe':
  drivers/video/via/via-core.c:691: warning: assignment discards qualifiers from pointer target type

Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 drivers/video/via/via-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
index eb112b6..dd58b53 100644
--- a/drivers/video/via/via-core.c
+++ b/drivers/video/via/via-core.c
@@ -35,7 +35,7 @@ static struct via_port_cfg adap_configs[] = {
  * The OLPC XO-1.5 puts the camera power and reset lines onto
  * GPIO 2C.
  */
-static const struct via_port_cfg olpc_adap_configs[] = {
+static struct via_port_cfg olpc_adap_configs[] = {
 	[VIA_PORT_26]	= { VIA_PORT_I2C,  VIA_MODE_I2C, VIASR, 0x26 },
 	[VIA_PORT_31]	= { VIA_PORT_I2C,  VIA_MODE_I2C, VIASR, 0x31 },
 	[VIA_PORT_25]	= { VIA_PORT_GPIO, VIA_MODE_GPIO, VIASR, 0x25 },
-- 
1.7.0.4


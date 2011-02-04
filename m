Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab1BDMXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:23:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab1BDMX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:23:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=TZlKDt3UsDhsPx/x12DPuMZEKH3sq/c1WxF8O79AdQPhIM+uKc1ob0Rb0spExIKDcn
         Q/dYW857q5yjCTWOpThyPJXVBeTeeLpwQNjIx1DHd359zR15k/svufkiuSOjf+yoTamB
         e2kfX1L5KSxIATLHZSL9adDZuzF+nghNPIbvM=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 04/20] mach-ux500: mbox-db5500: world-writable sysfs fifo file
Date: Fri,  4 Feb 2011 15:23:23 +0300
Message-Id: <9c62a32115db2dd9aec1d5b078a2a77e53dfafeb.1296818921.git.segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1296818921.git.segoon@openwall.com>
References: <cover.1296818921.git.segoon@openwall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow everybody to use a modem.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Cannot compile the driver, so it is not tested at all.

 arch/arm/mach-ux500/mbox-db5500.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-ux500/mbox-db5500.c b/arch/arm/mach-ux500/mbox-db5500.c
index cbf1571..402c00d 100644
--- a/arch/arm/mach-ux500/mbox-db5500.c
+++ b/arch/arm/mach-ux500/mbox-db5500.c
@@ -168,7 +168,7 @@ static ssize_t mbox_read_fifo(struct device *dev,
 	return sprintf(buf, "0x%X\n", mbox_value);
 }
 
-static DEVICE_ATTR(fifo, S_IWUGO | S_IRUGO, mbox_read_fifo, mbox_write_fifo);
+static DEVICE_ATTR(fifo, S_IWUSR | S_IRUGO, mbox_read_fifo, mbox_write_fifo);
 
 static int mbox_show(struct seq_file *s, void *data)
 {
-- 
1.7.0.4


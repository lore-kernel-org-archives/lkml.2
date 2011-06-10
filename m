Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab1FJMpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:45:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58219 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab1FJMpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:45:08 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>, Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] gpio: basic_mmio: add missing include of spinlock_types.h
Date: Fri, 10 Jun 2011 13:44:49 +0100
Message-Id: <1307709889-31350-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/basic_mmio_gpio.h uses a spinlock_t without including any
of the spinlock headers resulting in this compiler warning.

include/linux/basic_mmio_gpio.h:51:2: error: expected specifier-qualifier-list before 'spinlock_t'

Explicitly include linux/spinlock_types.h to fix it.

Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 include/linux/basic_mmio_gpio.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/basic_mmio_gpio.h b/include/linux/basic_mmio_gpio.h
index 1ae1271..0490e2e 100644
--- a/include/linux/basic_mmio_gpio.h
+++ b/include/linux/basic_mmio_gpio.h
@@ -16,6 +16,7 @@
 #include <linux/gpio.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <linux/spinlock.h>
 
 struct bgpio_pdata {
 	int base;
-- 
1.7.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723Ab0JVSX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:23:58 -0400
Received: from kroah.org ([198.145.64.141]:37705 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755789Ab0JVSX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:23:56 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 40/49] altera_uart: Fix missing prototype for registering an early console
Date: Fri, 22 Oct 2010 11:21:19 -0700
Message-Id: <1287771688-14805-40-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <cbouatmailru@gmail.com>

Simply add an early_altera_uart_setup() prototype declaration, otherwise
platform code have to do it in .c files, which is ugly.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Acked-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/altera_uart.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/altera_uart.h b/include/linux/altera_uart.h
index c022c82..a10a907 100644
--- a/include/linux/altera_uart.h
+++ b/include/linux/altera_uart.h
@@ -5,6 +5,8 @@
 #ifndef	__ALTUART_H
 #define	__ALTUART_H
 
+#include <linux/init.h>
+
 struct altera_uart_platform_uart {
 	unsigned long mapbase;	/* Physical address base */
 	unsigned int irq;	/* Interrupt vector */
@@ -12,4 +14,6 @@ struct altera_uart_platform_uart {
 	unsigned int bus_shift;	/* Bus shift (address stride) */
 };
 
+int __init early_altera_uart_setup(struct altera_uart_platform_uart *platp);
+
 #endif /* __ALTUART_H */
-- 
1.7.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab0LMARJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:17:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35956 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab0LLXqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:18 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: michael.hennerich@analog.com, vapier@gentoo.org, chrisv@cyberswitching.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [78/223] drivers/misc/ad525x_dpot.c: fix typo in spi write16 and write24 transfer counts
Message-Id: <20101212234617.2C609B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Michael Hennerich <michael.hennerich@analog.com>

commit 1f9fa5216eacf4fdf9d3e4ab57feb8b642f0e78b upstream.

This is a bug fix.  Some SPI connected devices using 16/24 bit accesses,
previously failed, now work.

This typo slipped in after testing, during some restructuring.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Chris Verges <chrisv@cyberswitching.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/misc/ad525x_dpot-spi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/misc/ad525x_dpot-spi.c
===================================================================
--- linux.orig/drivers/misc/ad525x_dpot-spi.c
+++ linux/drivers/misc/ad525x_dpot-spi.c
@@ -53,13 +53,13 @@ static int write8(void *client, u8 val)
 static int write16(void *client, u8 reg, u8 val)
 {
 	u8 data[2] = {reg, val};
-	return spi_write(client, data, 1);
+	return spi_write(client, data, 2);
 }
 
 static int write24(void *client, u8 reg, u16 val)
 {
 	u8 data[3] = {reg, val >> 8, val};
-	return spi_write(client, data, 1);
+	return spi_write(client, data, 3);
 }
 
 static int read8(void *client)

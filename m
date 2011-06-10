Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab1FJMsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:48:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51768 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab1FJMsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:48:20 -0400
Date: Fri, 10 Jun 2011 13:48:05 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: basic_mmio: add missing include of spinlock_types.h
Message-ID: <20110610124805.GN3711@pulham.picochip.com>
References: <1307709889-31350-1-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307709889-31350-1-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 01:44:49PM +0100, Jamie Iles wrote:
> include/linux/basic_mmio_gpio.h uses a spinlock_t without including any
> of the spinlock headers resulting in this compiler warning.
> 
> include/linux/basic_mmio_gpio.h:51:2: error: expected specifier-qualifier-list before 'spinlock_t'
> 
> Explicitly include linux/spinlock_types.h to fix it.

Sorry, wrong patch.  Here's the correct one.

Jamie

8<---

>From cd6afb281b31596c175ea3ee1d44f0efea25250f Mon Sep 17 00:00:00 2001
From: Jamie Iles <jamie@jamieiles.com>
Date: Fri, 10 Jun 2011 13:41:44 +0100
Subject: [PATCH] gpio: basic_mmio: add missing include of spinlock_types.h

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
index 1ae1271..98999cf 100644
--- a/include/linux/basic_mmio_gpio.h
+++ b/include/linux/basic_mmio_gpio.h
@@ -16,6 +16,7 @@
 #include <linux/gpio.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <linux/spinlock_types.h>
 
 struct bgpio_pdata {
 	int base;
-- 
1.7.4.1


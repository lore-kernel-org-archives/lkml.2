Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997Ab1EXXfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:35:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757798Ab1EXXfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:35:08 -0400
Date: Tue, 24 May 2011 16:35:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Suggest using min_t or max_t
Message-Id: <20110524163503.0cd73903.akpm@linux-foundation.org>
In-Reply-To: <1305923088.4209.79.camel@Joe-Laptop>
References: <4DD50B35.2000005@indesign-llc.com>
	<20110519115859.e11a7ca3.akpm@linux-foundation.org>
	<1305909981.4209.33.camel@Joe-Laptop>
	<20110520095037.25eadc0a.akpm@linux-foundation.org>
	<1305912602.4209.41.camel@Joe-Laptop>
	<20110520103529.1ef3917c.akpm@linux-foundation.org>
	<1305915161.4209.56.camel@Joe-Laptop>
	<20110520113830.3faf5230.akpm@linux-foundation.org>
	<1305923088.4209.79.camel@Joe-Laptop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011 13:24:48 -0700
Joe Perches <joe@perches.com> wrote:

> A common issue with min() or max() is using a cast on
> one or both of the arguments when using min_t/max_t could
> be better.
> 
> Add cast detection to uses of min/max and suggest an
> appropriate use of min_t or max_t instead.

Causes this:

akpm2:/usr/src/25> perl scripts/checkpatch.pl patches/drivers-gpio-vx855_gpioc-needs-slabh.patch
Nested quantifiers in regex; marked by <-- HERE in m/(\((?:[^\(\)]++ <-- HERE |(?-1))*\))/ at scripts/checkpatch.pl line 271.

with this:

From: Andrew Morton <akpm@linux-foundation.org>

alpha allmodconfig:

drivers/gpio/vx855_gpio.c: In function 'vx855gpio_probe':
drivers/gpio/vx855_gpio.c:233: error: implicit declaration of function 'kzalloc'
drivers/gpio/vx855_gpio.c:233: warning: assignment makes pointer from integer without a cast

Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/vx855_gpio.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/gpio/vx855_gpio.c~drivers-gpio-vx855_gpioc-needs-slabh drivers/gpio/vx855_gpio.c
--- a/drivers/gpio/vx855_gpio.c~drivers-gpio-vx855_gpioc-needs-slabh
+++ a/drivers/gpio/vx855_gpio.c
@@ -26,6 +26,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/gpio.h>
+#include <linux/slab.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/pci.h>
_


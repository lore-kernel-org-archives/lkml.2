Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086Ab1CCXgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 18:36:18 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42402 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628Ab1CCXgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 18:36:16 -0500
Date: Fri, 4 Mar 2011 10:36:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <rmk@arm.linux.org.uk>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: linux-next: manual merge of the i.MX tree with the arm tree
Message-Id: <20110304103610.b55f4ca4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

Today's linux-next merge of the i.MX tree got a conflict in
arch/arm/mach-mxs/gpio.c between commit
bf0c11183fc3a2acce56d2b53f2a117322bd3c3b ("ARM: 6744/1: mxs: irq_data
conversion") from the arm tree and commit
6bc4e4b309f83caa7a5ec2e6b5715bb7c2cb6879 ("arm: mxs: add irq_chip-name
for GPIO IRQs") from the i.MX tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-mxs/gpio.c
index 61991e4,5120ab5..0000000
--- a/arch/arm/mach-mxs/gpio.c
+++ b/arch/arm/mach-mxs/gpio.c
@@@ -182,11 -182,12 +182,12 @@@ static int mxs_gpio_set_wake_irq(struc
  }
  
  static struct irq_chip gpio_irq_chip = {
+ 	.name = "mxs gpio",
 -	.ack = mxs_gpio_ack_irq,
 -	.mask = mxs_gpio_mask_irq,
 -	.unmask = mxs_gpio_unmask_irq,
 -	.set_type = mxs_gpio_set_irq_type,
 -	.set_wake = mxs_gpio_set_wake_irq,
 +	.irq_ack = mxs_gpio_ack_irq,
 +	.irq_mask = mxs_gpio_mask_irq,
 +	.irq_unmask = mxs_gpio_unmask_irq,
 +	.irq_set_type = mxs_gpio_set_irq_type,
 +	.irq_set_wake = mxs_gpio_set_wake_irq,
  };
  
  static void mxs_set_gpio_direction(struct gpio_chip *chip, unsigned offset,

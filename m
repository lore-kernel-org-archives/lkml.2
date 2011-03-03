Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720Ab1CCT32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 14:29:28 -0500
Received: from xenotime.net ([184.105.210.51]:34401 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758471Ab1CCT31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 14:29:27 -0500
Date: Thu, 3 Mar 2011 11:29:20 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jinqiu <crindy646@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] Fix bug #13853: dereference pointer 'dev' before null
 check
Message-Id: <20110303112920.307665dc.rdunlap@xenotime.net>
In-Reply-To: <4D6EFAE5.4000400@gmail.com>
References: <4D6EFAE5.4000400@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Mar 2011 21:20:21 -0500 Jinqiu wrote:

> This patch fixes bug #13853 .This still exists in latest version.
> 'dev' is dereferenced before testing for NULL.
> 
> Signed-off-by: Jinqiu Yang<crindy646@gmail.com>
> --- a/drivers/net/ariadne.c
> +++ b/drivers/net/ariadne.c
> @@ -420,7 +420,7 @@ static inline void ariadne_reset(struct
> static irqreturn_t ariadne_interrupt(int irq, void *data)
> {
> 	struct net_device *dev = (struct net_device *) data;
> - 	volatile struct Am79C960 *lance = (struct Am79C960*)dev->base_addr;
> + 	volatile struct Am79C960 *lance;
> 	struct ariadne_private *priv;
> 	int csr0, boguscnt;
> 	int handled = 0;

Did you patch generator tool insert tabs in this patch?

The line below should be formatted as:

@@ -429,6 +429,7 @@ static irqreturn_t ariadne_interrupt(int

with no space between 429, and 7.

> @@ -429,6 +429, 7 @@ static irqreturn_t ariadne_interrupt(int
> 		printk(KERN_WARNING  "ariadne_interrupt(): irq for unknown device.\n");
> 		return IRQ_NONE;
> 	}
> + 	lance = (struct Am79C960 *)dev->base_addr;
> 
> 	lance->RAP = CSR0; 					/* PCnet-ISA Controller Status */
> 
> 
> 
> 
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab1LNWWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 17:22:38 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56936 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab1LNWWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 17:22:37 -0500
Date: Wed, 14 Dec 2011 22:22:33 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>, Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] irq: fix crash due to op-less irq domains
Message-ID: <20111214222232.GA3125@gallagher>
References: <1323896156-20692-1-git-send-email-linus.walleij@stericsson.com>
 <4EE91FDD.5070206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE91FDD.5070206@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 04:14:53PM -0600, Rob Herring wrote:
> Linus,
> 
> On 12/14/2011 02:55 PM, Linus Walleij wrote:
> > From: Linus Walleij <linus.walleij@linaro.org>
> > 
> > IRQ domains without ops does not work anymore after commit
> > "irq: support domains with non-zero hwirq base", since the
> > check dereferences domain->ops->to_irq without checking of
> > domain->ops are NULL. This makes U300 (and probably most other
> > systems using the PL190 VIC) boot again.
> 
> I thought the VIC series had the fix for this, but it seems not. NULL
> ops is considered invalid based on the code comments. The correct fix is
> this patch:
> 
> irqdomain: export irq_domain_simple_ops for !CONFIG_OF
> http://www.spinics.net/lists/arm-kernel/msg150290.html
> 
> I believe this is going in with some iMX changes. But I guess the VIC is
> going to need a fix to use irq_domain_simple_ops.

Yes, Thomas has acked that patch, but it wasn't clear who was going to 
merge it.  I asked if this could go through Russell along with a patch 
to make the VIC driver use it but haven't heard anything back yet.  I'll 
repost them now.

Jamie

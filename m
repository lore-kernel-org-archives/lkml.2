Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1IUMXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 08:23:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55418 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750850Ab1IUMXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 08:23:03 -0400
Date: Wed, 21 Sep 2011 13:23:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: mfd: Simulate active high IRQs with wm831x
Message-ID: <20110921122300.GB4374@opensource.wolfsonmicro.com>
References: <20110921064415.GC4999@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921064415.GC4999@elgon.mountain>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 09:44:15AM +0300, Dan Carpenter wrote:

>    518                  /* Simulate an edge triggered IRQ by polling the input
>    519                   * status.  This is sucky but improves interoperability.
>    520                   */
>    521                  if (primary == WM831X_GP_INT &&
>    522                      wm831x->gpio_level[i - WM831X_IRQ_GPIO_1]) {
>                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

> We're inside a for loop over ARRAY_SIZE(wm831x_irqs) which has 58
> elements (so "i" is 0-57) and we subtract WM831X_IRQ_GPIO_1 (1) which
> gives us a max of 56.  The ->gpio_level[] array only has 16 elements

> In wm831x_irq_set_type() it only sets the first 11 elements of the
> ->gpio_level[] array.  Perhaps something similar is needed here.  I
> don't know the code well enough to say.

There's no need for any additional checks, the check for the primary IRQ
ensures that we know we're dealing with a GPIO IRQ.

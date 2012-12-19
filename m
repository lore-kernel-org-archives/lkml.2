Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab2LSJ06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 04:26:58 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34213 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2LSJ0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 04:26:51 -0500
Date: Wed, 19 Dec 2012 09:26:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Arm Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Inconsistency in clk framework
Message-ID: <20121219092636.GW14363@n2100.arm.linux.org.uk>
References: <1355890233.25599.4.camel@gitbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355890233.25599.4.camel@gitbox>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 05:10:33PM +1300, Tony Prisk wrote:
> Hi Mike,
> 
> In attempting to remove some IS_ERR_OR_NULL references, it was pointed
> out that clk_get() can return NULL if CONFIG_HAVE_CLK is not defined.

That is correct - but why is that a problem?  As far as users are
concerned, NULL is a valid clock.  If HAVE_CLK is undefined, do you
want all your drivers to suddenly stop working?

> This seems to contradict the kernel docs associated with the normal
> clk_get (when HAVE_CLK is defined) which states:
> 
> * Returns a struct clk corresponding to the clock producer, or
> * valid IS_ERR() condition containing errno.
> 
> Wouldn't a return code of ERR_PTR(-ENOENT) make more sense and be inline
> with the empty of_ versions as well (which return -ENOENT when CONFIG_OF
> is undefined).

No.

> Also, I noticed that clk_get_sys() doesn't appear to be defined in clk.h
> when HAVE_CLK is undefined - is this correct?

It was never promoted to an official API because its only platform code
which should be using it; no device driver (which should have a struct
device to pass into clk_get()) should ever use clk_get_sys().

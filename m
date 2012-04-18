Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab2DRJzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 05:55:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54519 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab2DRJzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 05:55:08 -0400
Date: Wed, 18 Apr 2012 10:54:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Turquette <mturquette@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] clk: Provide dummy clk_unregister()
Message-ID: <20120418095435.GX24211@n2100.arm.linux.org.uk>
References: <1334736433-3402-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334736433-3402-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 09:07:12AM +0100, Mark Brown wrote:
> +/**
> + * clk_unregister - unregister a currently registered clock
> + * @clk: clock to unregister
> + *
> + * Currently unimplemented.
> + */
> +int clk_unregister(struct clk *clk)
> +{
> +	return -EINVAL;

Don't make unregister calls return values.  Think about this situation
for a moment:

	You call an unregister function in a drivers ->remove function.
	The unregister function fails.  However, the reason the ->remove
	function is being called is because the module is being removed.
	You can't stop the module being removed once the process has
	started.  What do you do with this error?

To put it another way, if an unregister function fails, you're buggered.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab2ACUQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 15:16:33 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40380 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754848Ab2ACUQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 15:16:28 -0500
Date: Tue, 3 Jan 2012 20:16:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan.com@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-tegra@vger.kernel.org, ldewangan@nvidia.com
Subject: Re: [PATCH] regulator: Rail is said to be enable only if this and
 supply rails are enabled.
Message-ID: <20120103201624.GC2843@opensource.wolfsonmicro.com>
References: <1325570983-3700-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325570983-3700-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 11:39:43AM +0530, Laxman Dewangan wrote:
> From: Laxman Dewangan <ldewangan@nvidia.com>
> 
> The given rail is said to be enabled only if this rail is eanbled
> along with supply rail.
> Adding check for the supply rail whether it is enabled or not when
> query about rail enabled.

This feels wrong - the code in general assumes that the parents will all
be enabled for an enabled child (and does the required stuff on enable
and disable).  Doing the check isn't unreasonable but if it fails we
really ought to be complaining loudly as we're probably confused and
things might be going wrong elsewhere.

We should also look at the bootstrapping code, we're not really making
much effort to verify that the hardware configuration on boot is sane
(though realistically it's unlikely that it won't be).

> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> When consumer of any rails query about whether rail is enabled
> or not, the function regulator_is_enabled() should return enabled
> only if this rail and supply rail (both) are enabled.
> if any one of rail, whether the given rail or supply rail, is enabled
> then function should return as not enabled.

Please just put things in the changelog if they're useful.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab3ADQaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 11:30:39 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:38347 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab3ADQag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 11:30:36 -0500
Message-ID: <50E703A8.1080808@wwwdotorg.org>
Date: Fri, 04 Jan 2013 09:30:32 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: mturquette@linaro.org, swarren@nvidia.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, rob.herring@calxeda.com,
        maxime.ripard@free-electrons.com, linux@prisktech.co.nz,
        josh.cartwright@ni.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/7] clk: tegra: Use common of_clk_init() function
References: <1357282858-2112-1-git-send-email-pgaikwad@nvidia.com> <1357282858-2112-2-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1357282858-2112-2-git-send-email-pgaikwad@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2013 12:00 AM, Prashant Gaikwad wrote:
> Use common of_clk_init() function for clocks initialization.

>  drivers/clk/tegra/clk-tegra20.c |    3 ++-
>  drivers/clk/tegra/clk-tegra30.c |    3 ++-

Oh, so this series is written assuming that the Tegra CCF rework is
already applied then? That makes the dependencies quite painful, since I
think we'll end up with the following order being needed:

1) clk: Add composite clock type
   -> This would usually go through the clk tree.
2) The Tegra CCF rework series
   -> This must go through the Tegra tree due to lots of dependencies
   and merge conflicts with other Tegra patches.
3) This series
   -> This would usually go through the clk tree.

Is it possible to re-order the dependencies as (1) (3) (2), so that Mike
can apply (1) and (3) to the clock tree, then I can use the clk tree as
the basis for a branch in the Tegra tree to apply (2) and all the other
Tegra patches that will conflict with (2)?

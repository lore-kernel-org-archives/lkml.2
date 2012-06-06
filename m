Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab2FFKsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:48:09 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53650 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab2FFKsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:48:07 -0400
Date: Wed, 6 Jun 2012 11:47:59 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rajendra Nayak <rnayak@ti.com>
Cc: mturquette@ti.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] clk: cache parent clocks only for muxes
Message-ID: <20120606104759.GN8262@n2100.arm.linux.org.uk>
References: <1338973891-28719-1-git-send-email-rnayak@ti.com> <1338973891-28719-2-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338973891-28719-2-git-send-email-rnayak@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 02:41:30PM +0530, Rajendra Nayak wrote:
> caching parent clocks makes sense only when a clock has more
> than one parent (mux clocks).
> Avoid doing this for every other clock.
> 
> Signed-off-by: Rajendra Nayak <rnayak@ti.com>
> ---
>  drivers/clk/clk.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 687b00d..40568e9 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1229,7 +1229,7 @@ int __clk_init(struct device *dev, struct clk *clk)
>  	 * If clk->parents is not NULL we skip this entire block.  This allows
>  	 * for clock drivers to statically initialize clk->parents.
>  	 */
> -	if (clk->num_parents && !clk->parents) {
> +	if ((clk->num_parents > 1) && !clk->parents) {

You don't need the additional parens here.  Please learn the C precedence
rules.  Additional unnecessary parens can make expressions much harder
to read.

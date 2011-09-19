Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab1ISLOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 07:14:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49287 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab1ISLOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 07:14:07 -0400
Date: Mon, 19 Sep 2011 12:13:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jonghwan Choi <jhbird.choi@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CLKDEV: Reduce scaning time
Message-ID: <20110919111354.GM16381@n2100.arm.linux.org.uk>
References: <1316182452-14061-1-git-send-email-jhbird.choi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316182452-14061-1-git-send-email-jhbird.choi@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 11:14:12PM +0900, Jonghwan Choi wrote:
> If ether dev_id or con_id is NULL. it is not necessary that match point
> should be 3.  it just takes a long time.

clk_get() shouldn't be used in fast paths anyway - drivers should 'get'
the clock and hold a reference to the clock while they're using it and
all the time that they're needing it to be enabled.

I think I'd like to keep the code as-is to discourage its use in fast
paths.  In any case:

> @@ -52,10 +58,10 @@ static struct clk_lookup *clk_find(const char *dev_id, const char *con_id)
>  
>  		if (match > best) {
>  			cl = p;
> -			if (match != 3)
> -				best = match;
> -			else
> +			if (match == point)
>  				break;
> +			else
> +				best = match;

Why not just change the '3' to be 'point' here - why restructure the code?

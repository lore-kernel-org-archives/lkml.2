Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab0EQOoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 10:44:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51611 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751657Ab0EQOoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 10:44:08 -0400
Date: Mon, 17 May 2010 07:44:13 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sundar Iyer <sundar.iyer@stericsson.com>
Cc: linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/1] regulator: return set_mode is same mode is
 requested
Message-ID: <20100517144411.GD5257@opensource.wolfsonmicro.com>
References: <1274105393-32197-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274105393-32197-1-git-send-email-sundar.iyer@stericsson.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 07:39:53PM +0530, Sundar Iyer wrote:
> From: Sundar R Iyer <sundar.iyer@stericsson.com>

The commit message reads "regulator: return set_mode is same mode is
requested".  I'm having a hard time parsing what that actually means,
you probably need a "when" in there...

> +	/* return if the same mode is requested */
> +	regulator_curr_mode = rdev->desc->ops->get_mode(rdev);
> +	if (regulator_curr_mode == mode) {
> +		ret = 0;
> +		goto out;
> +	}
> +

This is going to oops if the regulator doesn't implement a get_mode()
operation.  

I'm also a little ambivalent on the benefit of it - if the goal is to
save I/O costs (you didn't say...) it's not clear to me that the effort
of checking the current mode is going to be a win in situations where
the mode is actually being changed a lot.

As I said in reply to your previous message the trend is away from
having any mode configration at all, with regulators being able to adapt
to their current load without any software assistance.

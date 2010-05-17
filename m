Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab0EQPe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 11:34:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38175 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753196Ab0EQPeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 11:34:25 -0400
Date: Mon, 17 May 2010 08:34:32 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sundar R Iyer <sundar.iyer@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/1] regulator: return set_mode is same mode is
 requested
Message-ID: <20100517153431.GA6218@opensource.wolfsonmicro.com>
References: <1274105393-32197-1-git-send-email-sundar.iyer@stericsson.com>
 <20100517144411.GD5257@opensource.wolfsonmicro.com>
 <1274108214.20589.28.camel@bnru01>
 <1274109402.20589.39.camel@bnru01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274109402.20589.39.camel@bnru01>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 08:45:45PM +0530, Sundar R Iyer wrote:

> +	/* sanity check */
> +	if (!rdev->desc->ops->get_mode) {
> +		ret = -EINVAL;
> +		goto out;
> +	}

This doesn't seem like the right error handling - if the driver has a
set_mode() you'd *expect* it to have a get_mode() but there's no need
for it to be a strict requirement.

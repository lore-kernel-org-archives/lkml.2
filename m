Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab1JRVKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 17:10:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52754 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab1JRVKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 17:10:52 -0400
Date: Tue, 18 Oct 2011 14:10:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH] drivers/leds/leds-lp5521.c: check if reset is
 successful
Message-Id: <20111018141048.1f38b211.akpm@linux-foundation.org>
In-Reply-To: <1318246202-2476-1-git-send-email-srinidhi.kasagar@stericsson.com>
References: <1318246202-2476-1-git-send-email-srinidhi.kasagar@stericsson.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011 17:00:02 +0530
Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com> wrote:

> make sure that the reset is successful by issuing a dummy
> read to R channel current register and check its default
> value. On some platforms, without this dummy read, any
> further access to {R/G/B}_EXEC will not have any impact.
> 
> ...
>
> @@ -681,6 +685,21 @@ static int __devinit lp5521_probe(struct i2c_client *client,
>  				     * Exact value is not available. 10 - 20ms
>  				     * appears to be enough for reset.
>  				     */
> +
> +	/*
> +	 * Make sure that the chip is reset by reading back
> +	 * r channel current reg. This is a dummy read, otherwise
> +	 * in some platforms, access to R G B channel program
> +	 * execution mode to 'Run' in LP5521_REG_ENABLE register
> +	 * will not have any affect - strange!
> +	 */
> +	lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
> +	if (buf != LP5521_REG_R_CURR_DEFAULT) {
> +		dev_err(&client->dev, "error in reseting chip\n");
> +		goto fail2;
> +	}
> +	usleep_range(10000, 20000);

Sorry, but I found that comment very hard to follow.

Is this version accurate and complete?

	/*
	 * Make sure that the chip is reset by reading back the r channel
	 * current reg. This dummy read is required on some platforms -
	 * otherwise further access to the R G B channels in the
	 * LP5521_REG_ENABLE register will not have any effect - strange!
	 */


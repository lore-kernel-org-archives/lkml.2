Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab1DRLVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 07:21:39 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:48792 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751420Ab1DRLVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 07:21:33 -0400
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX18YkR4YYXkY+XgBgrtiH5Oim+IkpBULgVaGv3stlw
	AmdfVOLN4u569u
Date: Mon, 18 Apr 2011 13:21:25 +0200
From: Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: Raghavendra D Prabhu <rprabhu@wnohang.net>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] FIX: engine_state is uninitialized
Message-ID: <20110418112124.GB1100@debian.debian>
References: <20110416083730.GA5114@Xye>
 <20110416084313.GA27564@Xye>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110416084313.GA27564@Xye>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 16, 2011 at 02:13:13PM +0530, Raghavendra D Prabhu wrote:
> In case lp5521_read() returns EIO, engine_state is in an uninitialized state. This
> adds checks to fix that.
>
> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
> ---
>  drivers/leds/leds-lp5521.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
> index c0cff64..6c5eac0 100644
> --- a/drivers/leds/leds-lp5521.c
> +++ b/drivers/leds/leds-lp5521.c
> @@ -176,11 +176,13 @@ static int lp5521_set_engine_mode(struct lp5521_engine *engine, u8 mode)
>  	ret = lp5521_read(client, LP5521_REG_OP_MODE, &engine_state);
> +	if (ret == 0){
>  	/* set mode only for this engine */
> -	engine_state &= ~(engine->engine_mask);
> -	mode &= engine->engine_mask;
> -	engine_state |= mode;
> -	ret |= lp5521_write(client, LP5521_REG_OP_MODE, engine_state);
> +		engine_state &= ~(engine->engine_mask);
> +		mode &= engine->engine_mask;
> +		engine_state |= mode;
> +		ret |= lp5521_write(client, LP5521_REG_OP_MODE, engine_state);
> +	}
>  	return ret;
>  }
> --
> 1.7.4.4

Usually something like

	if (ret < 0)
		goto out;

	/* some code here */

out:
	return ret;

is preferred to avoid unnecessary nesting/indentation. Anyway, thanks for the
patch (although I'm not the maintainer, but just commenting).

Thanks,
	Jonathan Neuschäfer

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab2GHBSf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 21:18:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41005 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab2GHBSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 21:18:32 -0400
Date: Sat, 7 Jul 2012 18:18:27 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Anssi Hannula <anssi.hannula@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch -resend] Input: ff-memless - fix a couple min_t() casts
Message-ID: <20120708011827.GH19007@core.coreip.homeip.net>
References: <20120627085800.GA3007@mwanda>
 <20120627091118.GX31212@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627091118.GX31212@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 12:11:19PM +0300, Dan Carpenter wrote:
> envelope->attack_level is a u16 type.  We're trying to clamp it here
> so it's between 0 and 0x7fff.  Unfortunately, the cast to __s16 turns
> all the values larger than 0x7fff into negative numbers and min_t()
> thinks they are less than 0x7fff.  envelope_level is an int so now
> we've got negative values stored there.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thank you Dan.

> ---
> Originally sent on Mon, 26 Sep 2011.  I have added Anssi Hannula to the
> CC list.
> 
> diff --git a/drivers/input/ff-memless.c b/drivers/input/ff-memless.c
> index 5f55885..b107922 100644
> --- a/drivers/input/ff-memless.c
> +++ b/drivers/input/ff-memless.c
> @@ -176,7 +176,7 @@ static int apply_envelope(struct ml_effect_state *state, int value,
>  			 value, envelope->attack_level);
>  		time_from_level = jiffies_to_msecs(now - state->play_at);
>  		time_of_envelope = envelope->attack_length;
> -		envelope_level = min_t(__s16, envelope->attack_level, 0x7fff);
> +		envelope_level = min_t(u16, envelope->attack_level, 0x7fff);
>  
>  	} else if (envelope->fade_length && effect->replay.length &&
>  		   time_after(now,
> @@ -184,7 +184,7 @@ static int apply_envelope(struct ml_effect_state *state, int value,
>  		   time_before(now, state->stop_at)) {
>  		time_from_level = jiffies_to_msecs(state->stop_at - now);
>  		time_of_envelope = envelope->fade_length;
> -		envelope_level = min_t(__s16, envelope->fade_level, 0x7fff);
> +		envelope_level = min_t(u16, envelope->fade_level, 0x7fff);
>  	} else
>  		return value;
>  

-- 
Dmitry

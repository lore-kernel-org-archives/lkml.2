Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab2GYFiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 01:38:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52900 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab2GYFiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 01:38:01 -0400
Date: Tue, 24 Jul 2012 22:37:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Baodong Chen <chenbdchenbd@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fixed a macro coding style issue
Message-ID: <20120725053755.GA2100@core.coreip.homeip.net>
References: <no>
 <1343193656-2643-1-git-send-email-chenbdchenbd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343193656-2643-1-git-send-email-chenbdchenbd@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 01:20:56PM +0800, Baodong Chen wrote:
> Fixed a coding style issue in driver/input/input.c
> 
> Signed-off-by: Baodong Chen <chenbdchenbd@gmail.com>
> ---
>  drivers/input/input.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index 8921c61..c96e983 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -845,11 +845,13 @@ int input_set_keycode(struct input_dev *dev,
>  EXPORT_SYMBOL(input_set_keycode);
>  
>  #define MATCH_BIT(bit, max) \
> +	do { \
>  		for (i = 0; i < BITS_TO_LONGS(max); i++) \
>  			if ((id->bit[i] & dev->bit[i]) != id->bit[i]) \
>  				break; \
> -		if (i != BITS_TO_LONGS(max)) \
> -			continue;
> +			if (i != BITS_TO_LONGS(max)) \
> +				continue; \
> +	} while (0)

This changes semantics. While current implementation of MATCH_BIT might
not be great style, it is not supposed to be used outside of
input_match_device(), and the replacement is completely broken.

Thanks.

-- 
Dmitry

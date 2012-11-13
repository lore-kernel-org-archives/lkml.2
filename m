Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab2KMHom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:44:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab2KMHol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:44:41 -0500
Date: Tue, 13 Nov 2012 08:44:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 02/13] HID: hid-input: round return value of
 hidinput_calc_abs_res
In-Reply-To: <1352306256-12180-3-git-send-email-benjamin.tissoires@gmail.com>
Message-ID: <alpine.LNX.2.00.1211130844300.15877@pobox.suse.cz>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com> <1352306256-12180-3-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2012, Benjamin Tissoires wrote:

> hidinput_calc_abs_res should return the closest int in the division
> instead of the floor.
> On a device with a logical_max of 3008 and a physical_max of 255mm,
> previous implementation gave a resolution of 11 instead of 12.
> With 11, user-space computes a physical size of 273.5mm and the
> round_closest results gives 250.6mm.
> The old implementation introduced an error of 2cm in this example.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>

Acked-by: Jiri Kosina <jkosina@suse.cz>

> ---
>  drivers/hid/hid-input.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index f5b1d57..67044f3 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -287,7 +287,7 @@ __s32 hidinput_calc_abs_res(const struct hid_field *field, __u16 code)
>  	}
>  
>  	/* Calculate resolution */
> -	return logical_extents / physical_extents;
> +	return DIV_ROUND_CLOSEST(logical_extents, physical_extents);
>  }
>  EXPORT_SYMBOL_GPL(hidinput_calc_abs_res);
>  
> -- 
> 1.7.11.7
> 

-- 
Jiri Kosina
SUSE Labs

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab0FWOUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 10:20:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46469 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab0FWOUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 10:20:51 -0400
Date: Wed, 23 Jun 2010 16:20:49 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ping Cheng <pingc@wacom.com>,
       Benjamin Tissoires <tissoire@cena.fr>,
       Chase Douglas <chase.douglas@canonical.com>,
       Rafi Rubin <rafi@seas.upenn.edu>
Subject: Re: [PATCH 4/5] hid-input: Use a larger event buffer for MT
 devices
In-Reply-To: <1277291686-7153-5-git-send-email-rydberg@euromail.se>
Message-ID: <alpine.LNX.2.00.1006231619570.13809@pobox.suse.cz>
References: <1277291686-7153-1-git-send-email-rydberg@euromail.se> <1277291686-7153-2-git-send-email-rydberg@euromail.se> <1277291686-7153-3-git-send-email-rydberg@euromail.se> <1277291686-7153-4-git-send-email-rydberg@euromail.se>
 <1277291686-7153-5-git-send-email-rydberg@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jun 2010, Henrik Rydberg wrote:

> The MT devices produce a lot of data. Tell the underlying input device
> approximately how many events will be sent per synchronization, to allow
> for better buffering. The number is a template based on continuously
> reporting details for each finger on a single hand.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Feel free to add

	Signed-off-by: Jiri Kosina <jkosina@suse.cz>

to any other further patch respins (if needed), or if actually applying 
this patch to any tree together with the rest of the series.

Thanks.

> ---
>  drivers/hid/hid-input.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index 7a0d2e4..69d152e 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -534,6 +534,9 @@ mapped:
>  			input_set_abs_params(input, usage->code, a, b, (b - a) >> 8, (b - a) >> 4);
>  		else	input_set_abs_params(input, usage->code, a, b, 0, 0);
>  
> +		/* use a larger default input buffer for MT devices */
> +		if (usage->code == ABS_MT_POSITION_X && input->hint_events_per_packet == 0)
> +			input_set_events_per_packet(input, 60);
>  	}
>  
>  	if (usage->type == EV_ABS &&
> -- 
> 1.6.3.3
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

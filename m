Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab0K2JrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:47:25 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44674 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab0K2JrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:47:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=idaRkXAXInpZXoVA1aA4sHYHP1fpKpXhpvPf0ovQ9ItrhTZ4XG4U9jaFfAesxJAo0X
         guaiv9ckqqS+wz2xWWCX+OHIONPBDCsfmkO3l0s0jCKmfx60GTg1gkGSNul9liDXQckZ
         tTxPFyEYmdPknR5vZNGsJk6ipvGAnnJVologg=
Date: Mon, 29 Nov 2010 01:47:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] input: mt: Add pressure to pointer emulation code
Message-ID: <20101129094715.GA9303@core.coreip.homeip.net>
References: <1291014802-17061-1-git-send-email-rydberg@euromail.se>
 <1291014802-17061-5-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291014802-17061-5-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 08:13:22AM +0100, Henrik Rydberg wrote:
> Some MT devices report pressure per contact. This patch adds
> ABS_PRESSURE to the pointer emulation code.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/input/input-mt.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
> index 08aa682..49ccd15 100644
> --- a/drivers/input/input-mt.c
> +++ b/drivers/input/input-mt.c
> @@ -97,7 +97,8 @@ EXPORT_SYMBOL(input_mt_report_slot_state);
>   * input_mt_report_pointer_emulation() - common pointer emulation
>   * @dev: input device with allocated MT slots
>   *
> - * Performs legacy pointer emulation via BTN_TOUCH, ABS_X and ABS_Y.
> + * Performs legacy pointer emulation via BTN_TOUCH, ABS_X, ABS_Y and
> + * ABS_PRESSURE.
>   */
>  void input_mt_report_pointer_emulation(struct input_dev *dev)
>  {
> @@ -124,9 +125,13 @@ void input_mt_report_pointer_emulation(struct input_dev *dev)
>  	if (oldest) {
>  		int x = input_mt_get_value(oldest, ABS_MT_POSITION_X);
>  		int y = input_mt_get_value(oldest, ABS_MT_POSITION_Y);
> +		int p = input_mt_get_value(oldest, ABS_MT_PRESSURE);

What if device does not report ABS_MT_PRESSURE/ABS_PRESSURE? Do we rely
on input core to suppress unsupported events? A comment would be nice...

Also, is there a gelper to set up pointer emulation capabilities for MT
device?

>  
>  		input_event(dev, EV_ABS, ABS_X, x);
>  		input_event(dev, EV_ABS, ABS_Y, y);
> +		input_event(dev, EV_ABS, ABS_PRESSURE, p);
> +	} else {
> +		input_event(dev, EV_ABS, ABS_PRESSURE, 0);
>  	}
>  }
>  EXPORT_SYMBOL(input_mt_report_pointer_emulation);
> -- 
> 1.7.1
> 

-- 
Dmitry

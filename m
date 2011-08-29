Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab1H2L6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 07:58:35 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.100]:35070 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab1H2L63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 07:58:29 -0400
Message-ID: <4E5B7EE7.6070103@ladisch.de>
Date: Mon, 29 Aug 2011 13:58:31 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] sound: usb: mixer: increase control transfer timeout
References: <1314616226-15942-1-git-send-email-balbi@ti.com>
In-Reply-To: <1314616226-15942-1-git-send-email-balbi@ti.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-usb@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi wrote:
> 100ms might not be enough for slower devices. Increasing
> timeout to 1000ms doesn't seem like overkill.
> 
> --- a/sound/usb/mixer.c
> +++ b/sound/usb/mixer.c
> @@ -296,7 +296,7 @@ static int get_ctl_value_v1(struct usb_mixer_elem_info *cval, int request, int v
>  		if (snd_usb_ctl_msg(chip->dev, usb_rcvctrlpipe(chip->dev, 0), request,
>  				    USB_RECIP_INTERFACE | USB_TYPE_CLASS | USB_DIR_IN,
>  				    validx, snd_usb_ctrl_intf(chip) | (cval->id << 8),
> -				    buf, val_len, 100) >= val_len) {
> +				    buf, val_len, 1000) >= val_len) {

If the timeout for reading values needs to be increased, writing (in
snd_usb_mixer_set_ctl_value) probably needs some attention too.


Regards,
Clemens

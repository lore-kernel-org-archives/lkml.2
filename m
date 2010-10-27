Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760617Ab0J0I1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 04:27:09 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51753 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab0J0I1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 04:27:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oPvhN1zo8Ac2GHAPA09s9fWcMEn+tiaYROCNl7dwaTeoOHspO3M37/zIc8Wt573nrz
         QoKCqWQ46zW3RKHSeuMdUaaQfzAhUxLyEFogEiFqmd+l28BtYQQWee7BI1F6ruw2kX8U
         zzhb2rsnVrSuaODRwVT7xSFOywYoGMqwoJfIY=
Date: Wed, 27 Oct 2010 01:26:58 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/in,put/mouse/psmouse-base.c: fix messages to
 point to existing file
Message-ID: <20101027082657.GA28895@core.coreip.homeip.net>
References: <4CC7D1CC.8090008@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC7D1CC.8090008@toshiba.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yoshitake,

On Wed, Oct 27, 2010 at 08:16:28AM +0100, KOBAYASHI Yoshitake wrote:
> This patch makes it easier to find the file.
> 
> Signed-off-by: Yoshitake Kobayashi <yoshitake.kobayashi@toshiba.co.jp>
> ---
>  drivers/input/mouse/psmouse-base.c |   36 ++++++++++++++++++++++++------------
>  1 files changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
> index 73a7af2..ecc476d 100644
> --- a/drivers/input/mouse/psmouse-base.c
> +++ b/drivers/input/mouse/psmouse-base.c
> @@ -251,11 +251,13 @@ static int psmouse_handle_byte(struct psmouse *psmouse)
>  	switch (rc) {
>  	case PSMOUSE_BAD_DATA:
>  		if (psmouse->state == PSMOUSE_ACTIVATED) {
> -			printk(KERN_WARNING "psmouse.c: %s at %s lost sync at byte %d\n",
> +			printk(KERN_WARNING
> +				"psmouse-base.c: %s at %s lost sync at byte %d\n",
>  				psmouse->name, psmouse->phys, psmouse->pktcnt);
>  			if (++psmouse->out_of_sync_cnt == psmouse->resetafter) {
>  				__psmouse_set_state(psmouse, PSMOUSE_IGNORE);
> -				printk(KERN_NOTICE "psmouse.c: issuing reconnect request\n");
> +				printk(KERN_NOTICE
> +					"psmouse-base.c: issuing reconnect request\n");

Thank you very much for your patch, however I have a patch from Joe
Perches in my queue that converts input devices to use pr_err() and
similar helpers and KBUILD_BASENAME as format prefix. This will produce
result similar to your patch but is more maintenable since the messages
need not be updated if they are moved or source file is renamed.

Thanks.

-- 
Dmitry

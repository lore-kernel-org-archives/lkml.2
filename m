Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab1CVGGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 02:06:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48811 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab1CVGGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 02:06:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ghiXOmafB+BmwwhkPqvGlMms45XFabeeurA4ie/KyAX7PuGJMZHr1yMtKp/hO5UR0j
         GsRfanFDxEQhEZoXoGeSedvxLKRNhLuJLID4hh21iaFcsI1I5D9SMrM5A0+tpNyDseM4
         4t9fGax+fs+8Q6bu643bQMW+A0wRYn2VYoMPI=
Subject: Re: [PATCH] usb_wwan: fix build error in play_delayed.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <1300768162-18394-1-git-send-email-tm@tao.ma>
References: <1300768162-18394-1-git-send-email-tm@tao.ma>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 07:05:55 +0100
Message-ID: <1300773955.2837.24.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 22 mars 2011 à 12:29 +0800, Tao Ma a écrit :
> From: Tao Ma <boyu.mt@taobao.com>
> 
> There is a build error in today's linus tree.
> drivers/usb/serial/usb_wwan.c: In function ‘play_delayed’:
> drivers/usb/serial/usb_wwan.c:702: error: ‘struct dev_pm_info’ has no member named ‘usage_count’
> The reason is that usage_count is wrapped with macro CONFIG_PM_RUNTIME
> now in dev_pm_info.
> 
> So use the corresponding pm_runtime_get_noresume instead.
> 
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  drivers/usb/serial/usb_wwan.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
> index a65ddd5..5858ce4 100644
> --- a/drivers/usb/serial/usb_wwan.c
> +++ b/drivers/usb/serial/usb_wwan.c
> @@ -699,7 +699,7 @@ static void play_delayed(struct usb_serial_port *port)
>  			do {
>  				unbusy_queued_urb(urb, portdata);
>  				//extremely dirty
> -				atomic_dec(&port->serial->interface->dev.power.usage_count);
> +				pm_runtime_get_noresume(&port->serial->interface->dev);
>  			} while ((urb = usb_get_from_anchor(&portdata->delayed)));
>  			break;
>  		}

Oh well, thats the third time this patch is sent



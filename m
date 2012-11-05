Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab2KEE5j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 23:57:39 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:44438 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab2KEE5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 23:57:36 -0500
Date: Sun, 4 Nov 2012 20:57:35 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harvey Yang <harvey.huawei.yang@gmail.com>
Cc: Matt Mooney <mfm@muteddisk.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: usbip: remove an unnecessary lock in
 usbip_event_happened. The variable "happened" is local. So I think there is
 no need to lock here.
Message-ID: <20121105045735.GA912@kroah.com>
References: <1352091026-5441-1-git-send-email-huawei.yang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352091026-5441-1-git-send-email-huawei.yang@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 12:50:26PM +0800, Harvey Yang wrote:
> From: harvey.yang <harvey.huawei.yang@gmail.com>
> 
> 
> Signed-off-by: harvey.yang <harvey.huawei.yang@gmail.com>
> ---
>  drivers/staging/usbip/usbip_event.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/usbip/usbip_event.c b/drivers/staging/usbip/usbip_event.c
> index d332a34..668f8e0 100644
> --- a/drivers/staging/usbip/usbip_event.c
> +++ b/drivers/staging/usbip/usbip_event.c
> @@ -116,10 +116,8 @@ int usbip_event_happened(struct usbip_device *ud)
>  {
>  	int happened = 0;
>  
> -	spin_lock(&ud->lock);
>  	if (ud->event != 0)
>  		happened = 1;
> -	spin_unlock(&ud->lock);
>  
>  	return happened;

Are you sure that the real fix for this isn't just making 'happened' a
static variable?  That would make more sense here.  Well maybe, the code
seems pretty dumb, it's hard to tell what this is supposed to be doing,
any ideas?

thanks,

greg k-h

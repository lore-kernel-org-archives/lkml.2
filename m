Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab0GLMhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 08:37:41 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:56098 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab0GLMhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 08:37:39 -0400
Subject: Re: macbook webcam no longer works on .35-rc
From: Johannes Berg <johannes@sipsolutions.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <201007051023.40923.laurent.pinchart@ideasonboard.com>
References: <1277932269.11050.1.camel@jlt3.sipsolutions.net>
	 <201007050928.46888.laurent.pinchart@ideasonboard.com>
	 <1278317753.4993.136.camel@jlt3.sipsolutions.net>
	 <201007051023.40923.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Jul 2010 14:36:26 +0200
Message-ID: <1278938186.5870.18.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-05 at 10:23 +0200, Laurent Pinchart wrote:

> Could you please test the following patch when you will have time ?

That fixes it, thank you.

johannes

> diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
> index 9af4d47..a350fad 100644
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c
> @@ -122,8 +122,8 @@ static struct uvc_control_info uvc_ctrls[] = {
>  		.selector	= UVC_PU_POWER_LINE_FREQUENCY_CONTROL,
>  		.index		= 10,
>  		.size		= 1,
> -		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
> -				| UVC_CONTROL_RESTORE,
> +		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
> +				| UVC_CONTROL_GET_DEF | UVC_CONTROL_RESTORE,
>  	},
>  	{
>  		.entity		= UVC_GUID_UVC_PROCESSING,
> 
> 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab2ETUq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 16:46:26 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:42422 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab2ETUqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 16:46:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 06/10] video/uvc: use memweight()
Date: Sun, 20 May 2012 22:46:35 +0200
Message-ID: <7559275.nOXNfWAdxV@avalon>
User-Agent: KMail/4.8.3 (Linux/3.2.1-gentoo-r2; KDE/4.8.3; x86_64; ; )
In-Reply-To: <1337520203-29147-6-git-send-email-akinobu.mita@gmail.com>
References: <1337520203-29147-1-git-send-email-akinobu.mita@gmail.com> <1337520203-29147-6-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Akinobu,

Thank you for the patch.

On Sunday 20 May 2012 22:23:19 Akinobu Mita wrote:
> Use memweight() to count the total number of bits set in memory area.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: linux-media@vger.kernel.org

Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/video/uvc/uvc_ctrl.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
> b/drivers/media/video/uvc/uvc_ctrl.c index 0efd3b1..8683be0 100644
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c
> @@ -1851,7 +1851,7 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
>  	/* Walk the entities list and instantiate controls */
>  	list_for_each_entry(entity, &dev->entities, list) {
>  		struct uvc_control *ctrl;
> -		unsigned int bControlSize = 0, ncontrols = 0;
> +		unsigned int bControlSize = 0, ncontrols;
>  		__u8 *bmControls = NULL;
> 
>  		if (UVC_ENTITY_TYPE(entity) == UVC_VC_EXTENSION_UNIT) {
> @@ -1869,8 +1869,7 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
>  		uvc_ctrl_prune_entity(dev, entity);
> 
>  		/* Count supported controls and allocate the controls array */
> -		for (i = 0; i < bControlSize; ++i)
> -			ncontrols += hweight8(bmControls[i]);
> +		ncontrols = memweight(bmControls, bControlSize);
>  		if (ncontrols == 0)
>  			continue;

-- 
Regards,

Laurent Pinchart


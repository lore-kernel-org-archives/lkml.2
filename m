Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2FRXGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 19:06:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab2FRXGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 19:06:33 -0400
Message-ID: <4FDFB475.3070805@redhat.com>
Date: Mon, 18 Jun 2012 20:06:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v3 5/9] video/uvc: use memweight()
References: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com> <1339203038-13069-5-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1339203038-13069-5-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 08-06-2012 21:50, Akinobu Mita escreveu:
> Use memweight() to count the total number of bits set in memory area.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: linux-media@vger.kernel.org

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> ---
> No changes from v1
> 
>   drivers/media/video/uvc/uvc_ctrl.c |    5 ++---
>   1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
> index af26bbe..f7061a5 100644
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c
> @@ -2083,7 +2083,7 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
>   	/* Walk the entities list and instantiate controls */
>   	list_for_each_entry(entity, &dev->entities, list) {
>   		struct uvc_control *ctrl;
> -		unsigned int bControlSize = 0, ncontrols = 0;
> +		unsigned int bControlSize = 0, ncontrols;
>   		__u8 *bmControls = NULL;
>   
>   		if (UVC_ENTITY_TYPE(entity) == UVC_VC_EXTENSION_UNIT) {
> @@ -2101,8 +2101,7 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
>   		uvc_ctrl_prune_entity(dev, entity);
>   
>   		/* Count supported controls and allocate the controls array */
> -		for (i = 0; i < bControlSize; ++i)
> -			ncontrols += hweight8(bmControls[i]);
> +		ncontrols = memweight(bmControls, bControlSize);
>   		if (ncontrols == 0)
>   			continue;
>   
> 



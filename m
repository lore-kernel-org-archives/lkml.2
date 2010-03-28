Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab0C1PPG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 11:15:06 -0400
Received: from lo.gmane.org ([80.91.229.12]:39013 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab0C1PPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 11:15:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Christophe JAILLET" <christophe.jaillet@wanadoo.fr>
Subject: Re: [patch] video/sn9c102: improve error handling
Date: Sun, 28 Mar 2010 17:09:48 +0200
Message-ID: <honrg5$7uk$1@dough.gmane.org>
References: <20100328115005.GW5069@bicker>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: aorleans-157-1-152-133.w90-63.abo.wanadoo.fr
X-MSMail-Priority: Normal
X-Newsreader: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Antivirus: avast! (VPS 100328-0, 28/03/2010), Outbound message
X-Antivirus-Status: Clean
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch seems incomplete.

You had an opening { wityhout the corresponding }.

Best regards,
Christophe Jaillet.

"Dan Carpenter" <error27@gmail.com> a écrit
dans le message de news:20100328115005.GW5069@bicker...
> Return an error if the controller is not found.
>
> Signed-off-by: Dan Carpenter
<error27@gmail.com>
>
> diff --git a/drivers/media/video/sn9c102/sn9c102_core.c
b/drivers/media/video/sn9c102/sn9c102_core.c
> index cbf8087..28e19da 100644
> --- a/drivers/media/video/sn9c102/sn9c102_core.c
> +++ b/drivers/media/video/sn9c102/sn9c102_core.c
> @@ -2295,7 +2295,7 @@ sn9c102_vidioc_s_ctrl(struct sn9c102_device* cam,
void __user * arg)
>   if (copy_from_user(&ctrl, arg, sizeof(ctrl)))
>   return -EFAULT;
>
> - for (i = 0; i < ARRAY_SIZE(s->qctrl); i++)
> + for (i = 0; i < ARRAY_SIZE(s->qctrl); i++) {
>   if (ctrl.id == s->qctrl[i].id) {
>   if (s->qctrl[i].flags & V4L2_CTRL_FLAG_DISABLED)
>   return -EINVAL;
> @@ -2305,7 +2305,9 @@ sn9c102_vidioc_s_ctrl(struct sn9c102_device* cam,
void __user * arg)
>   ctrl.value -= ctrl.value % s->qctrl[i].step;
>   break;
>   }




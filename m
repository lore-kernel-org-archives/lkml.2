Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab0LUSZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:25:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:55437 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab0LUSZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:25:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thiago Farina <tfransosi@gmail.com>
Subject: Re: [PATCH] drivers/media/video/v4l2-compat-ioctl32.c: Check the return value of copy_to_user
Date: Tue, 21 Dec 2010 19:25:38 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6-next-20101220+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
References: <d21ad74592c295d59f5806f30a053745b5765397.1292894256.git.tfransosi@gmail.com>
In-Reply-To: <d21ad74592c295d59f5806f30a053745b5765397.1292894256.git.tfransosi@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012211925.38201.arnd@arndb.de>
X-Provags-ID: V02:K0:ZzwJGszHwNw7r/eowNVQdIFhBED//g5KVDdA80UnDvt
 baiFBQk1BP8ngUR4DfwfmVBJc49Wr2qwb5YWL1PoydGMmOBmXC
 CUrpc0bYpf/BLhdqADzGS3/KgBmHsvflJFUgngOsrwY49lWjQ4
 eqZr5k1oEp6C1POBnZ6AE0H5RmD2MWD0gzcX4b/EdACkLcsrSO
 GTro2GHnMpJk2r21Sufzg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 December 2010 02:18:06 Thiago Farina wrote:
> diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
> index e30e8df..55825ec 100644
> --- a/drivers/media/video/v4l2-compat-ioctl32.c
> +++ b/drivers/media/video/v4l2-compat-ioctl32.c
> @@ -206,7 +206,9 @@ static struct video_code __user *get_microcode32(struct video_code32 *kp)
>          * user address is invalid, the native ioctl will do
>          * the error handling for us
>          */
> -       (void) copy_to_user(up->loadwhat, kp->loadwhat, sizeof(up->loadwhat));
> +       if (copy_to_user(up->loadwhat, kp->loadwhat, sizeof(up->loadwhat)))
> +               return NULL;
> +
>         (void) put_user(kp->datasize, &up->datasize);
>         (void) put_user(compat_ptr(kp->data), &up->data);
>         return up;

Did you read the comment above the code you changed?

You can probably change this function to look at the return code of
copy_to_user, but then you need to treat the put_user return code
the same, and change the comment.

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112Ab2BNENk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 23:13:40 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62666 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab2BNENi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 23:13:38 -0500
MIME-Version: 1.0
In-Reply-To: <1329192654-11284-1-git-send-email-hamo.by@gmail.com>
References: <1329192654-11284-1-git-send-email-hamo.by@gmail.com>
From: Yang Bai <hamo.by@gmail.com>
Date: Tue, 14 Feb 2012 12:13:18 +0800
Message-ID: <CAO_0yfOyrK_no3KDS7mX1uaFszKWtMtkkRxUKgb+8xrDQANzew@mail.gmail.com>
Subject: Re: [PATCH] scsi: if sd card is removed, do not revalidate it
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Bai <hamo.by@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 12:10 PM, Yang Bai <hamo.by@gmail.com> wrote:
> During revalidating, if sd card is removed, scsi_device
> will be NULL, so we should not revalidate or it will cause
> a panic.
> This problem is report at:
> http://comments.gmane.org/gmane.linux.kernel/1250235
>
> Signed-off-by: Yang Bai <hamo.by@gmail.com>
> ---
>  drivers/scsi/sd.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index c691fb5..470339c 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2370,10 +2370,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
>                                      "sd_revalidate_disk\n"));
>
>        /*
> -        * If the device is offline, don't try and read capacity or any
> +        * If the device is removed or offline, don't try and read capacity or any
>         * of the other niceties.
>         */
> -       if (!scsi_device_online(sdp))
> +       if (!sdp || !scsi_device_online(sdp))
>                goto out;
>
>        buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL);
> --
> 1.7.9
>

Is this the right way to solve this problem? Or should we add
a lock to this struct to protect it?

-- 
    """
    Keep It Simple,Stupid.
    """

Chinese Name: 白杨
Nick Name: Hamo
Homepage: http://hamobai.com/
GPG KEY ID: 0xA4691A33
Key fingerprint = 09D5 2D78 8E2B 0995 CF8E  4331 33C4 3D24 A469 1A33

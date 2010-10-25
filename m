Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab0JYMl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 08:41:56 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54475 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab0JYMlz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 08:41:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tIP2DlKFJC2PuhvzLcfjkzRvxjUZYX3JTMGf0SofWtZJR64Ce3pHb9Gq+lvPWv42ru
         UxpXJ7sLhy0XZnJwPer0N8IFRfdESglyfLC45hXMqE5JwYrCN18DwCnC+IS2FGwnUGCW
         CKDRA7etVgTsutN6clOnckgVkvFDgGaGQAPCY=
MIME-Version: 1.0
In-Reply-To: <1287990698-21690-1-git-send-email-mbroz@redhat.com>
References: <20101023155950.GA31946@lst.de>
	<1287990698-21690-1-git-send-email-mbroz@redhat.com>
Date: Mon, 25 Oct 2010 20:41:54 +0800
Message-ID: <AANLkTi=PupMfGGQXpeM94p+idrSWh3Oqca0MuYtVnCKm@mail.gmail.com>
Subject: Re: [PATCH] loop: Properly clear sysfs in autoclear mode
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Milan Broz <mbroz@redhat.com>
Cc: axboe@kernel.dk, hch@lst.de, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 3:11 PM, Milan Broz <mbroz@redhat.com> wrote:
> In autoclear mode bdev is NULL but the sysfs
> entry should be destroyed otherwise this warning appears:
>
> WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0x82/0x95()
> sysfs: cannot create duplicate filename '/devices/virtual/block/loop0/loop'
>
> Fixes commit ee86273062cbb310665fe49e1f1937d2cf85b0b9
>
> Signed-off-by: Milan Broz <mbroz@redhat.com>
> ---
>  drivers/block/loop.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 6c48b35..c21d4f3 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -1049,9 +1049,9 @@ static int loop_clr_fd(struct loop_device *lo, struct block_device *bdev)
>        if (bdev)
>                invalidate_bdev(bdev);
>        set_capacity(lo->lo_disk, 0);
> +       loop_sysfs_exit(lo);
>        if (bdev) {
>                bd_set_size(bdev, 0);
> -               loop_sysfs_exit(lo);
>                /* let user-space know about this change */
>                kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
>        }

Tested and worked.

Thanks,
Jeff

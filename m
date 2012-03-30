Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934228Ab2C3LX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:23:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58561 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933693Ab2C3LXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:23:21 -0400
MIME-Version: 1.0
In-Reply-To: <4F7582B0.5010609@cn.fujitsu.com>
References: <4F7581D4.4040301@cn.fujitsu.com> <4F7582B0.5010609@cn.fujitsu.com>
From: Asias He <asias.hejun@gmail.com>
Date: Fri, 30 Mar 2012 19:22:39 +0800
Message-ID: <CAFO3S427vWXHBDaRmfwqZrGZ2Y8RPUn7CQswQou9EGMh43jU8Q@mail.gmail.com>
Subject: Re: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass of
 disks naming
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        VIRTUAL <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,  Ren

On Fri, Mar 30, 2012 at 5:53 PM, Ren Mingxin <renmx@cn.fujitsu.com> wrote:
>  The current virtblk's naming algorithm only supports 263  disks.
> If there are mass of virtblks(exceeding 263), there will be disks
> with the same name.

This fix is pretty nice. However, current virtblk's naming still
supports up to 18278 disks, no?
( index 0  -> vda, index 18277 -> vdzzz ).

> By renaming "sd_format_disk_name()" to "disk_name_format()"
> and moving it into block core, virtio_blk can use this function to
> support mass of disks.
>
> Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
> ---
>  virtio_blk.c |   13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
>
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index c4a60ba..54612c2 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -442,18 +442,7 @@ static int __devinit virtblk_probe(struct virtio_device
> *vdev)
>
>        q->queuedata = vblk;
>
> -       if (index < 26) {
> -               sprintf(vblk->disk->disk_name, "vd%c", 'a' + index % 26);
> -       } else if (index < (26 + 1) * 26) {
> -               sprintf(vblk->disk->disk_name, "vd%c%c",
> -                       'a' + index / 26 - 1, 'a' + index % 26);
> -       } else {
> -               const unsigned int m1 = (index / 26 - 1) / 26 - 1;
> -               const unsigned int m2 = (index / 26 - 1) % 26;
> -               const unsigned int m3 =  index % 26;
> -               sprintf(vblk->disk->disk_name, "vd%c%c%c",
> -                       'a' + m1, 'a' + m2, 'a' + m3);
> -       }
> +       disk_name_format("vd", index, vblk->disk->disk_name, DISK_NAME_LEN);
>
>        vblk->disk->major = major;
>        vblk->disk->first_minor = index_to_minor(index);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Asias He

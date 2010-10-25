Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab0JYOlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 10:41:55 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:12593 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0JYOly convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 10:41:54 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Vasiliy Kulikov <segooon@gmail.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
CC: Jens Axboe <jaxboe@fusionio.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        ISS StorageDev <iss_storagedev@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 25 Oct 2010 14:40:55 +0000
Subject: RE: [PATCH 1/2] block: cciss: fix information leak to userland
Thread-Topic: [PATCH 1/2] block: cciss: fix information leak to userland
Thread-Index: Actyi9MAiynw/EFuTcKVj9SuPgH/YgBxq23g
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77887D0E2807DF@GVW0547EXC.americas.hpqcorp.net>
References: <1287822311-14783-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1287822311-14783-1-git-send-email-segooon@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Vasiliy Kulikov [mailto:segooon@gmail.com] 
> Sent: Saturday, October 23, 2010 3:25 AM
> To: kernel-janitors@vger.kernel.org
> Cc: Miller, Mike (OS Dev); Jens Axboe; Stephen M. Cameron; 
> Andrew Morton; ISS StorageDev; linux-kernel@vger.kernel.org
> Subject: [PATCH 1/2] block: cciss: fix information leak to userland
> 
> Structure IOCTL_Command_struct is copied to userland with 
> some padding fields at the end of the struct unitialized.
> It leads to leaking of stack memory.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  drivers/block/cciss.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c 
> index 762a81a..cd08324 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -1142,6 +1142,7 @@ static int 
> cciss_ioctl32_passthru(struct block_device *bdev, fmode_t mode,
>  	int err;
>  	u32 cp;
>  
> +	memset(&arg64, 0, sizeof(arg64));
>  	err = 0;
>  	err |=
>  	    copy_from_user(&arg64.LUN_info, &arg32->LUN_info,
> --

Acked-by: Mike Miller <mike.miller@hp.com>

> 1.7.0.4
> 
> 
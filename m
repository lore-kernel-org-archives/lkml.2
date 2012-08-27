Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab2H0KZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 06:25:47 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:57801 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab2H0KZp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 06:25:45 -0400
In-Reply-To: <20120827090354.GA5840@osiris.de.ibm.com>
References: <1346052196-32682-1-git-send-email-gaowanlong@cn.fujitsu.com> <1346052196-32682-6-git-send-email-gaowanlong@cn.fujitsu.com> <20120827090354.GA5840@osiris.de.ibm.com>
To: heicars2@linux.vnet.ibm.com
Cc: BOEBLINGEN LINUX390 <LINUX390@de.ibm.com>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        "open list:S390" <linux-s390@vger.kernel.org>,
        mschwid2@linux.vnet.ibm.com
MIME-Version: 1.0
Subject: Re: [PATCH 5/5] s390:block:fix up ENOIOCTLCMD error handling
X-KeepSent: A9F14DCC:A1DFDC50-C1257A67:0038C99B;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
From: Stefan Weinhuber <WEIN@de.ibm.com>
Message-ID: <OFA9F14DCC.A1DFDC50-ONC1257A67.0038C99B-C1257A67.003947D3@de.ibm.com>
Date: Mon, 27 Aug 2012 12:25:32 +0200
X-MIMETrack: Serialize by Router on D06ML030/06/M/IBM(Release 8.5.3 ZX853HP5|January 12, 2012) at
 27/08/2012 12:25:32,
	Serialize complete at 27/08/2012 12:25:32
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
x-cbid: 12082710-6892-0000-0000-000002D1E8D6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

heicars2@linux.vnet.ibm.com wrote on 2012-08-27 11:03:55:

[..]
> 
> Thanks, but you missed the else path. I'm going to commit the patch 
below
> unless Stefan has any objections:
> 
> From dac16bd8b314dc6f3f4e6815feab199fdfc8cddd Mon Sep 17 00:00:00 2001
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date: Mon, 27 Aug 2012 10:59:42 +0200
> Subject: [PATCH] s390/dasd: fix ioctl return value
> 
> For unimplemented ioctls the dasd driver should return -ENOTTY.
> 
> Reported-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  drivers/s390/block/dasd_eckd.c  | 2 +-
>  drivers/s390/block/dasd_ioctl.c | 7 ++-----
>  2 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/s390/block/dasd_eckd.c 
b/drivers/s390/block/dasd_eckd.c
> index 40a826a..2fb2b9e 100644
> --- a/drivers/s390/block/dasd_eckd.c
> +++ b/drivers/s390/block/dasd_eckd.c
> @@ -3804,7 +3804,7 @@ dasd_eckd_ioctl(struct dasd_block *block, 
> unsigned int cmd, void __user *argp)
>     case BIODASDSYMMIO:
>        return dasd_symm_io(device, argp);
>     default:
> -      return -ENOIOCTLCMD;
> +      return -ENOTTY;
>     }
>  }
> 
> diff --git a/drivers/s390/block/dasd_ioctl.c 
b/drivers/s390/block/dasd_ioctl.c
> index cceae70..654c692 100644
> --- a/drivers/s390/block/dasd_ioctl.c
> +++ b/drivers/s390/block/dasd_ioctl.c
> @@ -498,12 +498,9 @@ int dasd_ioctl(struct block_device *bdev, fmode_t 
mode,
>        break;
>     default:
>        /* if the discipline has an ioctl method try it. */
> -      if (base->discipline->ioctl) {
> +      rc = -ENOTTY;
> +      if (base->discipline->ioctl)
>           rc = base->discipline->ioctl(block, cmd, argp);
> -         if (rc == -ENOIOCTLCMD)
> -            rc = -EINVAL;
> -      } else
> -         rc = -EINVAL;
>     }
>     dasd_put_device(base);
>     return rc;
> -- 
> 1.7.11.5
> 

The patch is looking fine to me, thanks.

Mit freundlichen Grüßen / Kind regards
 
Stefan Weinhuber




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab2IMC2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 22:28:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175Ab2IMC2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 22:28:33 -0400
Message-ID: <505144D0.4080908@redhat.com>
Date: Thu, 13 Sep 2012 10:28:32 +0800
From: hank <pyu@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: neilb@suse.de, miku@iki.fi, jakob@ostenfeld.dk, ptb@it.uc3m.es
CC: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Subject: [PATCH 1/1] drivers/md/raid1.c: fix NULL pointer bug
 in fix_read_error function
References: <5045708C.10705@redhat.com>
In-Reply-To: <5045708C.10705@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2012 11:07 AM, hank wrote:

> From 0ba5879082544dc3aa13807087563b1258124b1e Mon Sep 17 00:00:00 2001
> From: hank <pyu@redhat.com>
> Date: Tue, 4 Sep 2012 10:23:45 +0800
> Subject: [PATCH 1/1] drivers/md/raid1.c: fix NULL pointer bug in
>  fix_read_error function
> 
> in fix_read_error function, the conf->mirrors[read_disk].rdev may
> become NULL, as in this function, rdev->nr_pending may be zero, anyone
> can delete it. So should check if it is NULL before use.
> 
> Signed-off-by: hank <pyu@redhat.com>
> ---
>  drivers/md/raid1.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 611b5f7..fd8de28 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2005,7 +2005,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
>  		if (!success) {
>  			/* Cannot read from anywhere - mark it bad */
>  			struct md_rdev *rdev = conf->mirrors[read_disk].rdev;
> -			if (!rdev_set_badblocks(rdev, sect, s, 0))
> +			if (!rdev || !rdev_set_badblocks(rdev, sect, s, 0))
>  				md_error(mddev, rdev);
>  			break;
>  		}



Anyone can review this patch? I think it is a bug and should be fixed.

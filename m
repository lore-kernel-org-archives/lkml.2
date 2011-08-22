Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab1HVLa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 07:30:28 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:59620 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055Ab1HVLaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 07:30:22 -0400
Date: Mon, 22 Aug 2011 13:30:04 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: linux-kernel@vger.kernel.org, hjk@hansjkoch.de, gregkh@suse.de,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH v2] drivers:uio:change the goto label to consistent with
 others
Message-ID: <20110822113004.GB14373@local>
References: <1313813528-30913-1-git-send-email-wanlong.gao@gmail.com>
 <1313813528-30913-2-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313813528-30913-2-git-send-email-wanlong.gao@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 20, 2011 at 12:12:08PM +0800, Wanlong Gao wrote:
> From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> 
> sorry for v1's typo mistake.
> Thanks
> 
> Remove one *goto* label in uio.c.

Nice, that makes it a bit cleaner.

Thanks,
Hans

> 
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>

Signed-off-by: "Hans J. Koch" <hjk@hansjkoch.de>

> ---
>  drivers/uio/uio.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index d2efe82..c89f12a 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -750,14 +750,13 @@ static int uio_major_init(void)
>  
>  	uio_major = MAJOR(uio_dev);
>  	uio_cdev = cdev;
> -	result = 0;
> -out:
> -	return result;
> +	return 0;
>  out_put:
>  	kobject_put(&cdev->kobj);
>  out_unregister:
>  	unregister_chrdev_region(uio_dev, UIO_MAX_DEVICES);
> -	goto out;
> +out:
> +	return result;
>  }
>  
>  static void uio_major_cleanup(void)
> -- 
> 1.7.4.1
> 
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab1CHObO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 09:31:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab1CHObK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 09:31:10 -0500
Date: Tue, 8 Mar 2011 09:31:02 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Justin TerAvest <teravest@google.com>
Cc: jaxboe@fusionio.com, ctalbott@google.com, guijianfeng@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-cgroup: Lower minimum weight from 100 to 10.
Message-ID: <20110308143102.GC27455@redhat.com>
References: <1299538394-9669-1-git-send-email-teravest@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299538394-9669-1-git-send-email-teravest@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 02:53:14PM -0800, Justin TerAvest wrote:
> We've found that we still get good, useful isolation at weights this
> low. I'd like to adjust the minimum so that any other changes can take
> these values into account.
> ---
>  Documentation/cgroups/blkio-controller.txt |    2 +-
>  block/blk-cgroup.h                         |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek

> diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
> index 4ed7b5c..24314fd 100644
> --- a/Documentation/cgroups/blkio-controller.txt
> +++ b/Documentation/cgroups/blkio-controller.txt
> @@ -140,7 +140,7 @@ Proportional weight policy files
>  	- Specifies per cgroup weight. This is default weight of the group
>  	  on all the devices until and unless overridden by per device rule.
>  	  (See blkio.weight_device).
> -	  Currently allowed range of weights is from 100 to 1000.
> +	  Currently allowed range of weights is from 10 to 1000.
>  
>  - blkio.weight_device
>  	- One can specify per cgroup per device rules using this interface.
> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> index ea4861b..57e7234 100644
> --- a/block/blk-cgroup.h
> +++ b/block/blk-cgroup.h
> @@ -240,7 +240,7 @@ static inline char *blkg_path(struct blkio_group *blkg) { return NULL; }
>  
>  #endif
>  
> -#define BLKIO_WEIGHT_MIN	100
> +#define BLKIO_WEIGHT_MIN	10
>  #define BLKIO_WEIGHT_MAX	1000
>  #define BLKIO_WEIGHT_DEFAULT	500
>  
> -- 
> 1.7.3.1

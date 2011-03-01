Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1CAFqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:46:17 -0500
Received: from kroah.org ([198.145.64.141]:43572 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012Ab1CAFqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:46:16 -0500
Date: Mon, 28 Feb 2011 18:34:49 -0800
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 1/6] Staging: hv: Unify hyper-v device abstractions
Message-ID: <20110301023449.GC1663@kroah.com>
References: <1298685930-30806-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298685930-30806-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 06:05:30PM -0800, K. Y. Srinivasan wrote:
> Hyper-V drivers have supported two device abstractions.
> This patch implements a single device abstraction.

"This patch" or "This patch series"?

> This simplifies the code and avoids duplication
> of state.

This patch is confusing, you are renaming structures (from hv_ to vm_)
which I didn't think you wanted to do.

> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> 
> ---
>  drivers/staging/hv/blkvsc.c        |   17 ++++---
>  drivers/staging/hv/blkvsc_drv.c    |   14 +++---
>  drivers/staging/hv/channel_mgmt.c  |    1 +
>  drivers/staging/hv/channel_mgmt.h  |    2 +-
>  drivers/staging/hv/netvsc.c        |   55 ++++++++++++-----------
>  drivers/staging/hv/netvsc.h        |    2 +-
>  drivers/staging/hv/netvsc_api.h    |   12 +++---
>  drivers/staging/hv/netvsc_drv.c    |   28 +++++-------
>  drivers/staging/hv/rndis_filter.c  |   19 ++++----
>  drivers/staging/hv/storvsc.c       |   37 ++++++++--------
>  drivers/staging/hv/storvsc_api.h   |    4 +-
>  drivers/staging/hv/storvsc_drv.c   |   21 ++++-----
>  drivers/staging/hv/vmbus.h         |   13 +++---
>  drivers/staging/hv/vmbus_api.h     |   29 ++----------
>  drivers/staging/hv/vmbus_drv.c     |   84 +++++++++++++++---------------------
>  drivers/staging/hv/vmbus_private.h |   12 +++---
>  16 files changed, 157 insertions(+), 193 deletions(-)
> 
> diff --git a/drivers/staging/hv/blkvsc.c b/drivers/staging/hv/blkvsc.c
> index 7c8729b..ecface3 100644
> --- a/drivers/staging/hv/blkvsc.c
> +++ b/drivers/staging/hv/blkvsc.c
> @@ -35,7 +35,8 @@ static const struct hv_guid g_blk_device_type = {
>  	}
>  };
>  
> -static int blk_vsc_on_device_add(struct hv_device *device, void *additional_info)
> +static int blk_vsc_on_device_add(struct vm_device *device,
> +				void *additional_info)

Huh?  What was this change for?  80 column issues for function
definitions is not a big deal, if any, and should not be burried in a
patch that claims to do something else.

Still totally confused,

greg k-h

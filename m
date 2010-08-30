Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab0HaAAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 20:00:07 -0400
Received: from kroah.org ([198.145.64.141]:50058 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569Ab0HaAAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 20:00:05 -0400
Date: Mon, 30 Aug 2010 16:51:33 -0700
From: Greg KH <greg@kroah.com>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "'gregkh@suse.de'" <gregkh@suse.de>
Subject: Re: [PATCH 5/5] staging: hv: Gracefully handle SCSI resets
Message-ID: <20100830235133.GB22941@kroah.com>
References: <8AFC7968D54FB448A30D8F38F259C56223FEC8AF@TK5EX14MBXC114.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56223FEC8AF@TK5EX14MBXC114.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 07:30:37PM +0000, Hank Janssen wrote:
> From: Hank Janssen <hjanssen@microsoft.com>
> 
> If we get a SCSI host bus reset we now gracefully handle it, and we take the
> device offline. This before sometimes caused hangs.
> 
> Signed-off-by:Hank Janssen <hjanssen@microsoft.com>
> Signed-off-by:Haiyang Zhang <haiyangz@microsoft.com>
> Cc: stable <stable@kernel.org>
> 
> ---
>  drivers/staging/hv/storvsc.c |   36 +++++++++++++++++++++++++++++++++++-
>  1 files changed, 35 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c index 6bd2ff1..5f222cf 100644
> --- a/drivers/staging/hv/storvsc.c
> +++ b/drivers/staging/hv/storvsc.c
> @@ -48,7 +48,9 @@ struct storvsc_device {
>  
>  	/* 0 indicates the device is being destroyed */
>  	atomic_t RefCount;
> -
> +	
> +	int reset;
> +	spinlock_t lock;
>  	atomic_t NumOutstandingRequests;
>  
>  	/*
> @@ -93,6 +95,9 @@ static inline struct storvsc_device *AllocStorDevice(struct hv_device *Device)
>  	atomic_cmpxchg(&storDevice->RefCount, 0, 2);
>  
>  	storDevice->Device = Device;
> +	storDevice->reset  = 0;
> +	spin_lock_init(&storDevice->lock);
> +
>  	Device->Extension = storDevice;
>  
>  	return storDevice;
> @@ -101,6 +106,7 @@ static inline struct storvsc_device *AllocStorDevice(struct hv_device *Device)  static inline void FreeStorDevice(struct storvsc_device *Device)  {
>  	/* ASSERT(atomic_read(&Device->RefCount) == 0); */

This patch is corrupted as well, something odd is going on in your email
system :(

care to resend it?

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab1AQJnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 04:43:43 -0500
Received: from daytona.panasas.com ([67.152.220.89]:24538 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab1AQJnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 04:43:42 -0500
Message-ID: <4D340F49.6030604@panasas.com>
Date: Mon, 17 Jan 2011 11:43:37 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: David Dillow <dillowda@ornl.gov>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        James.Bottomley@suse.de
Subject: Re: scsi: include linux/scatterlist.h to pick up ARCH_HAS_SG_CHAIN
References: <1295208759.2574.14.camel@obelisk.thedillows.org>
In-Reply-To: <1295208759.2574.14.camel@obelisk.thedillows.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jan 2011 09:43:39.0319 (UTC) FILETIME=[04F4C470:01CBB62B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2011 10:12 PM, David Dillow wrote:
> If the compiled object doesn't include linux/scatterlist.h before
> scsi/scsi.h, it will get an incorrect definition of
> SCSI_MAX_SG_CHAIN_SEGMENTS.
> 
> Signed-off-by: David Dillow <dillowda@ornl.gov>
> --
> This fixes an issue I found while working on the SRP initiator, where
> linux/scatterlist.h was being pulled in by scsi/scsi_device.h. It's not
> clear if I'm supposed to include linux/scatterlist.h myself, or if I'm
> including the scsi headers in the wrong order. It makes sense for me
> that scsi.h would pickup the needed headers itself to prevent confusion.
> 

I totally agree. This below is the proper fix!

> Another option is to potentially get rid of the ARCH_HAS_SG_CHAIN define
> as all archs have it save m68knommu.
> 

What's preventing m68knommu from chaining? this is pure C manipulations,
what am I missing?

Thanks for catching this. As is, it is vary dangerous. I wonder where
else did it hit unnoticed?

Boaz

> 
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index 648d233..b76d400 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -9,6 +9,7 @@
>  #define _SCSI_SCSI_H
>  
>  #include <linux/types.h>
> +#include <linux/scatterlist.h>
>  
>  struct scsi_cmnd;
>  
> 

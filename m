Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab2LUCUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 21:20:00 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:48706 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2LUCTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 21:19:52 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 21:19:52 EST
Date: Fri, 21 Dec 2012 04:13:59 +0200
From: Ido Yariv <ido@wizery.com>
To: Sjur =?iso-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org,
        Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjur@brendeland.net>
Subject: Re: [RFCv2 03/11] remoteproc: Set vring addresses in resource table
Message-ID: <20121221021358.GA28692@WorkStation.localnet>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
 <1355501220-4572-4-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1355501220-4572-4-git-send-email-sjur.brandeland@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Fri, Dec 14, 2012 at 05:06:52PM +0100, Sjur Brændeland wrote:
> Set the vring addresses in the resource table so that
> the remote device can read the actual addresses used.
> 
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

Since this new member will only be referenced in the last patch, perhaps
squash the two patches?

> ---
>  drivers/remoteproc/remoteproc_core.c |    5 +++++
>  include/linux/remoteproc.h           |    2 ++
>  2 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
> index 7d593a1..151e138 100644
> --- a/drivers/remoteproc/remoteproc_core.c
> +++ b/drivers/remoteproc/remoteproc_core.c
> @@ -238,6 +238,8 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
>  	rvring->dma = dma;
>  	rvring->notifyid = notifyid;
>  
> +	rvdev->rsc->vring[i].da = dma;

This could be a bit problematic when iommu is used. Since not all
platforms use dma_alloc_coherent to automatically set up the iommu, the
dma variable might hold the physical address instead of the device
address. Setting da may be a bit misleading, so this should probably be
documented.

Thanks,
Ido.

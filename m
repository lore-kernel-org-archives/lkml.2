Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab0HCRrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:47:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:44249 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757324Ab0HCRri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:47:38 -0400
Date: Tue, 3 Aug 2010 10:38:57 -0700
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 2/6] staging: hv: Fixed lockup problem with
 bounce_buffer scatter list
Message-ID: <20100803173857.GB1455@suse.de>
References: <8AFC7968D54FB448A30D8F38F259C56223FD1D29@TK5EX14MBXC114.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56223FD1D29@TK5EX14MBXC114.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 05:31:53PM +0000, Hank Janssen wrote:
> From: Hank Janssen <hjanssen@microsoft.com>
> 
> Fixed lockup problem with bounce_buffer scatter list which caused crashes in heavy loads.

Same questions for you as patch 1/6.

Also, please wrap your changelog comments at 72 columns.

> 
> Signed-off-by:Hank Janssen <hjanssen@microsoft.com>
> Signed-off-by:Haiyang Zhang <haiyangz@microsoft.com> 

What's with the trailing space?

> 
> ---
>  drivers/staging/hv/storvsc_drv.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
> index 3b9ccb0..169d701 100644
> --- a/drivers/staging/hv/storvsc_drv.c
> +++ b/drivers/staging/hv/storvsc_drv.c
> @@ -615,6 +615,7 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
>  	unsigned int request_size = 0;
>  	int i;
>  	struct scatterlist *sgl;
> +	unsigned int sg_count = 0;
>  
>  	DPRINT_DBG(STORVSC_DRV, "scmnd %p dir %d, use_sg %d buf %p len %d "
>  		   "queue depth %d tagged %d", scmnd, scmnd->sc_data_direction, @@ -697,6 +698,7 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
>  	request->DataBuffer.Length = scsi_bufflen(scmnd);
>  	if (scsi_sg_count(scmnd)) {
>  		sgl = (struct scatterlist *)scsi_sglist(scmnd);
> +		sg_count = scsi_sg_count(scmnd);
>  
>  		/* check if we need to bounce the sgl */
>  		if (do_bounce_buffer(sgl, scsi_sg_count(scmnd)) != -1) { @@ -731,15 +733,16 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
>  					      scsi_sg_count(scmnd));
>  
>  			sgl = cmd_request->bounce_sgl;
> +			sg_count = cmd_request->bounce_sgl_count;
>  		}
>  
>  		request->DataBuffer.Offset = sgl[0].offset;
>  
> -		for (i = 0; i < scsi_sg_count(scmnd); i++) {
> +		for (i = 0; i < sg_count; i++) {
>  			DPRINT_DBG(STORVSC_DRV, "sgl[%d] len %d offset %d\n",
>  				   i, sgl[i].length, sgl[i].offset);
> -			request->DataBuffer.PfnArray[i] =
> -					page_to_pfn(sg_page((&sgl[i])));
> +			request->DataBuffer.PfnArray[i] = 

Trailing space here?

You didn't run 'checkpatch.pl' now did you :)

You should set your editor to show up trailing spaces in bright red to
keep this from happening.  I can tell you how to do this in vim, all
other editors, you are on your own.

thanks,

greg k-h

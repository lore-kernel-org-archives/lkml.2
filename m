Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab0DJRCs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 13:02:48 -0400
Received: from cnc.isely.net ([64.81.146.143]:36617 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab0DJRCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 13:02:47 -0400
Date: Sat, 10 Apr 2010 11:57:05 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Joe Perches <joe@perches.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Isely <isely@isely.net>
Subject: Re: [PATCH 09/11] pvrusb2-v4l2: Rename dev_info to pdi
In-Reply-To: <2044c4a5829aa21c3ec4bb90535289dd749bf4f1.1270493677.git.joe@perches.com>
Message-ID: <alpine.DEB.1.10.1004101156450.5518@ivanova.isely.net>
References: <20100304232928.2e45bdd1.akpm@linux-foundation.org> <2044c4a5829aa21c3ec4bb90535289dd749bf4f1.1270493677.git.joe@perches.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-By: Mike Isely <isely@pobox.com>

  -Mike


On Mon, 5 Apr 2010, Joe Perches wrote:

> There is a macro called dev_info that prints struct device specific
> information.  Having variables with the same name can be confusing and
> prevents conversion of the macro to a function.
> 
> Rename the existing dev_info variables to something else in preparation
> to converting the dev_info macro to a function.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/media/video/pvrusb2/pvrusb2-v4l2.c |   22 +++++++++++-----------
>  1 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> index cc8ddb2..ba32c91 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> @@ -48,7 +48,7 @@ struct pvr2_v4l2_dev {
>  
>  struct pvr2_v4l2_fh {
>  	struct pvr2_channel channel;
> -	struct pvr2_v4l2_dev *dev_info;
> +	struct pvr2_v4l2_dev *pdi;
>  	enum v4l2_priority prio;
>  	struct pvr2_ioread *rhp;
>  	struct file *file;
> @@ -161,7 +161,7 @@ static long pvr2_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  {
>  	struct pvr2_v4l2_fh *fh = file->private_data;
>  	struct pvr2_v4l2 *vp = fh->vhead;
> -	struct pvr2_v4l2_dev *dev_info = fh->dev_info;
> +	struct pvr2_v4l2_dev *pdi = fh->pdi;
>  	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
>  	long ret = -EINVAL;
>  
> @@ -563,14 +563,14 @@ static long pvr2_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  
>  	case VIDIOC_STREAMON:
>  	{
> -		if (!fh->dev_info->stream) {
> +		if (!fh->pdi->stream) {
>  			/* No stream defined for this node.  This means
>  			   that we're not currently allowed to stream from
>  			   this node. */
>  			ret = -EPERM;
>  			break;
>  		}
> -		ret = pvr2_hdw_set_stream_type(hdw,dev_info->config);
> +		ret = pvr2_hdw_set_stream_type(hdw,pdi->config);
>  		if (ret < 0) return ret;
>  		ret = pvr2_hdw_set_streaming(hdw,!0);
>  		break;
> @@ -578,7 +578,7 @@ static long pvr2_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  
>  	case VIDIOC_STREAMOFF:
>  	{
> -		if (!fh->dev_info->stream) {
> +		if (!fh->pdi->stream) {
>  			/* No stream defined for this node.  This means
>  			   that we're not currently allowed to stream from
>  			   this node. */
> @@ -1031,7 +1031,7 @@ static int pvr2_v4l2_open(struct file *file)
>  	}
>  
>  	init_waitqueue_head(&fhp->wait_data);
> -	fhp->dev_info = dip;
> +	fhp->pdi = dip;
>  
>  	pvr2_trace(PVR2_TRACE_STRUCT,"Creating pvr_v4l2_fh id=%p",fhp);
>  	pvr2_channel_init(&fhp->channel,vp->channel.mc_head);
> @@ -1112,7 +1112,7 @@ static int pvr2_v4l2_iosetup(struct pvr2_v4l2_fh *fh)
>  	struct pvr2_hdw *hdw;
>  	if (fh->rhp) return 0;
>  
> -	if (!fh->dev_info->stream) {
> +	if (!fh->pdi->stream) {
>  		/* No stream defined for this node.  This means that we're
>  		   not currently allowed to stream from this node. */
>  		return -EPERM;
> @@ -1121,21 +1121,21 @@ static int pvr2_v4l2_iosetup(struct pvr2_v4l2_fh *fh)
>  	/* First read() attempt.  Try to claim the stream and start
>  	   it... */
>  	if ((ret = pvr2_channel_claim_stream(&fh->channel,
> -					     fh->dev_info->stream)) != 0) {
> +					     fh->pdi->stream)) != 0) {
>  		/* Someone else must already have it */
>  		return ret;
>  	}
>  
> -	fh->rhp = pvr2_channel_create_mpeg_stream(fh->dev_info->stream);
> +	fh->rhp = pvr2_channel_create_mpeg_stream(fh->pdi->stream);
>  	if (!fh->rhp) {
>  		pvr2_channel_claim_stream(&fh->channel,NULL);
>  		return -ENOMEM;
>  	}
>  
>  	hdw = fh->channel.mc_head->hdw;
> -	sp = fh->dev_info->stream->stream;
> +	sp = fh->pdi->stream->stream;
>  	pvr2_stream_set_callback(sp,(pvr2_stream_callback)pvr2_v4l2_notify,fh);
> -	pvr2_hdw_set_stream_type(hdw,fh->dev_info->config);
> +	pvr2_hdw_set_stream_type(hdw,fh->pdi->config);
>  	if ((ret = pvr2_hdw_set_streaming(hdw,!0)) < 0) return ret;
>  	return pvr2_ioread_set_enabled(fh->rhp,!0);
>  }
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8

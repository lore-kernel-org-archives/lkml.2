Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934820Ab0KQMry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:47:54 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:56060 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933626Ab0KQMrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:47:53 -0500
X-Greylist: delayed 618 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Nov 2010 07:47:53 EST
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 1/1] videobuf: Initialize lists in videobuf_buffer.
Date: Wed, 17 Nov 2010 13:37:33 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r1; KDE/4.5.3; x86_64; ; )
Cc: Andrew Chew <AChew@nvidia.com>,
        "'Figo.zhang'" <zhangtianfei@leadcoretech.com>,
        "pawel@osciak.com" <pawel@osciak.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1289939083-27209-1-git-send-email-achew@nvidia.com> <643E69AA4436674C8F39DCC2C05F763816BB828A40@HQMAIL03.nvidia.com> <201011170811.06697.hverkuil@xs4all.nl>
In-Reply-To: <201011170811.06697.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011171337.35663.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Wednesday 17 November 2010 08:11:06 Hans Verkuil wrote:
> On Wednesday, November 17, 2010 02:38:09 Andrew Chew wrote:
> > > > diff --git a/drivers/media/video/videobuf-dma-contig.c
> > > 
> > > b/drivers/media/video/videobuf-dma-contig.c
> > > 
> > > > index c969111..f7e0f86 100644
> > > > --- a/drivers/media/video/videobuf-dma-contig.c
> > > > +++ b/drivers/media/video/videobuf-dma-contig.c
> > > > @@ -193,6 +193,8 @@ static struct videobuf_buffer
> > > 
> > > *__videobuf_alloc_vb(size_t size)
> > > 
> > > >   	if (vb) {
> > > >   	
> > > >   		mem = vb->priv = ((char *)vb) + size;
> > > >   		mem->magic = MAGIC_DC_MEM;
> > > > 
> > > > +		INIT_LIST_HEAD(&vb->stream);
> > > > +		INIT_LIST_HEAD(&vb->queue);
> > > 
> > > i think it no need to be init, it just a list-entry.
> > 
> > Okay, if that's really the case, then sh_mobile_ceu_camera.c,
> > pxa_camera.c, mx1_camera.c, mx2_camera.c, and omap1_camera.c needs to be
> > fixed to remove that WARN_ON(!list_empty(&vb->queue)); in their
> > videobuf_prepare() methods, because those WARN_ON's are assuming that
> > vb->queue is properly initialized as a list head.
> > 
> > Which will it be?
> 
> These list entries need to be inited. It is bad form to have uninitialized
> list entries. It is not as if this is a big deal to initialize them
> properly.

I disagree with that. List heads must be initialized, but there's no point in 
initializing list entries.

-- 
Regards,

Laurent Pinchart

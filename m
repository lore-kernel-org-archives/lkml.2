Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab2IYLsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:48:42 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:44389 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab2IYLsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:48:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Prabhakar <prabhakar.csengg@gmail.com>, LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        VGER <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] media: davinci: vpif: set device capabilities
Date: Tue, 25 Sep 2012 13:49:16 +0200
Message-ID: <2015356.T8yoHfqqkq@avalon>
User-Agent: KMail/4.9.1 (Linux/3.4.9-gentoo; KDE/4.9.1; x86_64; ; )
In-Reply-To: <201209251343.36240.hansverk@cisco.com>
References: <1348571784-4237-1-git-send-email-prabhakar.lad@ti.com> <201209251343.36240.hansverk@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Tuesday 25 September 2012 13:43:36 Hans Verkuil wrote:
> On Tue 25 September 2012 13:16:24 Prabhakar wrote:
> > From: Lad, Prabhakar <prabhakar.lad@ti.com>
> > 
> > Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > Cc: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> > 
> >  drivers/media/platform/davinci/vpif_capture.c |    4 +++-
> >  drivers/media/platform/davinci/vpif_display.c |    4 +++-
> >  2 files changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/platform/davinci/vpif_capture.c
> > b/drivers/media/platform/davinci/vpif_capture.c index 4828888..faeca98
> > 100644
> > --- a/drivers/media/platform/davinci/vpif_capture.c
> > +++ b/drivers/media/platform/davinci/vpif_capture.c
> > @@ -1630,7 +1630,9 @@ static int vpif_querycap(struct file *file, void 
> > *priv,> 
> >  {
> >  
> >  	struct vpif_capture_config *config = vpif_dev->platform_data;
> > 
> > -	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> > +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
> > +			V4L2_CAP_READWRITE;
> > +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> > 
> >  	strlcpy(cap->driver, "vpif capture", sizeof(cap->driver));
> 
> This should be the real driver name which is 'vpif_capture'.
> 
> >  	strlcpy(cap->bus_info, "VPIF Platform", sizeof(cap->bus_info));
> 
> For bus_info I would use: "platform:vpif_capture".
> 
> The 'platform:' prefix is going to be the standard for platform drivers.

What about

snprintf(cap->driver, sizeof(cap->driver), "platform:%s", dev_name(vpif_dev));

That would handle cases where multiple platform devices of the same type are 
present.

> >  	strlcpy(cap->card, config->card_name, sizeof(cap->card));
> > 
> > diff --git a/drivers/media/platform/davinci/vpif_display.c
> > b/drivers/media/platform/davinci/vpif_display.c index d94b8a2..171e449
> > 100644
> > --- a/drivers/media/platform/davinci/vpif_display.c
> > +++ b/drivers/media/platform/davinci/vpif_display.c
> > @@ -827,7 +827,9 @@ static int vpif_querycap(struct file *file, void 
> > *priv,> 
> >  {
> >  
> >  	struct vpif_display_config *config = vpif_dev->platform_data;
> > 
> > -	cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
> > +	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING |
> > +			    V4L2_CAP_READWRITE;
> > +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> > 
> >  	strlcpy(cap->driver, "vpif display", sizeof(cap->driver));
> 
> vpif_driver
> 
> >  	strlcpy(cap->bus_info, "Platform", sizeof(cap->bus_info));
> 
> Ditto: "platform:vpif_driver".
> 
> >  	strlcpy(cap->card, config->card_name, sizeof(cap->card));

-- 
Regards,

Laurent Pinchart


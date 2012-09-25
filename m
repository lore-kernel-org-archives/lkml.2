Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab2IYNtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:49:36 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:59156 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502Ab2IYNtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:49:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        VGER <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] media: davinci: vpif: set device capabilities
Date: Tue, 25 Sep 2012 15:50:10 +0200
Message-ID: <25447484.hfLC5SnrpW@avalon>
User-Agent: KMail/4.9.1 (Linux/3.4.9-gentoo; KDE/4.9.1; x86_64; ; )
In-Reply-To: <201209251548.10830.hansverk@cisco.com>
References: <1348571784-4237-1-git-send-email-prabhakar.lad@ti.com> <CA+V-a8uLTmCSzY7xtp_TpAcmt=w5hMEWEpk24py1OD9qxOtYbw@mail.gmail.com> <201209251548.10830.hansverk@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 September 2012 15:48:10 Hans Verkuil wrote:
> On Tue 25 September 2012 15:26:11 Prabhakar Lad wrote:
> > On Tue, Sep 25, 2012 at 5:24 PM, Hans Verkuil <hansverk@cisco.com> wrote:
> > > On Tue 25 September 2012 13:49:16 Laurent Pinchart wrote:
> > >> Hi Hans,
> > >> 
> > >> On Tuesday 25 September 2012 13:43:36 Hans Verkuil wrote:
> > >> > On Tue 25 September 2012 13:16:24 Prabhakar wrote:
> > >> > > From: Lad, Prabhakar <prabhakar.lad@ti.com>
> > >> > > 
> > >> > > Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> > >> > > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > >> > > Cc: Hans Verkuil <hans.verkuil@cisco.com>
> > >> > > ---
> > >> > > 
> > >> > >  drivers/media/platform/davinci/vpif_capture.c |    4 +++-
> > >> > >  drivers/media/platform/davinci/vpif_display.c |    4 +++-
> > >> > >  2 files changed, 6 insertions(+), 2 deletions(-)
> > >> > > 
> > >> > > diff --git a/drivers/media/platform/davinci/vpif_capture.c
> > >> > > b/drivers/media/platform/davinci/vpif_capture.c index
> > >> > > 4828888..faeca98
> > >> > > 100644
> > >> > > --- a/drivers/media/platform/davinci/vpif_capture.c
> > >> > > +++ b/drivers/media/platform/davinci/vpif_capture.c
> > >> > > @@ -1630,7 +1630,9 @@ static int vpif_querycap(struct file *file,
> > >> > > void
> > >> > > *priv,>
> > >> > > 
> > >> > >  {
> > >> > >  
> > >> > >   struct vpif_capture_config *config = vpif_dev->platform_data;
> > >> > > 
> > >> > > - cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> > >> > > + cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
> > >> > > +                 V4L2_CAP_READWRITE;
> > >> > > + cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> > >> > > 
> > >> > >   strlcpy(cap->driver, "vpif capture", sizeof(cap->driver));
> > >> > 
> > >> > This should be the real driver name which is 'vpif_capture'.
> > >> > 
> > >> > >   strlcpy(cap->bus_info, "VPIF Platform", sizeof(cap->bus_info));
> > >> > 
> > >> > For bus_info I would use: "platform:vpif_capture".
> > >> > 
> > >> > The 'platform:' prefix is going to be the standard for platform
> > >> > drivers.
> > >> 
> > >> What about
> > >> 
> > >> snprintf(cap->driver, sizeof(cap->driver), "platform:%s",
> > >> dev_name(vpif_dev));
> > >> 
> > >> That would handle cases where multiple platform devices of the same
> > >> type are present.
> > > 
> > > Sure, that's even better. You do have to check that this gives you what
> > > you'd expect (i.e., that you don't end up with
> > > "platform:platform:vpif_capture").> 
> > But the driver field is max 16, should i extend it to 32 ?
> 
> I'm certain Laurent meant to say:
> 
> snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> dev_name(vpif_dev));

Yes that's what I meant, sorry.

> It makes no sense to use cap->driver.

-- 
Regards,

Laurent Pinchart


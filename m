Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab2L1AQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 19:16:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab2L1AQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 19:16:19 -0500
Date: Thu, 27 Dec 2012 21:49:37 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: Re: [PATCH 01/23] uvc: Replace memcpy with struct assignment
Message-ID: <20121227214937.6276e2a3@redhat.com>
In-Reply-To: <CALF0-+VQKxu7_-=aJeW-FxmM4fdVX1nBE7AA5-0d9SRgRqqM1g@mail.gmail.com>
References: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
	<CALF0-+VQKxu7_-=aJeW-FxmM4fdVX1nBE7AA5-0d9SRgRqqM1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 27 Dec 2012 18:12:46 -0300
Ezequiel Garcia <elezegarcia@gmail.com> escreveu:

> Mauro,
> 
> On Tue, Oct 23, 2012 at 4:57 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> > This kind of memcpy() is error-prone. Its replacement with a struct
> > assignment is prefered because it's type-safe and much easier to read.
> >
> > Found by coccinelle. Hand patched and reviewed.
> > Tested by compilation only.
> >
> > A simplified version of the semantic match that finds this problem is as
> > follows: (http://coccinelle.lip6.fr/)
> >
> > // <smpl>
> > @@
> > identifier struct_name;
> > struct struct_name to;
> > struct struct_name from;
> > expression E;
> > @@
> > -memcpy(&(to), &(from), E);
> > +to = from;
> > // </smpl>
> >
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> > Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> > ---
> >  drivers/media/usb/uvc/uvc_v4l2.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
> > index f00db30..4fc8737 100644
> > --- a/drivers/media/usb/uvc/uvc_v4l2.c
> > +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> > @@ -314,7 +314,7 @@ static int uvc_v4l2_set_format(struct uvc_streaming *stream,
> >                 goto done;
> >         }
> >
> > -       memcpy(&stream->ctrl, &probe, sizeof probe);
> > +       stream->ctrl = probe;
> >         stream->cur_format = format;
> >         stream->cur_frame = frame;
> >
> > @@ -386,7 +386,7 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming *stream,
> >                 return -EBUSY;
> >         }
> >
> > -       memcpy(&probe, &stream->ctrl, sizeof probe);
> > +       probe = stream->ctrl;
> >         probe.dwFrameInterval =
> >                 uvc_try_frame_interval(stream->cur_frame, interval);
> >
> > @@ -397,7 +397,7 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming *stream,
> >                 return ret;
> >         }
> >
> > -       memcpy(&stream->ctrl, &probe, sizeof probe);
> > +       stream->ctrl = probe;
> >         mutex_unlock(&stream->mutex);
> >
> >         /* Return the actual frame period. */
> > --
> > 1.7.4.4
> >
> 
> It seems you've marked this one as "Changes requested" [1].
> However, Laurent didn't request any change,
> but just pointed out we missed one memcpy replacement candidate.
> 
> I believe it's safe to apply the patch (together with the other 20 patches)
> and we can fix the missing spot in another patch.

The other patches got applied already. Well just do whatever Laurent asked you
and re-submit this one ;)

Regards,
Mauro

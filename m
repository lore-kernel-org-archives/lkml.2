Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab2K1Tz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:55:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab2K1Tz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:55:56 -0500
Date: Wed, 28 Nov 2012 17:55:44 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/23] media: Replace memcpy with struct assignment
Message-ID: <20121128175544.4266260d@redhat.com>
In-Reply-To: <CALF0-+USC6ButEO0pMRPFj8hGtL90wi3FrxL-BkE1oF42qcggg@mail.gmail.com>
References: <CALF0-+XH4AfJUcNHXdMTwXf-=f24Zpe3VOw_1eQ9WBV1-6ZVjQ@mail.gmail.com>
	<CALF0-+USC6ButEO0pMRPFj8hGtL90wi3FrxL-BkE1oF42qcggg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 28 Nov 2012 16:06:31 -0300
Ezequiel Garcia <elezegarcia@gmail.com> escreveu:

> On Tue, Oct 23, 2012 at 4:57 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> > Hello everyone,
> >
> > This is a large patchset that replaces struct memcpy with struct assignment,
> > whenever possible at drivers/media.
> >
> > The patches are hand applied and every change has been thoroughly reviewed.
> > However, to avoid regressions and angry users we'd like to have Acks
> > from maintainers.
> >
> > A simplified version of the semantic match that finds
> > this problem is as follows: (http://coccinelle.lip6.fr/)
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
> > If you're thinking this change is very minor and doesn't worh the pain,
> > you might change your opinion reading this report from Dan Carpenter:
> >
> > http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/49553
> >
> > The report clearly shows how copy-paste programming paradigm, combined with
> > lack of memcpy type-safety can lead to very strange code.
> >
> > Not to mention, using struct assignment instead of memcpy
> > is by far more readable.
> >
> > Comments, feedback and flames are welcome. Thanks!
> >
> > Peter Senna Tschudin, Ezequiel Garcia (23):
> >  wl128x: Replace memcpy with struct assignment
> >  radio-wl1273: Replace memcpy with struct assignment
> >  dvb-frontends: Replace memcpy with struct assignment
> >  dvb-core: Replace memcpy with struct assignment
> >  bttv: Replace memcpy with struct assignment
> >  cx18: Replace memcpy with struct assignment
> >  cx23885: Replace memcpy with struct assignment
> >  cx88: Replace memcpy with struct assignment
> >  ivtv: Replace memcpy with struct assignment
> >  tuners/tda18271: Replace memcpy with struct assignment
> >  tuners/xc2028: Replace memcpy with struct assignment
> >  tuners/xc4000: Replace memcpy with struct assignment
> >  au0828: Replace memcpy with struct assignment
> >  dvb-usb/friio-fe: Replace memcpy with struct assignment
> >  zr36067: Replace memcpy with struct assignment
> >  cx25840: Replace memcpy with struct assignment
> >  hdpvr: Replace memcpy with struct assignment
> >  pvrusb2: Replace memcpy with struct assignment
> >  pwc: Replace memcpy with struct assignment
> >  sn9c102: Replace memcpy with struct assignment
> >  usbvision: Replace memcpy with struct assignment
> >  cx231xx: Replace memcpy with struct assignment
> >  uvc: Replace memcpy with struct assignment
> >
> >  drivers/media/dvb-core/dvb_frontend.c        |    2 +-
> >  drivers/media/dvb-frontends/cx24116.c        |    2 +-
> >  drivers/media/dvb-frontends/drxd_hard.c      |    5 ++---
> >  drivers/media/dvb-frontends/stv0299.c        |    2 +-
> >  drivers/media/i2c/cx25840/cx25840-ir.c       |    6 ++----
> >  drivers/media/pci/bt8xx/bttv-i2c.c           |    3 +--
> >  drivers/media/pci/cx18/cx18-i2c.c            |    6 ++----
> >  drivers/media/pci/cx23885/cx23885-video.c    |    3 +--
> >  drivers/media/pci/cx23885/cx23888-ir.c       |    6 ++----
> >  drivers/media/pci/cx88/cx88-cards.c          |    2 +-
> >  drivers/media/pci/cx88/cx88-i2c.c            |    3 +--
> >  drivers/media/pci/cx88/cx88-vp3054-i2c.c     |    3 +--
> >  drivers/media/pci/ivtv/ivtv-i2c.c            |   12 ++++--------
> >  drivers/media/pci/zoran/zoran_card.c         |    3 +--
> >  drivers/media/radio/radio-wl1273.c           |    3 +--
> >  drivers/media/radio/wl128x/fmdrv_common.c    |    3 +--
> >  drivers/media/tuners/tda18271-maps.c         |    6 ++----
> >  drivers/media/tuners/tuner-xc2028.c          |    2 +-
> >  drivers/media/tuners/xc4000.c                |    2 +-
> >  drivers/media/usb/au0828/au0828-cards.c      |    2 +-
> >  drivers/media/usb/au0828/au0828-i2c.c        |    9 +++------
> >  drivers/media/usb/cx231xx/cx231xx-cards.c    |    2 +-
> >  drivers/media/usb/cx231xx/cx231xx-video.c    |    3 +--
> >  drivers/media/usb/dvb-usb/friio-fe.c         |    5 ++---
> >  drivers/media/usb/hdpvr/hdpvr-i2c.c          |    3 +--
> >  drivers/media/usb/pvrusb2/pvrusb2-encoder.c  |    3 +--
> >  drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c |    4 ++--
> >  drivers/media/usb/pvrusb2/pvrusb2-v4l2.c     |    2 +-
> >  drivers/media/usb/pwc/pwc-if.c               |    2 +-
> >  drivers/media/usb/sn9c102/sn9c102_core.c     |    4 ++--
> >  drivers/media/usb/usbvision/usbvision-i2c.c  |    3 +--
> >  drivers/media/usb/uvc/uvc_v4l2.c             |    6 +++---
> >  32 files changed, 47 insertions(+), 75 deletions(-)
> >
> 
> Hi Mauro,
> 
> Given we're very near merge window, I'm wondering if you're
> considering picking this series.
> There's no rush, but if there's anything to review, please let me know.

Hi Ezequiel,

Thanks for your offering.

There are 400+ patches pending today at patchwork. I doubt I'll have enough
time for all of them, so, I'll skip cleanup patches like the above, in order
to try to focus on bug fixes and patches that brings new functionality to
existing code and with a low risk of breaking anything.

Next year, we'll start implementing the sub-maintainers, and, with their
help, I suspect we'll be able to finally apply those patches.

If you want us to help, feel free to review/test the individual patches
submitted by non-maintainers to the ML. We tend to apply faster patches
that are more reviewed. 

Hmm... well, actually it is just the opposite: we explicitly delay 
not-reviewed patches for unmaintained/bad maintained drivers,
to see if someone acks or nacks them after testing.

Regards,
Mauro

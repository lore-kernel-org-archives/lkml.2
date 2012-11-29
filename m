Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab2K2DIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 22:08:54 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45383 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab2K2DIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 22:08:52 -0500
MIME-Version: 1.0
In-Reply-To: <20121128173529.1a264c53@redhat.com>
References: <1354099329-20722-1-git-send-email-prabhakar.lad@ti.com>
 <1354099329-20722-10-git-send-email-prabhakar.lad@ti.com> <20121128092213.4bd0870f@redhat.com>
 <1555450.K4uAzFNhY7@avalon> <20121128173529.1a264c53@redhat.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 29 Nov 2012 08:38:30 +0530
Message-ID: <CA+V-a8sB7hcX2BEcdXnVm7s+P+9DoLm1wxUuAoGbchUooigLBw@mail.gmail.com>
Subject: Re: [PATCH v3 9/9] davinci: vpfe: Add documentation and TODO
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Thu, Nov 29, 2012 at 1:05 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Hi Laurent,
>
> Em Wed, 28 Nov 2012 14:00:14 +0100
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
>
>> Hi Mauro,
>>
>> Please see below.
>>
>> On Wednesday 28 November 2012 09:22:13 Mauro Carvalho Chehab wrote:
>> > Hi Prabhakar,
>> >
>> > Em Wed, 28 Nov 2012 16:12:09 +0530
>> >
>> > Prabhakar Lad <prabhakar.csengg@gmail.com> escreveu:
>> > > +Introduction
>> > > +============
>> > > +
>> > > + This file documents the Texas Instruments Davinci Video processing Front
>> > > + End (VPFE) driver located under drivers/media/platform/davinci. The
>> > > + original driver exists for Davinci VPFE, which is now being changed to
>> > > + Media Controller Framework.
>> >
>> > Hmm... please correct me if I'm wrong, but are you wanting to replace an
>> > existing driver at drivers/media/platform/davinci, by another one at
>> > staging that has lots of known issues, as pointed at your TODO????
>> >
>> > If so, please don't do that. Replacing a driver by some other one is
>> > generally a very bad idea, especially in this case, where the new driver
>> > has clearly several issues, the main one being to define its own proprietary
>> > and undocumented API:
>> >
>> > > +As of now since the interface will undergo few changes all the include
>> > > +files are present in staging itself, to build for dm365 follow below
>> > > +steps,
>> > > +
>> > > +- copy vpfe.h from drivers/staging/media/davinci_vpfe/ to
>> > > +  include/media/davinci/ folder for building the uImage.
>> > > +- copy davinci_vpfe_user.h from drivers/staging/media/davinci_vpfe/ to
>> > > +  include/uapi/linux/davinci_vpfe.h, and add a entry in Kbuild (required
>> > > +  for building application).
>> > > +- copy dm365_ipipeif_user.h from drivers/staging/media/davinci_vpfe/ to
>> > > +  include/uapi/linux/dm365_ipipeif.h and a entry in Kbuild (required
>> > > +  for building application).
>> >
>> > Among other things, with those ugly and very likely mandatory API calls:
>> >
>> > >+/*
>> > >+ * Private IOCTL
>> > >+ * VIDIOC_VPFE_IPIPEIF_S_CONFIG: Set IPIEIF configuration
>> > >+ * VIDIOC_VPFE_IPIPEIF_G_CONFIG: Get IPIEIF configuration
>> > >+ */
>> > >+#define VIDIOC_VPFE_IPIPEIF_S_CONFIG \
>> > >+  _IOWR('I', BASE_VIDIOC_PRIVATE + 1, struct ipipeif_params)
>> > >+#define VIDIOC_VPFE_IPIPEIF_G_CONFIG \
>> > >+  _IOWR('I', BASE_VIDIOC_PRIVATE + 2, struct ipipeif_params)
>> > >+
>> > >+#endif
>> >
>> > I remember we rejected already drivers like that with obscure "S_CONFIG"
>> > private ioctl that were suspect to send a big initialization undocumented
>> > blob to the driver, as only the vendor's application would be able to use
>> > such driver.
>>
>> That's correct, and that's why the driver is going to staging. From there it
>> will be incrementally fixed and then moved to drivers/media/, or dropped if
>> not maintained.
>>
>> > So, instead, of submitting it to staging, you should be sending incremental
>> > patches for the existing driver, adding newer functionality there, and
>> > using the proper V4L2 API, with makes life easier for reviewers and
>> > application developers.
>>
>> I agree that it would be the best thing to do, but I don't think it's going to
>> happen. We need to decide between two options.
>>
>> - Push back now and insist in incremental patches for the existing driver, and
>> get nothing back as TI will very likely give up completely.
>> - Accept the driver in staging, get it fixed incrementally, and finally move
>> it to drivers/media/
>>
>> There's a political side to this issue, we need to decide whether we want to
>> insist vendors getting everything right before any code reaches mainline, in
>> which case I believe we will lose some of them in the process, including major
>> vendors such as TI, or if we can make the mainline learning curve and
>> experience a bit more smooth by accepting such code in staging.
>>
>> I would vote for the second option, with a very clear rule that getting the
>> driver in staging is only one step in the journey: if the development effort
>> stops there, the driver *will* be removed.
>
> What concerns most is that we'll be adding yet-another-driver for the same
> hardware, but using a different API set (Media controller + subdevs, instead
> of pure V4L2).
>
> It should be noticed that even basic stuff seems to be missing at the driver,
> like proper locks[1].
>
> [1] I'm basing my comments only at this patchset's TODO list - I didn't
> reviewed the code, but it this is one of the listed items: "Check proper
> serialisation (through mutexes and spinlocks)"
>
This was just a quick TODO list provided by Sakari, These code was being
targeted for media folder itself and not staging. This code is well
tested on DM365
EVM. The TODO list might be looking long but trust me this would be
fixed up quickly.

> As no regressions are accepted, on non-staging drivers, the switch from the
> already working, stable one to the new one, when this driver reaches the
> required quality, will be a very hard task, as one would need to check the
> exact behavior of the existing driver, and check if the new driver will
> behave the same, in order to warrant that no regressions will be introduced.
>
> This doesn't sound something easy to do, especially if the implementation
> decisions taken on the second driver aren't based on the same way as the
> existing driver.
>
> The risk is that this driver would never be merged upstream, due to those
> conflicts, or that we'll take several years to solve it, before being
> able to warrant that userspace binaries developed for the first driver
> will work as-is with the new one.
>
This is pretty much similar as OMAP3isp driver. The current driver is based
on V4l2 lacking major features such as ipipe, and resizing. The new driver
which has being added uses the Media controller framewrok, uses videobuf2,
supports ipipe and resizing driver and obvious advantages  of media controller
framework. If driver with these new features and enhancement doesn't make into
just because taking into mind of the users of old driver.

This is something similar like you have videobuf and videobuf2. But
there were no
incremental patches for videobuf itself, but it was added new. But now
there is rule
for users writing a new driver should write using videobuf2 only, so
that slowly videobuf
phases of, Similarly the users will need to be encouraged to use the new drivers
with such a huge list of features in new driver and slowly phase of
the old driver.

Regards,
--Prabhakar Lad

> Regards,
> Mauro

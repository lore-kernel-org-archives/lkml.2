Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab0KRK0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 05:26:43 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:37608 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790Ab0KRK0l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 05:26:41 -0500
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "mchehab@infradead.org" <mchehab@infradead.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "Halli, Manjunatha" <manjunatha_halli@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Date: Thu, 18 Nov 2010 15:56:25 +0530
Subject: RE: [PATCH v4 0/6] FM V4L2 drivers for WL128x
Thread-Topic: [PATCH v4 0/6] FM V4L2 drivers for WL128x
Thread-Index: AcuG+6zK+ePVIcxPSbmlWMJ0viHjngAAiX4A
Message-ID: <19F8576C6E063C45BE387C64729E739404BC76239C@dbde02.ent.ti.com>
References: <1289913494-21590-1-git-send-email-manjunatha_halli@ti.com>
 <AANLkTi=ZT0E=A9ZYAM86qu4P8eStkF2PLep6-DofCX-s@mail.gmail.com>
 <AANLkTinyaZ07HBFNHNyR9eK6__QdZtG6O1gQX1F+YRB9@mail.gmail.com>
 <AANLkTimE13JNS2gPhCpdZZk0ANyTgfxeO75pABrKLQDR@mail.gmail.com>
In-Reply-To: <AANLkTimE13JNS2gPhCpdZZk0ANyTgfxeO75pABrKLQDR@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ohad,
 
> -----Original Message-----
> From: Ohad Ben-Cohen [mailto:ohad@wizery.com]
> Sent: Thursday, November 18, 2010 2:36 AM
> To: Savoy, Pavan
> Cc: mchehab@infradead.org; hverkuil@xs4all.nl; Halli, Manjunatha; linux-
> kernel@vger.kernel.org; linux-media@vger.kernel.org; Greg KH
> Subject: Re: [PATCH v4 0/6] FM V4L2 drivers for WL128x
> 
> Hi Pavan,
> 
> > On Wed, Nov 17, 2010 at 6:32 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> >>>  drivers/staging/ti-st/Kconfig        |   10 +
> >>>  drivers/staging/ti-st/Makefile       |    2 +
> >>>  drivers/staging/ti-st/fmdrv.h        |  259 ++++
> >>>  drivers/staging/ti-st/fmdrv_common.c | 2141
> ++++++++++++++++++++++++++++++++++
> >>>  drivers/staging/ti-st/fmdrv_common.h |  458 ++++++++
> >>>  drivers/staging/ti-st/fmdrv_rx.c     |  979 ++++++++++++++++
> >>>  drivers/staging/ti-st/fmdrv_rx.h     |   59 +
> >>>  drivers/staging/ti-st/fmdrv_tx.c     |  461 ++++++++
> >>>  drivers/staging/ti-st/fmdrv_tx.h     |   37 +
> >>>  drivers/staging/ti-st/fmdrv_v4l2.c   |  757 ++++++++++++
> >>>  drivers/staging/ti-st/fmdrv_v4l2.h   |   32 +
> >>>  11 files changed, 5195 insertions(+), 0 deletions(-)
> >>
> >> Usually when a driver is added to staging, it should also have a TODO
> >> file specifying what needs to be done before the driver can be taken
> >> out of staging (at least as far as the author knows of today).
> >>
> >> It helps keeping track of the open issues in the driver, which is good
> >> for everyone - the author, the random contributor/observer, and
> >> probably even the staging maintainer.
> >>
> >> Can you please add such a TODO file ?
> ...
> > Thanks Ohad, for the comments, We do have an internal TODO.
> > In terms of functionality we have stuff like TX RDS which already has
> > few CIDs in the extended controls.
> > extend V4L2 for complete-scan, add in stop search during hw_seek .. etc...
> 
> You need to understand and list the reasons why this driver cannot go
> directly to mainline; missing functionality is usually not the
> culprit.

I don't.
I always doubt I would get all the answers from the maintainers if I keep posting 10 files with 200 lines of code in each of them every time.

> > But I just wanted to ask whether this is good enough to be staged.
> > Because as we begin to implement and add in the items in TODO - the
> > patch set will keep continuing to grow.
> >
> > So Hans, Mauro, What do you think ?
> > It would be real helpful - if this can be staged, it is becoming
> > difficult to maintain for us.
> 
> Greg has mentioned that staging acceptance rules are:
> 
> 1. Code compiles
> 2. Is self sustained (does not touch code out of staging)
> 3. Has a clear roadmap out of staging (that TODO file)
> 4. Is maintained
> 
> But I really think you should always prefer to upstream your code
> directly to mainline. Submit the code, have it reviewed by the
> relevant maintainers and upstream developers, and fix it appropriately
> until it is accepted.

Yes, I would love to do that too, however this is the problem we have with
submission of functionally completed code.

> Only if you feel (/know) it would take substantial cleanup/redesign
> efforts until it is accepted upstream, then staging is indeed the way
> to go. But then you should know what gates it from upstream merger,
> and focus on that (rather than on adding functionality) until it is
> taken out of staging. IMHO adding functionality will just make it
> harder for you to take it out of staging eventually. Usually the
> opposite road is taken: first get a minimal driver accepted upstream,
> and then gradually add the missing functionality.

Yes, hence inputs from Hans, Mauro and you too are welcome in suggesting as
To whether it is good enough for staging, and once staged, you are also
Welcome to add on to list of TODOs which we will take care :)

Thanks,
Pavan

> Good luck,
> Ohad.

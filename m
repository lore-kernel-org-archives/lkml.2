Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab0KRIgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:36:18 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56812 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab0KRIgR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:36:17 -0500
MIME-Version: 1.0
X-Originating-IP: [109.186.75.6]
In-Reply-To: <AANLkTinyaZ07HBFNHNyR9eK6__QdZtG6O1gQX1F+YRB9@mail.gmail.com>
References: <1289913494-21590-1-git-send-email-manjunatha_halli@ti.com>
 <AANLkTi=ZT0E=A9ZYAM86qu4P8eStkF2PLep6-DofCX-s@mail.gmail.com> <AANLkTinyaZ07HBFNHNyR9eK6__QdZtG6O1gQX1F+YRB9@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 18 Nov 2010 10:35:56 +0200
Message-ID: <AANLkTimE13JNS2gPhCpdZZk0ANyTgfxeO75pABrKLQDR@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] FM V4L2 drivers for WL128x
To: Pavan Savoy <pavan_savoy@ti.com>
Cc: mchehab@infradead.org, hverkuil@xs4all.nl, manjunatha_halli@ti.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavan,

> On Wed, Nov 17, 2010 at 6:32 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>>>  drivers/staging/ti-st/Kconfig        |   10 +
>>>  drivers/staging/ti-st/Makefile       |    2 +
>>>  drivers/staging/ti-st/fmdrv.h        |  259 ++++
>>>  drivers/staging/ti-st/fmdrv_common.c | 2141 ++++++++++++++++++++++++++++++++++
>>>  drivers/staging/ti-st/fmdrv_common.h |  458 ++++++++
>>>  drivers/staging/ti-st/fmdrv_rx.c     |  979 ++++++++++++++++
>>>  drivers/staging/ti-st/fmdrv_rx.h     |   59 +
>>>  drivers/staging/ti-st/fmdrv_tx.c     |  461 ++++++++
>>>  drivers/staging/ti-st/fmdrv_tx.h     |   37 +
>>>  drivers/staging/ti-st/fmdrv_v4l2.c   |  757 ++++++++++++
>>>  drivers/staging/ti-st/fmdrv_v4l2.h   |   32 +
>>>  11 files changed, 5195 insertions(+), 0 deletions(-)
>>
>> Usually when a driver is added to staging, it should also have a TODO
>> file specifying what needs to be done before the driver can be taken
>> out of staging (at least as far as the author knows of today).
>>
>> It helps keeping track of the open issues in the driver, which is good
>> for everyone - the author, the random contributor/observer, and
>> probably even the staging maintainer.
>>
>> Can you please add such a TODO file ?
...
> Thanks Ohad, for the comments, We do have an internal TODO.
> In terms of functionality we have stuff like TX RDS which already has
> few CIDs in the extended controls.
> extend V4L2 for complete-scan, add in stop search during hw_seek .. etc...

You need to understand and list the reasons why this driver cannot go
directly to mainline; missing functionality is usually not the
culprit.

> But I just wanted to ask whether this is good enough to be staged.
> Because as we begin to implement and add in the items in TODO - the
> patch set will keep continuing to grow.
>
> So Hans, Mauro, What do you think ?
> It would be real helpful - if this can be staged, it is becoming
> difficult to maintain for us.

Greg has mentioned that staging acceptance rules are:

1. Code compiles
2. Is self sustained (does not touch code out of staging)
3. Has a clear roadmap out of staging (that TODO file)
4. Is maintained

But I really think you should always prefer to upstream your code
directly to mainline. Submit the code, have it reviewed by the
relevant maintainers and upstream developers, and fix it appropriately
until it is accepted.

Only if you feel (/know) it would take substantial cleanup/redesign
efforts until it is accepted upstream, then staging is indeed the way
to go. But then you should know what gates it from upstream merger,
and focus on that (rather than on adding functionality) until it is
taken out of staging. IMHO adding functionality will just make it
harder for you to take it out of staging eventually. Usually the
opposite road is taken: first get a minimal driver accepted upstream,
and then gradually add the missing functionality.

Good luck,
Ohad.

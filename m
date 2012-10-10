Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab2JJXFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:05:33 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:41299 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757656Ab2JJXF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:05:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rajagopal Venkat <rajagopal.venkat@linaro.org>
Cc: "mturquette@linaro.org" <mturquette@linaro.org>,
        =?utf-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] devfreq: Core updates to support devices which can idle
Date: Thu, 11 Oct 2012 01:09:03 +0200
Message-ID: <2265839.VVHHOmHKqu@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.0-2.10-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CA+Z25wUrcPB2Z-hHuNsVAP7z2UZ0mSXHtjkVZUyQGW31G+TA8Q@mail.gmail.com>
References: <22177995.704311349684048797.JavaMail.weblogic@epml02> <CA+Z25wUrcPB2Z-hHuNsVAP7z2UZ0mSXHtjkVZUyQGW31G+TA8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 of October 2012 12:49:33 Rajagopal Venkat wrote:
> On 8 October 2012 13:44, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
> >> Prepare devfreq core framework to support devices which
> >> can idle. When device idleness is detected perhaps through
> >> runtime-pm, need some mechanism to suspend devfreq load
> >> monitoring and resume back when device is online. Present
> >> code continues monitoring unless device is removed from
> >> devfreq core.
> >>
> >> This patch introduces following design changes,
> >>
> >> - use per device work instead of global work to monitor device
> >>   load. This enables suspend/resume of device devfreq and
> >>   reduces monitoring code complexity.
> >> - decouple delayed work based load monitoring logic from core
> >>   by introducing helpers functions to be used by governors. This
> >>   provides flexibility for governors either to use delayed work
> >>   based monitoring functions or to implement their own mechanism.
> >> - devfreq core interacts with governors via events to perform
> >>   specific actions. These events include start/stop devfreq.
> >>   This sets ground for adding suspend/resume events.
> >>
> >> The devfreq apis are not modified and are kept intact.
> >>
> >> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
> >
> > Thank you!
> >
> >
> > Reviewed and Tested (at Exynos4210-Nuri).
> >
> > Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> >
> 
> Rafael,
> 
> Can this patchset be queued for v3.7?

No, but it can be queued for v3.8.  I'll do that tomorrow, if time permits.

All non-fix things I'd had queued up for v3.7 were merged already.

Thanks,
Rafael


> >> ---
> >>  Documentation/ABI/testing/sysfs-class-devfreq |   8 -
> >>  drivers/devfreq/devfreq.c                     | 443 +++++++++++---------------
> >>  drivers/devfreq/governor.h                    |  11 +
> >>  drivers/devfreq/governor_performance.c        |  16 +-
> >>  drivers/devfreq/governor_powersave.c          |  16 +-
> >>  drivers/devfreq/governor_simpleondemand.c     |  24 ++
> >>  drivers/devfreq/governor_userspace.c          |  23 +-
> >>  include/linux/devfreq.h                       |  34 +-
> >>  8 files changed, 279 insertions(+), 296 deletions(-)
> >>
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

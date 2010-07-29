Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab0G2T4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 15:56:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757923Ab0G2T4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 15:56:22 -0400
Date: Thu, 29 Jul 2010 21:56:16 +0200
From: Karel Zak <kzak@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Milan Broz <mbroz@redhat.com>, util-linux-ng@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH] loop: add some basic read-only sysfs attributes
Message-ID: <20100729195616.GF1981@nb.net.home>
References: <20100722101541.GU15652@nb.net.home> <1280410435-7017-1-git-send-email-mbroz@redhat.com> <AANLkTikKAPToXUSecEThgXfufM73huircg2YB-UiG_ZY@mail.gmail.com> <4C518AC9.4040208@redhat.com> <AANLkTikseiXY0zZ7AsyJgUXrqWsbjCgHqCabeg_SdWzZ@mail.gmail.com> <20100729145827.GB1981@nb.net.home> <AANLkTinq4TUobEwnfpMFAkCugTokSZ-8KQ-ryuv6jXCc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinq4TUobEwnfpMFAkCugTokSZ-8KQ-ryuv6jXCc@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 06:07:31PM +0200, Kay Sievers wrote:
> On Thu, Jul 29, 2010 at 16:58, Karel Zak <kzak@redhat.com> wrote:
> > On Thu, Jul 29, 2010 at 04:22:50PM +0200, Kay Sievers wrote:
> >> On Thu, Jul 29, 2010 at 16:06, Milan Broz <mbroz@redhat.com> wrote:
> >> > On 07/29/2010 03:47 PM, Kay Sievers wrote:
> >> >> On Thu, Jul 29, 2010 at 15:33, Milan Broz <mbroz@redhat.com> wrote:
> >> >>> Create /sys/block/loopX/loop directory and provide these attributes:
> >> >>>  - backing_file
> >> >>>  - autoclear
> >> >>>  - offset
> >> >>>  - sizelimit
> >> >>>
> >> >>> To be used in util-linux-ng (and possibly elsewhere like udev rules)
> >> >>> where code need to get loop attributes from kernel (and not store
> >> >>> duplicate info in userspace).
> >> >>
> >> >> Isn't it that the loop attributes are created _after_ the loopdev is
> >> >> registered? That would make it hard to use these attributes from udev,
> >> >> as the event is already running while they are created.
> >> >
> >> > First 8 loop devices are registered always (without backing file),
> >> > so you have wait for change event initiated from fd set ioctl anyway...
> >> > (backing file attribute is empty in that case)
> >>
> >> Ah, so we are sure, we always get a 'change' event, and before that,
> >> none of these values are ever useful to read? I mean, there will not
> >> be attributes that are interesting during an 'add' event?
> >
> > I think the patch does not change the current behavior. It exports
> > details about loopdevs to userspace by /sys. This is the primary goal
> > of the patch.
> 
> Sure it does. Sysfs attributes need to be created _before_ uevents are
> sent out. The current behavior is that all blockdev attributes are
> safely created before the event is sent. These loop attributes are
> created _after_ the event is sent.
> 
> The question is if we can rely on the fact, that 'add' events never
> want to look at any of these attributes, and all can be deferred to

 I think we can rely on this fact, 'add' does not mean that the device
 is ready. BTW, why there is /sys/block/loopN at all if the device
 is not associated with any backing file?

 Note that /sys/block/loopN/ro is there for years and depends on
 backing file as well (so it's useless after "add").

> later 'change' events. If we can't be fully certain about this, this
> stuff must be changed to happen before the event for the blockdev is
> sent out.

 The primary goal is to use the attributes in mount(8) and losetup(8). I 
 have doubts that we will use it udev rules.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com

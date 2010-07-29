Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab0G2O60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 10:58:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757657Ab0G2O6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 10:58:25 -0400
Date: Thu, 29 Jul 2010 16:58:27 +0200
From: Karel Zak <kzak@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Milan Broz <mbroz@redhat.com>, util-linux-ng@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH] loop: add some basic read-only sysfs attributes
Message-ID: <20100729145827.GB1981@nb.net.home>
References: <20100722101541.GU15652@nb.net.home> <1280410435-7017-1-git-send-email-mbroz@redhat.com> <AANLkTikKAPToXUSecEThgXfufM73huircg2YB-UiG_ZY@mail.gmail.com> <4C518AC9.4040208@redhat.com> <AANLkTikseiXY0zZ7AsyJgUXrqWsbjCgHqCabeg_SdWzZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikseiXY0zZ7AsyJgUXrqWsbjCgHqCabeg_SdWzZ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 04:22:50PM +0200, Kay Sievers wrote:
> On Thu, Jul 29, 2010 at 16:06, Milan Broz <mbroz@redhat.com> wrote:
> > On 07/29/2010 03:47 PM, Kay Sievers wrote:
> >> On Thu, Jul 29, 2010 at 15:33, Milan Broz <mbroz@redhat.com> wrote:
> >>> Create /sys/block/loopX/loop directory and provide these attributes:
> >>>  - backing_file
> >>>  - autoclear
> >>>  - offset
> >>>  - sizelimit
> >>>
> >>> To be used in util-linux-ng (and possibly elsewhere like udev rules)
> >>> where code need to get loop attributes from kernel (and not store
> >>> duplicate info in userspace).
> >>
> >> Isn't it that the loop attributes are created _after_ the loopdev is
> >> registered? That would make it hard to use these attributes from udev,
> >> as the event is already running while they are created.
> >
> > First 8 loop devices are registered always (without backing file),
> > so you have wait for change event initiated from fd set ioctl anyway...
> > (backing file attribute is empty in that case)
> 
> Ah, so we are sure, we always get a 'change' event, and before that,
> none of these values are ever useful to read? I mean, there will not
> be attributes that are interesting during an 'add' event?

I think the patch does not change the current behavior. It exports
details about loopdevs to userspace by /sys. This is the primary goal
of the patch.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com

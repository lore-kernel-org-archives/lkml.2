Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab2HGOhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 10:37:05 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59301 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755143Ab2HGOhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 10:37:00 -0400
X-Sasl-enc: 8/m/Es5w1wf7x1cdhsqxPx2oDdbgNybKLhK6Ll84nh+r 1344350219
Date: Tue, 7 Aug 2012 11:36:56 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: Colin Cross <ccross@android.com>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org
Subject: Re: [PATCH] leds: triggers: send uevent when changing triggers
Message-ID: <20120807143656.GA22791@khazad-dum.debian.net>
References: <1343176370-5856-1-git-send-email-ccross@android.com>
 <CAK5ve-LY1iw7CanrMSZ0PtK=Fk9Au9tXnmaOuZ5P7vnP+5VAgA@mail.gmail.com>
 <CAMbhsRS-TiBE92nL0Cwc-ssZAMaHE2ET0UE8h7RU3VG6F6+Xtw@mail.gmail.com>
 <CAK5ve-+11J4HRepAmK-Y0Pq55XhAwa8Ehpw8=KvRdu4Cy90FDQ@mail.gmail.com>
 <20120726035958.GB7235@kroah.com>
 <CAK5ve-LbNeJngQPE=893-ChJXEWJHg9km1Ev6GZYx4=Zrrxg9g@mail.gmail.com>
 <20120726165112.GA23857@kroah.com>
 <CAK5ve-KFsFwnvd3TwAvTuBfEdTV8PeNBkVpdQT9NYXH2sN+mBA@mail.gmail.com>
 <CAMbhsRS82FM90sD52qTTdOFJCoR4GyP+v6bwv+4NKhjn-sqh-Q@mail.gmail.com>
 <CAK5ve-KvdokobzjmuXSsEZxrJcr7i4xHOXJGvMqCSOZ69G_5zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ve-KvdokobzjmuXSsEZxrJcr7i4xHOXJGvMqCSOZ69G_5zw@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2012, Bryan Wu wrote:
> On Wed, Aug 1, 2012 at 2:28 AM, Colin Cross <ccross@android.com> wrote:
> > On Thu, Jul 26, 2012 at 9:04 PM, Bryan Wu <bryan.wu@canonical.com> wrote:
> >> On Fri, Jul 27, 2012 at 12:51 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >>> On Thu, Jul 26, 2012 at 01:03:11PM +0800, Bryan Wu wrote:
> >>>> Just one quick patch for my idea: emitting a uevent in sysfs_create_file().
> >>>>
> >>>> --
> >>>> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> >>>> index 00012e3..04da869 100644
> >>>> --- a/fs/sysfs/file.c
> >>>> +++ b/fs/sysfs/file.c
> >>>> @@ -570,10 +570,14 @@ int sysfs_add_file(struct sysfs_dirent *dir_sd,
> >>>> const struct attribute *attr,
> >>>>
> >>>>  int sysfs_create_file(struct kobject * kobj, const struct attribute * attr)
> >>>>  {
> >>>> +       int err = 0;
> >>>> +
> >>>>         BUG_ON(!kobj || !kobj->sd || !attr);
> >>>>
> >>>> -       return sysfs_add_file(kobj->sd, attr, SYSFS_KOBJ_ATTR);
> >>>> +       err = sysfs_add_file(kobj->sd, attr, SYSFS_KOBJ_ATTR);
> >>>> +       kobject_uevent(kobj, KOBJ_CHANGE);
> >>>
> >>> That's a veritable flood of change events when a new kobject is created,
> >>> right?  It also created uevents for a device that has not told userspace
> >>> that it is even present, which could cause massive confusion, don't you
> >>> think?
> >>>
> >>
> >> Indeed, this is unacceptable. I reworked a new patchset and just sent
> >> our for you review.
> >>
> >> Thanks,
> >> -Bryan
> >
> > Given the rejection of the other solutions to this problem, and chance
> > of getting this acked?
> 
> Greg, Richard and Henrique, can I take you guys' Ack here?

Yes, you have my Acked-by, provided that the uevent is NOT sent before
the led is fully registered (I cannot check right now if the patch does
this right or not.  I apologise in advance if this was an unecessary
question).

I don't care whether the uevent gets sent right after registration, or
only when the trigger *changes* after registering.  But someone might,
so it would be nice to document this.

Considering Greg's answer, maybe it would be best to resend the patch
with the point above clarified in the commit message or in the in-tree
documentation of the LED class?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

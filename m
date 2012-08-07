Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab2HGDeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:34:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44542 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224Ab2HGDeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:34:19 -0400
Date: Mon, 6 Aug 2012 20:34:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org
Subject: Re: [PATCH] leds: triggers: send uevent when changing triggers
Message-ID: <20120807033413.GA2261@kroah.com>
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
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 10:57:29AM +0800, Bryan Wu wrote:
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

Ack for what specific patch are you referring to?

greg k-h

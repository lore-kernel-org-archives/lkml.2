Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053Ab2GZEAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 00:00:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61823 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2GZEAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 00:00:01 -0400
Date: Wed, 25 Jul 2012 20:59:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org
Subject: Re: [PATCH] leds: triggers: send uevent when changing triggers
Message-ID: <20120726035958.GB7235@kroah.com>
References: <1343176370-5856-1-git-send-email-ccross@android.com>
 <CAK5ve-LY1iw7CanrMSZ0PtK=Fk9Au9tXnmaOuZ5P7vnP+5VAgA@mail.gmail.com>
 <CAMbhsRS-TiBE92nL0Cwc-ssZAMaHE2ET0UE8h7RU3VG6F6+Xtw@mail.gmail.com>
 <CAK5ve-+11J4HRepAmK-Y0Pq55XhAwa8Ehpw8=KvRdu4Cy90FDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ve-+11J4HRepAmK-Y0Pq55XhAwa8Ehpw8=KvRdu4Cy90FDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 11:29:48AM +0800, Bryan Wu wrote:
> On Thu, Jul 26, 2012 at 2:54 AM, Colin Cross <ccross@android.com> wrote:
> > On Tue, Jul 24, 2012 at 11:11 PM, Bryan Wu <bryan.wu@canonical.com> wrote:
> >> On Wed, Jul 25, 2012 at 8:32 AM, Colin Cross <ccross@android.com> wrote:
> >>> Some triggers create sysfs files when they are enabled.  Send a uevent
> >>> "change" notification whenever the trigger is changed to allow userspace
> >>> processes such as udev to modify permissions on the new files.
> >>>
> >>
> >> This looks like an workaround only for led trigger, can we fix this in
> >> sysfs level?
> >
> > See the previous discussion here: https://lkml.org/lkml/2012/7/20/458
> 
> Thanks, I went through this thread here. Actually it was archived in
> my email account, so I missed that during a trip.
> 
> Basically, I think this issue is a kind of general issue related to
> sysfs, not just only for led trigger system. And adding this uevent
> notification to a upper level LED driver is not good to me, if we got
> similar issue in other subsystem, we should add similar fix there. Why
> not we add this in sysfs when we call device_create_file(). And this
> will be benefit for other drivers.
> 
> Please point out me why we can't do that in sysfs level. Thanks.

Please point out to me how you _can_ do this at a sysfs level :)

greg k-h

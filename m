Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab0IKTHM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 15:07:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45449 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab0IKTHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 15:07:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "M. Vefa Bicakci" <bicave@superonline.com>
Subject: Re: PATCH: PM / Hibernate: Avoid hitting OOM during preallocationof memory
Date: Sat, 11 Sep 2010 21:06:07 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Minchan Kim <minchan.kim@gmail.com>
References: <201009062043.37819.rjw@sisk.pl> <201009082334.01255.rjw@sisk.pl> <4C8BC68B.8050002@superonline.com>
In-Reply-To: <4C8BC68B.8050002@superonline.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009112106.07687.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 11, 2010, M. Vefa Bicakci wrote:
> Hello,
> 
> Sorry for the late reply. I have been busy the past few days.
> 
> On 08/09/10 05:34 PM, Rafael J. Wysocki wrote:
> > On Wednesday, September 08, 2010, M. Vefa Bicakci wrote:
> >> [snip]
> >>
> >> I should note a few things though,
> >>
> >> 1) I don't think I ever changed /sys/power/image_size, so we can rule out the
> >> possibility of that option changing the results.
> > 
> > Can you please check what value is there in this file?
> 
> It contains 524288000, so I think it is set to 500 MB. I believe that this is
> the default value, but I am not sure.

Yes, this is the (hard coded) default, which very likely is to small for your system.

> >> 2) With the patch below, for the *first* hibernation operation, the computer
> >> enters a "thoughtful" state without any disk activity for 6-8 (maybe 10)
> >> seconds after printing "Preallocating image memory". It works properly after
> >> the wait however.
> > 
> > That probably is a result of spending time in the memory allocator trying to
> > reduce the size of the image as much as possible.
> 
> I am not sure if this is a new thing with the new patch, but the behavior
> seems to continue with the later hibernation operations too, not just the
> first one. I haven't confirmed if I really didn't realize the problem in
> the previous version of the patch, but it is very possible that I didn't
> realize it since I used to automate my tests. (I didn't automate my tests
> this time.)
> 
> However, considering that the kernel needs to worry about compacting 1500 MB
> of data when hibernating with my tmpfs-is-full system, I guess these wait
> times are normal, even though a bit inconvenient.
> 
> >> [snip]
> > 
> >> 4) I made sure that I was not being impatient with the previous snapshot.c
> >> patch, so I tested that on its own once again, and I confirmed that hibernation
> >> hangs with the older version of the snapshot.c patch.
> >>
> >> I am very happy that we are getting closer to a solution. Please let me know
> >> if there is anything I need to test further.
> > 
> > Below is the patch I'd like to apply.  It should work just like the previous
> > one (there are a few fixes that shouldn't affect the functionality in it), but
> > please test it if you can.
> 
> I am happy to report that it works properly by only itself when applied to
> a clean 2.6.35.4 tree. I haven't had any problems (aside from the "thoughtful
> state" issue I mentioned above) with my 6 consecutive hibernation attempts.

Great, thanks a lot for your excellent feedback!

> > I think the slowdown you saw in 2) may be eliminated by increasing the
> > image_size value, so I'm going to prepare a patch that will compute the
> > value automatically during boot so that it's approximately 50% of RAM.
> 
> I would be glad to test that patch as well, to see if it brings speed-ups.
> Actually, I might test hibernation with a larger value written to
> /sys/power/image_size when I have time.

I think that would improve things, as it probably is impossible to reduce the
image size to 500 MB on your system.

Anyway, I'll let you know when the patch is ready.

Thanks,
Rafael

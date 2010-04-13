Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab0DMQR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 12:17:26 -0400
Received: from mail.cs.nmsu.edu ([128.123.64.3]:61502 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158Ab0DMQRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 12:17:24 -0400
X-Greylist: delayed 1616 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Apr 2010 12:17:24 EDT
Message-ID: <9b5c58f1d71657dd8edc853df319b840.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <45a44e481003021611g8572667yd5c135f3b3927fb3@mail.gmail.com>
References: <201002252215.o1PMFnoP011425@mustang.cs.nmsu.edu>
    <45a44e481002251830j710e87bah52486a489eef04cb@mail.gmail.com>
    <0b055dc4810836e24ff21a776504142b.squirrel@intranet.cs.nmsu.edu>
    <45a44e481003012249p6970d442o593af7d4971f0183@mail.gmail.com>
    <84774cde4a948cb726db3bfcb463a04c.squirrel@intranet.cs.nmsu.edu>
    <45a44e481003021611g8572667yd5c135f3b3927fb3@mail.gmail.com>
Date: Tue, 13 Apr 2010 09:50:20 -0600
Subject: Re: [PATCH] Add sysfs support for fbdefio delay
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org, jkosina@suse.cz,
       bonbons@linux-vserver.org
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jaya Kumar wrote:
> On Tue, Mar 2, 2010 at 11:36 PM, Rick L. Vinyard, Jr.
> <rvinyard@cs.nmsu.edu> wrote:
>>
>> Jaya Kumar wrote:
>>> On Tue, Mar 2, 2010 at 12:10 AM, Rick L. Vinyard, Jr.
>>> <rvinyard@cs.nmsu.edu> wrote:
>>>> Jaya Kumar wrote:
>>>
>>> Being concerned about CPU utilization is a good thing. But say for
>>> example, your USB ethernet driver or USB audio driver is taking a lot
>>> of cpu time packetizing traffic, then would I be correct that your
>>> desire is to expose an inter-packetization driver specific sleep time
>>> controllable by userspace via sysfs for all ethernet, audio, etc
>>> drivers? (by driver specific, I mean the sysfs parameter would be
>>> presented by all drivers but the value would be specific to each one,
>>> which is the way your current patch would behave for all fb drivers).
>>>
>>
>> I think the answer is yes, whether this were a fb, network, audio, etc.
>> If
>> there is a clearly defined parameter at which resource utilization can
>> be
>> adjusted in a standard way.
>
> Hi Rick,
>
> Sure, we can find these driver resource utilization choke points, and
> maybe even make it sort of standard, but that does not mean that we
> should expose all of this to userspace. Adding more userspace tunables
> for each driver in order to effect fb, network, audio bus utilization,
> is not appealing. So I think we disagree about the fundamentals.
>
> My conclusion is: I'm opposed this patch, because it exposes the defio
> delay parameter for _all_ fb drivers, _each_ through a
> /sys/class/graphics/fb_driver_name/defio_delay sysfs entry and also
> adds a min/max issue. The behaviour and system impact seen by
> userspace when changing the parameter is not standard across the
> typical range of systems and devices. More importantly, exposing each
> driver's defio delay to userspace is not a good way to address the 2
> underlying functional goals that were raised during this discussion:
> 1) being able to control a driver's bus/cpu utilization, and 2)
> allowing certain plugins/etc to be able to increase display update
> frequency for subregions of the display.
>
> Just to be verbose, please don't let my rejection of this specific
> patch affect your other patches as I see those as being very useful
> and close to being suitable for merging.
>

No problem. I understand the desire to be conservative.




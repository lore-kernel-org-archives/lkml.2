Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab0CROej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:34:39 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:2944 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab0CROeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:34:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Q3FLw9VuysI/Pvcr8SVdwW0kiGx3KLNv5ecCZSBZUprjAv9E3uVlJpotiU5sTyMPEF
         LYC8zzFPT4tOtWml91g6HJlDa3cpzCoElHfX+HsSFuUlZpum5twR6ggUoTzBn9pcH3fF
         kV6GtiSJTn78R1jFuChV9qdo6rZh0HX+3Hoi4=
MIME-Version: 1.0
In-Reply-To: <20100307204213.GB17727@core.coreip.homeip.net>
References: <4B8C1867.7040201@cam.ac.uk>
	 <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
	 <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>
	 <20100303184132.GA11471@core.coreip.homeip.net>
	 <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>
	 <20100303190753.GB11471@core.coreip.homeip.net>
	 <404ea8001003031338j34847961jd8a7114bbc45603a@mail.gmail.com>
	 <alpine.LFD.2.00.1003031348510.3599@localhost.localdomain>
	 <20100307204213.GB17727@core.coreip.homeip.net>
Date: Thu, 18 Mar 2010 10:34:35 -0400
Message-ID: <9e4733911003180734q1783b108o1bfd994bb0fadd7c@mail.gmail.com>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
From: Jon Smirl <jonsmirl@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dima Zavin <dmitriyz@google.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 7, 2010 at 4:42 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wed, Mar 03, 2010 at 01:51:07PM -0800, Linus Torvalds wrote:
>>
>>
>> On Wed, 3 Mar 2010, Dima Zavin wrote:
>> >
>> > Actually, accelerometers fit into that model fine. They have some
>> > variable number of absolute axes (3, 6, etc.).
>>
>> In fact, they obviouslya also do end up being used exactly like joysticks
>> in real life, and joysticks are commonly starting to have accelerometers
>> in them (ie any modern game console controller).
>>
>> So treating an accelerometer like a joystick - regardless of whether it
>> happens to be internal to the device or happens to be external in a
>> separate controller - is not all that far-fetched anyway.
>>
>
> But the point is that not every accelerometer is a joystick. We have
> hdaps and friends that have accelerometers inside but that is not their
> main purpose (they do export a secondary joystick-like interface and
> that is fine), and I am pretty sure that there are other users of
> accelerometers in various systems.
>
> I am pretty sure that once we settle on the proper interface for such
> sensors we should be able to write a bridge to input layer so they can
> be easily used as [human] input devices in cases whether it is desired.
>

Sorry for the late reply, but this is a recurring theme. Remote
controls (IR and radio) have the same problem and this was the core of
my objection to their drivers being merged.  Input devices need to
communicate their human oriented events to user space using the input
subsystem period. If you don't do this things like the xserver/apps
have to implement custom drivers for every new user event interface
that is dreamed up and that destroys backwards compatibility.

Drivers can always be split into two modules. A core module could
provide a sysfs or kernel internal interface. An add-on module can
optionally redirect events from the core module into the input
subsystem.

I'm also not a fan of having a custom interface on the sensor/input
devices that reports device specific events to user space. Then those
events are massaged by a tiny user space app and reinjected into the
input subsystem. That does work but it leads to the kernel requiring
external apps in order to function. I believe converting device
specific events to a common device protocol is the work of the device
driver.

-- 
Jon Smirl
jonsmirl@gmail.com

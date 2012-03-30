Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934532Ab2C3Rig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 13:38:36 -0400
Received: from mail-vx0-f194.google.com ([209.85.220.194]:47197 "EHLO
	mail-vx0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab2C3Ric convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 13:38:32 -0400
MIME-Version: 1.0
In-Reply-To: <CACSP8SjhOZcXZa2hCNsH8zS+hm8X-i9uNm50UH=_VwOV=BJGmA@mail.gmail.com>
References: <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
	<1330344939-18394-1-git-send-email-myungjoo.ham@samsung.com>
	<1330344939-18394-2-git-send-email-myungjoo.ham@samsung.com>
	<20120309124119.GV3273@opensource.wolfsonmicro.com>
	<CACSP8ShU5tu=9N53PtYMLyFVFMS9whNRhMvu7nu8rBoPuVCy+Q@mail.gmail.com>
	<20120330100742.GB21950@opensource.wolfsonmicro.com>
	<CACSP8SjhOZcXZa2hCNsH8zS+hm8X-i9uNm50UH=_VwOV=BJGmA@mail.gmail.com>
Date: Fri, 30 Mar 2012 10:38:30 -0700
X-Google-Sender-Auth: 5pDhigSEKp7jVWFa895-MwByTz8
Message-ID: <CAPz4a6C9J+7pSHsCabdtF8pXgx7msFDjYNBi2KviHuSShXWuZQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] Extcon (external connector): import Android's
 switch class and modify.
From: Dima Zavin <dima@android.com>
To: Erik Gilling <konkers@google.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        NeilBrown <neilb@suse.de>, gregkh@linuxfoundation.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnevag?= <arve@android.com>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        myungjoo.ham@gmail.com, John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Joerg Roedel <joerg.roedel@amd.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mike Lockwood <lockwood@android.com>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 10:29 AM, Erik Gilling <konkers@google.com> wrote:
> On Fri, Mar 30, 2012 at 3:07 AM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
>> On Thu, Mar 29, 2012 at 03:27:01PM -0700, Erik Gilling wrote:
>>> On Fri, Mar 9, 2012 at 4:41 AM, Mark Brown
>>
>>> > This seems somewhat sad - if ANDROID is turned on the standard ABI
>>> > vanishes.  It'd be much nicer to do this with a symlink (or with
>>> > symlinks within the android directory if the driver core doesn't support
>>> > that).  That way userspace code can be written to the new ABI and will
>>> > work on Android systems without ifdefery.
>>
>>> This won't work if userspace code is receiving uevents through netlink
>>> and comparing based on the device name which it does in android.  Why
>>
>> That's not really the point here - the point is that the new ABI
>> vanishes as soon as you turn on the legacy Android ABI.  You're right
>> that the particular fix I suggested has issues but the overall problem
>> exists and should be dealt with more sensibly.
>
> I'm also not in favor of having functionality conditionally compiled
> based on CONFIG_ANDROID.  If fact, going through the patch stack
> there's much more that changes the ABI from the switch driver than
> just the name.  Android asumes that there is a single "switch" for
> each logical entity (called cable types in extcon) each with a binary
> state (0,1).  Here things have changed to have a single extcon
> instance that can have a bitmask of states which are sent as strings
> in the uevent.

In addition to all this added complexity, the fact that you now have
to white-list the possible "cable types" is also undesirable. If I
wanted to expose a new cable type, I now have to modify the extcon.h
file and the extcon.c file and I don't see what that white-list buys
me. The class device itself should not care for which cable types can
be registered, nor how they relate to each other. Let the client
drivers decide, just enforce uniqueness.

--Dima

>
> As it stands, this patch does not solve the cases where we use switch
> today and we'll probably continue to carry the switch driver in the
> common android tree.  If, instead, we got rid of the idea of multiple
> states and mutual exclusivity and relied on the driver that uses
> extcon to have multiple instances for each logical entity and deal
> with mutual exclusion itself, we'd have a driver that would be pretty
> easy to support in android.
>
> -Erik

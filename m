Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab0LGMuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 07:50:16 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57943 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab0LGMuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 07:50:12 -0500
MIME-Version: 1.0
In-Reply-To: <201012071340.26244.arnd@arndb.de>
References: <1291706726-8835-1-git-send-email-rydberg@euromail.se>
 <20101207091653.GA22416@core.coreip.homeip.net> <AANLkTimnSsfCG0WtDpa-qEu3N1uMOeo+CzzZ8wsaZN1v@mail.gmail.com>
 <201012071340.26244.arnd@arndb.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 7 Dec 2010 13:49:56 +0100
Message-ID: <AANLkTikEpBS5zmmJaYoqmjFSwsdZd66N+yBs=RpRuk-J@mail.gmail.com>
Subject: Re: [RFC][PATCH] input: Introduce device information ioctl
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 7, 2010 at 13:40, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 07 December 2010, Kay Sievers wrote:
>> On Tue, Dec 7, 2010 at 10:16, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
>> > Hi Henrik,
>> >
>> > On Tue, Dec 07, 2010 at 08:25:26AM +0100, Henrik Rydberg wrote:
>> >> Today, userspace sets up an input device based on the data it emits.
>> >> This is not always enough; a tablet and a touchscreen may emit exactly
>> >> the same data, for instance, but the former should be set up with a
>> >> pointer whereas the latter does not need to. Recently, a new type of
>> >> touchpad has emerged where the buttons are under the pad, which changes
>> >> handling logic without changing the emitted data. This patch introduces
>> >> a new ioctl, EVIOCGDEVINFO, which allows userspace to extract information
>> >> about the device resulting in proper setup.
>> >
>> > If we agree that the new ioctl is suitable we'llalso need to wireit up
>> > through sysfs. Also, can we keep all definitions to INPUT_ namespace?
>>
>> Please don't add new ioctls which are not extensible. The ioctl should
>> carry the length or the version of the structure it asks for, so it
>> can be extended in the future. Sysfs should be good enough for such
>> interface though.
>
> Please never add any ioctls that have a version or length field!
>
> Ideally ioctls should have only scalar arguments, not structures,
> so I'd recommend splitting it into two, so you can read type and
> capability parameters separately.

Please don't add new ioctls with a single value only. :) That's what
sysfs is for, today.

The problem is that sysfs or ioctls with a single value can not handle
atomic queries of multiple values, and (rightfully) needing that in
some cases is a reason to add an ioctl() instead of sysfs.

Kay

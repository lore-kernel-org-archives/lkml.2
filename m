Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab1IUPNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:13:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64944 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab1IUPNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:13:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAHR064jz9MZTusgAx9gV5cjG=p00xvcNvDqw9KvdUASOT=p45g@mail.gmail.com>
References: <1316555754-25949-1-git-send-email-seth.forshee@canonical.com>
	<1316555754-25949-2-git-send-email-seth.forshee@canonical.com>
	<CAHR064iA1877cF1rmUhX_41U_yjRGs6siswpoMPjs=WEYEm8cQ@mail.gmail.com>
	<20110921132412.GB23254@thinkpad-t410>
	<CAHR064jz9MZTusgAx9gV5cjG=p00xvcNvDqw9KvdUASOT=p45g@mail.gmail.com>
Date: Wed, 21 Sep 2011 09:13:00 -0600
Message-ID: <CAGdLNWHDrLp6Ehshfg8gg3=b7WszyVBx4FtRZxiGB_KKh=zU2w@mail.gmail.com>
Subject: Re: [PATCH 1/6] toshiba_acpi: Convert to use acpi_driver
From: Azael Avalos <coproscefalo@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 7:30 AM, Corentin Chary
<corentin.chary@gmail.com> wrote:
> On Wed, Sep 21, 2011 at 3:24 PM, Seth Forshee
> <seth.forshee@canonical.com> wrote:
>> On Wed, Sep 21, 2011 at 09:28:30AM +0200, Corentin Chary wrote:
>>> On Tue, Sep 20, 2011 at 11:55 PM, Seth Forshee
>>> <seth.forshee@canonical.com> wrote:
>>> > Changes toshiba_acpi to register an acpi driver and eliminates the
>>> > platform device it was using.
>>>
>>> Why to you want to remove the platform device ? If you want to create
>>> a sysfs interface later, you'll probably need it. Most of the platform
>>> driver I know only use the acpi_device to send proc/netlink events and
>>> the platform_device is used everywhere else. (And anyway, it's an x86
>>> *platform* driver, not a pure acpi driver).
>>
>> I removed the platform device because it seems a bit redundant to have
>> both, and I don't see what benefit it really provides. I see your point
>> that conceptually it makes sense to have it has a platform device,
>> although the distinction there is pretty fine.
>>
>> Anyway, I guess the cost of keeping the platform device in place is
>> pretty small, so I can add it back in if that's desirable.
>
> I don't have a strong opinion, so do what you want (or what Matthew
> will tell you to), but keeping it would allow easier access to
> subdevices (/sys/platform/devices is a better place than
> /sys/bus/acpi/devices/ for this kind of device in my opinion).
>
>>> > Also eliminates most global
>>> > variables, moving them into toshiba_acpi_dev, along with some
>>> > other miscellaneous fixes and cleanup.
>>>
>>> Good ! Next step would be to deprecate the /proc interface (keeping it
>>> for compatibility) and adding a new shinny
>>> /sys/platform/device/toshiba-acpi/ interface correctly documented in
>>> Documentation/ABI/ :).
>>
>> I was avoiding chainging any userspace interfaces in this first round of
>> patches, but deprecating the proc interface is definitely something I'd
>> like to do. I don't know if there's any point to moving it to sysfs
>> though. Most of it already has sysfs interfaces via device classes, and
>> I don't know that there's any value in the rest of it.
>
> Well, I must admit that I didn't check that, and it's possible that
> all you need to do is to deprecate all /proc file if none of them are
> actually usefull.

They were useful, however, the new TOS1900 devices don't support any
of the calls /proc stuff is doing (fan, video, lcd, etc.), and so it seems
to be the new Toshiba standard, as I haven't seen any GHCI device
in a while ('tho I might be wrong...)

>
>> Thanks,
>> Seth
>>
>
>
>
> --
> Corentin Chary
> http://xf.iksaif.net
>



-- 
-- El mundo apesta y vosotros apestais tambien --

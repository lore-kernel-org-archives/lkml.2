Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab2AIHea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:34:30 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47381 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab2AIHe2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:34:28 -0500
MIME-Version: 1.0
In-Reply-To: <1326092955.24116.131.camel@linux-s257.site>
References: <CAHR064jAJkQCd_Tsrx7NHe_RbaBbNcX4sMwy=zkZCZNUNo=fAw@mail.gmail.com>
	<1326092955.24116.131.camel@linux-s257.site>
Date: Mon, 9 Jan 2012 08:34:26 +0100
Message-ID: <CAHR064juCt90x_4bqSE2FqRxO+4759Sh4_L54eKopP_UJpap9Q@mail.gmail.com>
Subject: Re: Handling special keys in platform drivers
From: Corentin Chary <corentin.chary@gmail.com>
To: joeyli <jlee@suse.com>
Cc: platform-driver-x86@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, linux-input@vger.kernel.org,
        GLin@suse.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 8:09 AM, joeyli <jlee@suse.com> wrote:
> Hi Corentin,
>
> 於 一，2012-01-09 於 07:24 +0100，Corentin Chary 提到：
>> Hi,
>>
>> Some of the platform drivers in platform/x86/ (and probably other) are
>> relaying keys to userspace and are also controlling the device
>> associated to these key. A simple example is screen brightness,
>> keyboard backlight or rfkill.
>>
>> In this case the driver send a key to userspace, userspace has to
>> handle this key and control the right device.
>>
>> Most of the time, this job is done by:
>> - ACPI scripts (legacy)
>> - DE (gnome-power-manager, kde's solid)
>>
>> The real problem is that for keyboard backlight to work, it needs DE
>> cooperation, and only gnome as implemented that right now, and other
>> (except KDE) will probably neither have the resources to handle all
>> the possible keys correctly. And of course, who should handle the keys
>> when there is no DE running at all ?
>>
>> So I was wondering if we could introduce an "auto" mode for this
>> drivers. For example, with this mode enabled, asus-wmi would filter
>> the keys and control keyboard backlight directly (and rfkill/screen
>> brightness ?).
>>
>> What do you think about it ?
>>
>> Thanks,
>>
>
> For backlight,
> I think control backlight in platform driver is generally no problem,
> but need careful don't keep/change brightness level if BIOS also keep a
> variable reflect to brightness level.

Hum, for screen brightness, try to start without any desktop
environment on a laptop where the keys don't control the BIOS and only
send input events, and you won't be able to change the screen
brightness.

This is actually worse for keyboard backlight since only gnome support it.

> Another question is when the "auto" mode disable? Does it possible
> disable it from user space?

Probably only a module parameter. And disabled by default.

> Currently, like rfkill-input can disabled by ioctl from user space, e.g.
> urfkill daemon will disable rfkill-input by ioctl when it launched.
>
>
> For rfkill,
> I am not prefer allow platform driver direct control rfkill.

Yeah rfkill was just an example, of such interaction, but your right
rfkill support is currently pretty good.

> that might more complex because already have the follow components
> involve to it when function key pressed:
>        BIOS/EC (ODM backup behavior)
>        rfkill-input
>        wireless/bluetooth drivers
>        user space daemon/applications (e.g. NetworkManager, urfkill...)
>
> Then, will platform driver also involve to rfkill control?
>
> We already have rfkill-input in kernel to control rfkill state, if need
> more flexible policy control on rfkill key, put policy logic in user
> space will be better.
> e.g. User can setup rfkill policy by account.



-- 
Corentin Chary
http://xf.iksaif.net

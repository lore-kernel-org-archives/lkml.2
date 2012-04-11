Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab2DKR6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 13:58:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61455 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747Ab2DKR6x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 13:58:53 -0400
MIME-Version: 1.0
In-Reply-To: <20120411162519.GA27562@core.coreip.homeip.net>
References: <1334061766-20577-1-git-send-email-tom_lin@emc.com.tw>
	<20120411071212.GB6894@core.coreip.homeip.net>
	<4F85583F.6050008@emc.com.tw>
	<20120411162519.GA27562@core.coreip.homeip.net>
Date: Wed, 11 Apr 2012 10:58:52 -0700
Message-ID: <CAF8JNhLft4_z5kcnakq-oAg4USc1UKvY3RYOmnjnFLxA+inKJg@mail.gmail.com>
Subject: Re: [PATCH v3] Input: Elan HID-I2C device driver
From: Ping Cheng <pinglinux@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: =?Big5?B?qkyr26b2?= <tom_lin@emc.com.tw>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, djkurtz@chromium.org,
        Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 9:25 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wednesday, April 11, 2012 06:09:03 PM ªL«Û¦ö wrote:
>> Hi Daniel
>>
>> On 04/11/2012 03:12 PM, Dmitry Torokhov wrote:
>> > Hi Tom,
>> >
>> > On Tue, Apr 10, 2012 at 08:42:46PM +0800, Tom Lin wrote:
>> >> This patch adds driver for Elan I2C touchpad. These protocol of HID-I2C
>> >> was
>> >> defined by Microsoft. The kernel driver would use the multi-touch
>> >> protocol
>> >> format B.
>> >
>> > If this device truly supports HID protocol shouldn't we define i2c-hid
>> > transport, similar to usbhid?
>>
>> I merely follow defined by Microsoft.
>> It was called "HID OVER I2C" by Microsoft.
>> (http://msdn.microsoft.com/en-us/library/windows/hardware/hh825917(v=vs.85).
>> aspx) But I agree to change from hid i2c to i2chid.
>> Do you have any better opinions?
>
> I am not sure we are talking about same thing... I do not really care
> whether it is named "hid i2c" or "i2chid". What I meant if the device
> really speaks HID protocol, except that the transport is not USB or
> bluetooth but I2C, then instead of writing a custom driver for this
> particular part we need to add a new HID transport into
> drivers/hid/i2c-hid that is similar to drivers/hid/usbhid/

I fully agree with Dmitry's suggestion. The new i2chid driver would
cover all hid-compliant i2c devices.

Ping

> and reuse the rest of HID framework along with hid- multitouch.c which handles
> HID-compliant multitouch devices.
>
> I am CCing Jiri (HID maintainer) for additional input.
>
> Thanks.
>
> --
> Dmitry

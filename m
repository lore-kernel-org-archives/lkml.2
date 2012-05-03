Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab2ECOEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:04:39 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47750 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755730Ab2ECOEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:04:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120503135452.GA12050@polaris.bitmath.org>
References: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
	<alpine.LNX.2.00.1205011300540.1856@pobox.suse.cz>
	<CAN+gG=GGVFDgf_PkovS+_OX26LH0Q19_FwwkGP2pSwnoX4d_Ug@mail.gmail.com>
	<alpine.LNX.2.00.1205021044240.14613@pobox.suse.cz>
	<CAN+gG=HHxzYPSD+1i5JS8HmkxusHi=e6im48VzXHy2KsFoce+w@mail.gmail.com>
	<CAN+gG=HDZJf+73SoddWar_pRPH2NvFrvpVuAaRC8_frXmGQYfA@mail.gmail.com>
	<20120503122359.GA11552@polaris.bitmath.org>
	<CAN+gG=GS_aQ35ekF71oCjZXquB4X3xJvzq2_fT2d7nM+iBK=Zg@mail.gmail.com>
	<20120503131904.GA11741@polaris.bitmath.org>
	<CAN+gG=GU8NGJ70Yx8_roeA4LCohcmym7wEspbv4d_xMqbrP5hw@mail.gmail.com>
	<20120503135452.GA12050@polaris.bitmath.org>
Date: Thu, 3 May 2012 16:04:37 +0200
Message-ID: <CAN+gG=F3c-hUqzyOv7DEkWYBN6=mATVMGSKOr-MrWvid8mc-hA@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] hid: Introduce device groups
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephane Chatty <chatty@enac.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 3:54 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> >> > 2) Add the interface type to the group descision, which should
>> >> > probably be done anyway. I have a patch in the pipe that, will send it
>> >> > later today.
>> >>
>> >> A simpler solution consists in adding the macros HID_USB_MT_DEVICE(v,
>> >> p) and HID_BLUETOOTH_MT_DEVICE(v, p) as you had introduced in a
>> >> earlier patch (I don't know why it disappeared).
>> >
>> > No, the specific entries in the hid-multitouch device list matches any
>> > group, so those defines were simplified away in the second version.
>>
>> disagree: a device can present several interface (because it has
>> several "devices") and only those presenting Contact ID can and should
>> be handled by hid-multitouch.
>
> Obviously this is only a problem for the devices with mixed
> interfaces, but for those, solution 2) together with specifying the
> group as you suggest should work. We can definitely change all devices
> in the list, it just was not necessary before (or so I thought).
>
>> The think is that they do match hid-generic (they get the group
>> HID_GROUP_GENERIC).
>> However they also match hid-multitouch (as hid-multitouch does not ask
>> for a particular group). So, if hid-multitouch is loaded __before__
>> hid-generic, it will be given the device whatever the match with
>> hid-generic.
>
> I suppose what you describe here is how it was working before the
> device groups.

Just to be clear: no, this last paragraph occurs after device groups.
Before, it was working as hid-generic catch the device first, then
released it while looking at the report descriptors. Now, it's purely
dependent on which driver is loaded first for this particaular case.

Benjamin

> Ok, I see what to do now. I will be back shortly with a
> patch which should make USB_DEVICE_ID_TOPSEED2_PERIPAD_701 work, and
> let's take it from there.
>
> Thanks for testing,
> Henrik

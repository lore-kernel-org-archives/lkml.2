Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab1D0CzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 22:55:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35533 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab1D0CzY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 22:55:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WzC63er0EoNd2cfRKmSMK1ysqBV/H/4TxLIo1YGwKAj8nwzD8eg7bAmG7PNaKjXPIL
         rEhRjprpyuVMZbhgfrzTyWFUv9+sHvUxh/o8q5nK72rcy0AlxBWQ8ArYpDjd02vS+aeG
         GaEvFflUQCzkAEwaSA/zaPI6RQUueSWNkfgbc=
MIME-Version: 1.0
In-Reply-To: <201104240952.14848.edt@aei.ca>
References: <BANLkTi=Ei91GRcL2oP0G16LDy7mpLoDEGQ@mail.gmail.com>
	<BANLkTi=-RnUyuC2VGuRix_J4KOx+9BhroQ@mail.gmail.com>
	<BANLkTik67uGB-1q17JcTPnr_WjuNd_37gA@mail.gmail.com>
	<201104240952.14848.edt@aei.ca>
Date: Wed, 27 Apr 2011 10:55:22 +0800
Message-ID: <BANLkTim-49ZdSLnyjs_kjLxuvyCe=oUdGA@mail.gmail.com>
Subject: Re: [BUG] bluetooth doesn't work from 2.6.39-rc1+ to 2.6.39-rc3+
From: Dave Young <hidave.darkstar@gmail.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: Hui Zhu <teawater@gmail.com>, linux-kernel@vger.kernel.org,
        Bluettooth Linux <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 24, 2011 at 9:52 PM, Ed Tomlinson <edt@aei.ca> wrote:
> On Tuesday 19 April 2011 11:34:30 Hui Zhu wrote:
>> Do you part is OK?
>>
>> I think it will be very easy to reproduce.
>>
>> Thanks,
>> Hui
>>
>> On Tue, Apr 19, 2011 at 15:46, Dave Young <hidave.darkstar@gmail.com> wrote:
>> > On Tue, Apr 19, 2011 at 10:53 AM, Hui Zhu <teawater@gmail.com> wrote:
>> >> Cannot connect to any outside devices through bluetooth.
>> >>
>> >> And I think this is not a bug of low level driver.  Because both my
>> >> laptop and a usb bluetooth card cannot work.
>> >
>> > Hi, please explain the "cannot work" in detail,
>> > Firstly check dmesg and hciconfig to see if there's anything wrong.
>
> I am also seeing problems with bluetooth in .39-rc4+
>
> [54511.033258] usb 2-4.4: USB disconnect, device number 5
> [54513.920060] usb 2-4.3: new full speed USB device number 6 using ehci_hcd
> [54514.063057] usb 2-4.3: New USB device found, idVendor=0a12, idProduct=0001
> [54514.070281] usb 2-4.3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> grover ~ # hciconfig -a
> hci0:   Type: BR/EDR  Bus: USB
>        BD Address: 00:0A:3A:55:07:5A  ACL MTU: 192:8  SCO MTU: 64:8
>        DOWN
>        RX bytes:718 acl:0 sco:0 events:25 errors:0
>        TX bytes:108 acl:0 sco:0 commands:24 errors:0
>        Features: 0xff 0xff 0x0f 0x00 0x00 0x00 0x00 0x00
>        Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3
>        Link policy: CONFIG_BT_HCIBTUSB=m
>        Link mode: SLAVE ACCEPT
>
> grover ~ # hciconfig hci0 up
> Can't init device hci0: Invalid argument (22)
>
> The same error happens If I just try a hciconfig hci0 up after boot (without replugging the adaptor).

I did not see your problem, my usb dongle usbid is 0a12:0001 as well,
maybe bisect is the way to go.

>
> CONFIG_BT_HCIBTSDIO=m
> CONFIG_BT_HCIUART=m
> CONFIG_BT_HCIUART_H4=y
> CONFIG_BT_HCIUART_BCSP=y
> # CONFIG_BT_HCIUART_ATH3K is not set
> CONFIG_BT_HCIUART_LL=y
> CONFIG_BT_HCIBCM203X=m
> CONFIG_BT_HCIBPA10X=m
> CONFIG_BT_HCIBFUSB=m
> CONFIG_BT_HCIVHCI=m
>
> and bluez-4.91 is installed
>
> Ideas?
> Ed Tomlinson
>



-- 
Regards
dave

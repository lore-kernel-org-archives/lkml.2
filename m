Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab0CaTwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 15:52:33 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:42357 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab0CaTwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 15:52:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=QqZQewf+fdbjOeA7v59/fcP81O5N+3fJ2fs+/fUBxX09pC6F93cjjBJBfd2uXPuFrq
         J9k+U8xCyn8lWSIEgkFN/gu91I1KGpahu6zRUJKuflz8BmyEfr9ri1I5GhA+RgPgvCib
         AtnpzTcwI/qM1RO2lehdN065E0xTt8vpHBcJY=
MIME-Version: 1.0
In-Reply-To: <201003310125.26266.laurent.pinchart@ideasonboard.com>
References: <45cc95261003301455u10e6ee24pfb66176bfb279d1@mail.gmail.com> 
	<201003310125.26266.laurent.pinchart@ideasonboard.com>
From: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Date: Wed, 31 Mar 2010 21:51:59 +0200
Message-ID: <v2x45cc95261003311251idfdc9b8anb7b2060618611d30@mail.gmail.com>
Subject: Re: webcam problem after suspend/hibernate
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Do you mean the dmesg output ?
A full dmesg is included in this address :
http://pastebin.com/8XU619Uk
Not in all suspend/hibernate the problem comes, only in some of them
and this included dmesg output is just after a non working case of
webcam fault.


I also have found this in `/var/log/messages | grep uvcvideo`
Mar 31 00:31:16 linux-l365 kernel: [399905.714743] usbcore:
deregistering interface driver uvcvideo
Mar 31 00:31:24 linux-l365 kernel: [399914.121386] uvcvideo: Found UVC
1.00 device LG Webcam (0c45:62c0)
Mar 31 00:31:24 linux-l365 kernel: [399914.135661] usbcore: registered
new interface driver uvcvideo

and in `cat /proc/modules | grep uvcvideo`
uvcvideo 65900 0 - Live 0xfa386000
videodev 39168 1 uvcvideo, Live 0xf8244000
v4l1_compat 16004 2 uvcvideo,videodev, Live 0xf822f000


And thanks in advance for you help.



On Wed, Mar 31, 2010 at 1:25 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Mohamed,
>
> On Tuesday 30 March 2010 23:55:38 Mohamed Ikbel Boulabiar wrote:
>> Hi,
>>
>> After suspend/resume, I have my webcam no more working.
>> The /dev/video0 file still exist, but the webcam won't be used until I do
>> this : rmmod     uvcvideo
>> modprobe uvcvideo
>> (2.6.31.8-0.1)
>>
>> This is may be caused by a bug somewhere.
>> These are more information about my hardware :
>>
>> I have Microdia webcam
>> `lsusb`
>> Bus 001 Device 004: ID 0c45:62c0 Microdia Sonix USB 2.0 Camera
>>
>> on openSUSE 11.2 `uname -a`
>> Linux linux-l365 2.6.31.8-0.1-desktop #1 SMP PREEMPT 2009-12-15
>> 23:55:40 +0100 i686 i686 i386 GNU/Linux
>>
>> `hwinfo --usb`
>>
>> : USB 00.0: 0000 Unclassified device
>>
>>   [Created at usb.122]
>>   UDI:
>> /org/freedesktop/Hal/devices/usb_device_c45_62c0_1_3_2_1_7_if0_logicaldev_
>> input Unique ID: Uc5H.F0c0EBqBP10
>>   Parent ID: k4bc.9T1GDCLyFd9
>>   SysFS ID: /devices/pci0000:00/0000:00:1d.7/usb1/1-4/1-4:1.0
>>   SysFS BusID: 1-4:1.0
>>   Hardware Class: unknown
>>   Model: "Microdia LG Webcam"
>>   Hotplug: USB
>>   Vendor: usb 0x0c45 "Microdia"
>>   Device: usb 0x62c0 "LG Webcam"
>>   Revision: "32.17"
>>   Serial ID: "1.3.2.1.7"
>>   Driver: "uvcvideo"
>>   Driver Modules: "uvcvideo"
>>   Device File: /dev/input/event8
>>   Device Files: /dev/input/event8, /dev/char/13:72,
>> /dev/input/by-id/usb-LG_Innotek_LG_Webcam_1.3.2.1.7-event-if00,
>> /dev/input/by-path/pci-0000:00:1d.7-usb-0:4:1.0-event
>>   Device Number: char 13:72
>>   Speed: 480 Mbps
>>   Module Alias: "usb:v0C45p62C0d3217dcEFdsc02dp01ic0Eisc01ip00"
>>   Driver Info #0:
>>     Driver Status: uvcvideo is active
>>     Driver Activation Cmd: "modprobe uvcvideo"
>>   Config Status: cfg=no, avail=yes, need=no, active=unknown
>>   Attached to: #4 (Hub)
>>
>>
>> If there is a scenario you propose me to do to detect from where comes
>> the problem, I can apply it.
>
> Could you please post the messages printed by the uvcvideo driver and USB core
> to the kernel log when you suspend and resume your system ? Thanks.
>
> --
> Regards,
>
> Laurent Pinchart
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab1EBVTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:19:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34249 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab1EBVTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:19:24 -0400
Message-ID: <4DBF1FD6.1000809@sieker.io>
Date: Mon, 02 May 2011 23:19:18 +0200
From: "Adi J. Sieker" <adi@core.adi.io>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Neukum <oliver@neukum.org>, USB list <linux-usb@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: USB keyboard recognized as HID keyboard but doesn't work
References: <Pine.LNX.4.44L0.1105021657440.2106-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1105021657440.2106-100000@iolanthe.rowland.org>
Content-Type: multipart/mixed;
 boundary="------------090403040409000000030605"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090403040409000000030605
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 02/05/11 23:06, Alan Stern wrote:
> On Mon, 2 May 2011, Adi J. Sieker wrote:
>
>> Attached is the usbmon trace when I plug the keyboard in.
>>
>> lsusb shows the keyboard as:
>> Bus 002 Device 008: ID 060b:0230 Solid Year
>>
>> Relevant section from /sys/kernel/debug/usb/devices
>> T:  Bus=02 Lev=02 Prnt=02 Port=00 Cnt=01 Dev#=  8 Spd=1.5 MxCh= 0
>> D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
>> P:  Vendor=060b ProdID=0230 Rev= 2.20
>> S:  Manufacturer=KB
>> S:  Product=USB Keyboard
>> C:* #Ifs= 2 Cfg#= 1 Atr=a0 MxPwr=100mA
>> I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=01 Driver=usbhid
>> E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
>> I:* If#= 1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
>> E:  Ad=82(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
>
> Interestingly, the usbmon trace shows that the interrupt endpoint for
> interface 1 isn't being used by usbhid.  I don't know why, but it
> shouldn't make much difference for your purposes since that interface
> appears to be associated with the gaming interface.  But maybe I'm
> wrong and it is important somehow...
>
> The other noticeable thing is that the keyboard didn't accept the
> Set-Idle request for interface 1.
>
> You said before that the keyboard worked okay when driven by a guest
> Windows OS, right?  Can you collect an equivalent usbmon trace for
> that?  Comparing the two traces may be instructive.

I hope this is what you meant. :)
Attached is a usbmon trace when I attach the keyboard to a VBox VM 
running a Windows XP guest. I have no idea how to get a USB trace from 
within Windows. The last block is when I pressed h twice in the Windows 
XP guest.

Cheers
    Adi

--------------090403040409000000030605
Content-Type: text/plain;
 name="usbmon-guest.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="usbmon-guest.out"

e6283180 3528948156 S Ci:2:008:0 s 80 06 0100 0000 0012 18 <
e6283180 3528950914 C Ci:2:008:0 0 18 = 12011001 00000008 0b063002 20020102 0001
e6283180 3528950988 S Ci:2:008:0 s 80 06 0200 0000 0009 9 <
e6283180 3528953041 C Ci:2:008:0 0 9 = 09023b00 020100a0 32
e6283180 3528953062 S Ci:2:008:0 s 80 06 0200 0000 003b 59 <
e6283180 3528959915 C Ci:2:008:0 0 59 = 09023b00 020100a0 32090400 00010301 01000921 10010001 224b0007 05810308
ee1bd280 3528959982 C Ii:2:008:1 -108:8 0
f0267b00 3529284981 S Ci:2:008:0 s 80 06 0100 0000 0040 64 <
f0267b00 3529287920 C Ci:2:008:0 0 18 = 12011001 00000008 0b063002 20020102 0001
f0267b00 3529361757 S Ci:2:008:0 s 80 06 0100 0000 0012 18 <
f0267b00 3529364171 C Ci:2:008:0 0 18 = 12011001 00000008 0b063002 20020102 0001
f0267b00 3529365746 S Ci:2:008:0 s 80 06 0200 0000 0009 9 <
f0267b00 3529367546 C Ci:2:008:0 0 9 = 09023b00 020100a0 32
f0267b00 3529373770 S Ci:2:008:0 s 80 06 0200 0000 00ff 255 <
f0267b00 3529380045 C Ci:2:008:0 0 59 = 09023b00 020100a0 32090400 00010301 01000921 10010001 224b0007 05810308
f0267b00 3529383566 S Ci:2:008:0 s 80 06 0300 0000 00ff 255 <
f0267b00 3529384668 C Ci:2:008:0 0 4 = 04030904
f0267b00 3529387503 S Ci:2:008:0 s 80 06 0302 0409 00ff 255 <
f0267b00 3529390916 C Ci:2:008:0 0 26 = 1a035500 53004200 20004b00 65007900 62006f00 61007200 6400
f0267b00 3529394743 S Ci:2:008:0 s 80 06 0300 0000 00ff 255 <
f0267b00 3529395919 C Ci:2:008:0 0 4 = 04030904
f0267b00 3529398208 S Ci:2:008:0 s 80 06 0302 0409 00ff 255 <
f0267b00 3529401543 C Ci:2:008:0 0 26 = 1a035500 53004200 20004b00 65007900 62006f00 61007200 6400
f0267b00 3529423701 S Ci:2:008:0 s 80 06 0100 0000 0012 18 <
f0267b00 3529426169 C Ci:2:008:0 0 18 = 12011001 00000008 0b063002 20020102 0001
f0267b00 3529429749 S Ci:2:008:0 s 80 06 0200 0000 0009 9 <
f0267b00 3529431541 C Ci:2:008:0 0 9 = 09023b00 020100a0 32
f0267b00 3529437362 S Ci:2:008:0 s 80 06 0200 0000 003b 59 <
f0267b00 3529443919 C Ci:2:008:0 0 59 = 09023b00 020100a0 32090400 00010301 01000921 10010001 224b0007 05810308
f0267b00 3529481095 S Ci:2:008:0 s 80 06 0300 0000 00ff 255 <
f0267b00 3529482543 C Ci:2:008:0 0 4 = 04030904
f0267b00 3529485739 S Ci:2:008:0 s 80 06 0302 0409 00ff 255 <
f0267b00 3529489045 C Ci:2:008:0 0 26 = 1a035500 53004200 20004b00 65007900 62006f00 61007200 6400
f0267b00 3529491035 S Ci:2:008:0 s 80 06 0300 0000 00ff 255 <
f0267b00 3529492419 C Ci:2:008:0 0 4 = 04030904
f0267b00 3529494747 S Ci:2:008:0 s 80 06 0302 0409 00ff 255 <
f0267b00 3529498043 C Ci:2:008:0 0 26 = 1a035500 53004200 20004b00 65007900 62006f00 61007200 6400
f0267b00 3529644847 S Ci:2:008:0 s 80 06 0300 0000 00ff 255 <
f0267b00 3529646170 C Ci:2:008:0 0 4 = 04030904
f0267b00 3529649463 S Ci:2:008:0 s 80 06 0302 0409 00ff 255 <
f0267b00 3529652916 C Ci:2:008:0 0 26 = 1a035500 53004200 20004b00 65007900 62006f00 61007200 6400
f0267b00 3529654618 S Ci:2:008:0 s 80 06 0300 0000 00ff 255 <
f0267b00 3529655796 C Ci:2:008:0 0 4 = 04030904
f0267b00 3529657753 S Ci:2:008:0 s 80 06 0302 0409 00ff 255 <
f0267b00 3529661043 C Ci:2:008:0 0 26 = 1a035500 53004200 20004b00 65007900 62006f00 61007200 6400
f0267b00 3529664864 S Co:2:008:0 s 21 0a 0000 0000 0000 0
f0267b00 3529665920 C Co:2:008:0 0 0
f0267b00 3529666626 S Ci:2:008:0 s 81 06 2200 0000 008b 139 <
f0267b00 3529674418 C Ci:2:008:0 0 75 = 05010906 a1010507 19e029e7 15002501 75019508 81029501 75088101 95037501
f0267b00 3529693746 S Co:2:008:0 s 21 0a 0000 0001 0000 0
f0267b00 3529694542 C Co:2:008:0 -32 0
f0267b00 3529702370 S Ci:2:008:0 s 81 06 2200 0001 00ac 172 <
f0267b00 3529713044 C Ci:2:008:0 0 108 = 05010980 a1018501 19812983 15002501 95037501 81029501 75058101 c0050c09
f0267b00 3529718373 S Ii:2:008:2 -115:8 8 <
f0267b80 3529725741 S Ii:2:008:1 -115:8 8 <
f0267b00 3529733548 C Ii:2:008:2 0:8 8 = 03000000 00000000
f0267b00 3529733614 S Ii:2:008:2 -115:8 8 <
d8b15500 3530739916 S Co:2:008:0 s 21 09 0200 0000 0001 1 = 01
d8b15500 3530741428 C Co:2:008:0 0 1 >
eea26600 3531740815 S Co:2:008:0 s 21 09 0200 0000 0001 1 = 01
eea26600 3531741804 C Co:2:008:0 0 1 >
eea26c80 3532773340 S Co:2:008:0 s 21 09 0200 0000 0001 1 = 01
eea26c80 3532774436 C Co:2:008:0 0 1 >










f0267b00 3581997851 C Ii:2:008:2 0:8 8 = 03000008 00000000
db7e2900 3582013998 S Ii:2:008:2 -115:8 8 <
db7e2900 3582093846 C Ii:2:008:2 0:8 8 = 03000000 00000000
db7e2900 3582101235 S Ii:2:008:2 -115:8 8 <
db7e2900 3582477849 C Ii:2:008:2 0:8 8 = 03000008 00000000
db7e2900 3582497373 S Ii:2:008:2 -115:8 8 <
db7e2900 3582565849 C Ii:2:008:2 0:8 8 = 03000000 00000000
d58e0300 3582576419 S Ii:2:008:2 -115:8 8 <

--------------090403040409000000030605--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1CVFaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 01:30:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60025 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab1CVFaE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 01:30:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vToLM98uQiWsmRDlQT6oAmErZ17ySORMGT2xhyLFdddhh6/6iGi6AM9Wif9f9n3pFb
         OWCzNMNdGOUxio4I3CJJq+uHMMnO31cAiMbF7MVIiLeodb/hdzXacVI44DzBhG7M6QRc
         UCar3CvcLKQkIPxeDf5iqcVtPst9WJhqRT4R8=
MIME-Version: 1.0
In-Reply-To: <AANLkTikQW__eD5v59BqWOrzMoW5NVPDwkNYG2vfgRhjy@mail.gmail.com>
References: <AANLkTimwa4hvTzX+S1E08rwUKYrGB76GiZoE5LhHjGyu@mail.gmail.com> <AANLkTikQW__eD5v59BqWOrzMoW5NVPDwkNYG2vfgRhjy@mail.gmail.com>
From: nidhi mittal hada <nidhimittal19@gmail.com>
Date: Tue, 22 Mar 2011 10:59:43 +0530
Message-ID: <AANLkTimk=3gi1bEomL1k0kcN2SMUOiAKQ7SBNKg3kYGX@mail.gmail.com>
Subject: Re: usb-serial gadget -- windows xp not working
To: Xiaofan Chen <xiaofanc@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a Lot ..
I have got it working ....i tried changing afew string mentioned at
the end of inf file ...
as according to my device ...Beagleboard Netchip development board ....

and it worked well...

Thanks ...one more doubt .........


=============================================================
could you please tell What is the maximum speed we can get from the
usb-serial transmission in bits/sec ............?

====================================================


Nidhi



On Mon, Mar 21, 2011 at 8:46 PM, Xiaofan Chen <xiaofanc@gmail.com> wrote:
> On Mon, Mar 21, 2011 at 10:43 PM, nidhi mittal hada
> <nidhimittal19@gmail.com> wrote:
>> Hi all
>> I tried using g_serial driver for using my BeagleBoard (BB)  as usb
>> serial gadget to connect it to windows xp host.
>> using this link
>> http://www.mjmwired.net/kernel/Documentation/usb/gadget_serial.txt
>>
>> The command
>> modprobe g_serial executed properly  on BB (gadget) and It gets
>> identified successfully on Linus host(ubuntu) when connected through
>> usb wire.
>>
>> But
>> when the gadget connected to Windows XP .
>> Host XP identifies a new hardware in device manager ...But the step of
>> installing the .inf file obtained from
>> http://www.mjmwired.net/kernel/Documentation/usb/linux-cdc-acm.inf
>> does not succeed !!!
>
> The inf file indeed has some bugs. But I doubt that is your problem.
> http://www.microchip.com/forums/fb.ashx?m=488342
>
> mchpcdc.inf (and its derivatives)
>
>  [DestinationDirs]
>  FakeModemCopyFileSection=12            ; <------ add this line
>  DefaultDestDir=12
>
>  [DriverInstall.nt]
>  include=mdmcpq.inf
>  ;; CopyFiles = DriverCopyFiles.nt      ; <------ wrong one: reference
> to this INF file
>  CopyFiles = FakeModemCopyFileSection   ; <------ right one: reference
> to a section in mdmcpq.inf
>  AddReg=DriverInstall.nt.AddReg
>
>  ;; [DriverCopyFiles.nt]                ; <------ delete these lines
>  ;; usbser.sys,,,0x20                   ; <------
>
>
>> As i found after googling --  i changed the product ID Vendor ID in
>> .inf file ..as found for my gadget.
>> But the problem persists.!!!
>>
>
> If you have used the VID/PID for other experiment, then you will got
> problems. You can use usbdeview to get Windows to forget about
> the VID/PID combination.
> http://www.nirsoft.net/utils/usb_devices_view.html
>
> Or you can use pnputil if you have WDK.
> http://msdn.microsoft.com/en-us/library/ff550419(v=vs.85).aspx
>
> --
> Xiaofan
>



-- 
Thanks & Regards
Nidhi Mittal Hada

http://nidhi-searchingmyself.blogspot.com/

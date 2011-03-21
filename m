Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab1CUPRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 11:17:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64927 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab1CUPRK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 11:17:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mIBkEEG2NT+lZWc8jPDzaDnSH/FSxzlFX2zVnIrsCuI63ec8w+r7guSvgL6K93m/sP
         zrEmly0IZZD7+j7V5OssPOAhTyMGkLtXr/7385hPdw/wRrotL1YUZC2Ar8FSgExspU2O
         K+Vnyvkd5T+/97+HYtaMGX+OypgRJi4r1aqTg=
MIME-Version: 1.0
In-Reply-To: <AANLkTimwa4hvTzX+S1E08rwUKYrGB76GiZoE5LhHjGyu@mail.gmail.com>
References: <AANLkTimwa4hvTzX+S1E08rwUKYrGB76GiZoE5LhHjGyu@mail.gmail.com>
Date: Mon, 21 Mar 2011 23:16:54 +0800
Message-ID: <AANLkTikQW__eD5v59BqWOrzMoW5NVPDwkNYG2vfgRhjy@mail.gmail.com>
Subject: Re: usb-serial gadget -- windows xp not working
From: Xiaofan Chen <xiaofanc@gmail.com>
To: nidhi mittal hada <nidhimittal19@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 10:43 PM, nidhi mittal hada
<nidhimittal19@gmail.com> wrote:
> Hi all
> I tried using g_serial driver for using my BeagleBoard (BB)  as usb
> serial gadget to connect it to windows xp host.
> using this link
> http://www.mjmwired.net/kernel/Documentation/usb/gadget_serial.txt
>
> The command
> modprobe g_serial executed properly  on BB (gadget) and It gets
> identified successfully on Linus host(ubuntu) when connected through
> usb wire.
>
> But
> when the gadget connected to Windows XP .
> Host XP identifies a new hardware in device manager ...But the step of
> installing the .inf file obtained from
> http://www.mjmwired.net/kernel/Documentation/usb/linux-cdc-acm.inf
> does not succeed !!!

The inf file indeed has some bugs. But I doubt that is your problem.
http://www.microchip.com/forums/fb.ashx?m=488342

mchpcdc.inf (and its derivatives)

 [DestinationDirs]
 FakeModemCopyFileSection=12            ; <------ add this line
 DefaultDestDir=12

 [DriverInstall.nt]
 include=mdmcpq.inf
 ;; CopyFiles = DriverCopyFiles.nt      ; <------ wrong one: reference
to this INF file
 CopyFiles = FakeModemCopyFileSection   ; <------ right one: reference
to a section in mdmcpq.inf
 AddReg=DriverInstall.nt.AddReg

 ;; [DriverCopyFiles.nt]                ; <------ delete these lines
 ;; usbser.sys,,,0x20                   ; <------


> As i found after googling --  i changed the product ID Vendor ID in
> .inf file ..as found for my gadget.
> But the problem persists.!!!
>

If you have used the VID/PID for other experiment, then you will got
problems. You can use usbdeview to get Windows to forget about
the VID/PID combination.
http://www.nirsoft.net/utils/usb_devices_view.html

Or you can use pnputil if you have WDK.
http://msdn.microsoft.com/en-us/library/ff550419(v=vs.85).aspx

-- 
Xiaofan

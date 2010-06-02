Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab0FBNC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 09:02:58 -0400
Received: from mail-yw0-f179.google.com ([209.85.211.179]:63786 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab0FBNCz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 09:02:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sireZZaYS2BiDGfltb3GfkCmXmOpiYo8qijIyCsybbZFVha5qUm7wSV6hbkFAEuu+Z
         6Ddm7ksCwKxg7ZSu+5uVYwTeSaWMmPYjAJ7Kc7nQG6hwszR8W5yp5WZJn2UVhsE7KxuI
         EU9K/eHDDhYQdiastLYuyCTSepeVdzITJY1/4=
MIME-Version: 1.0
In-Reply-To: <c8725442e3c5b8c7be2cc381ed69a3dc0283ebe1.1275481997.git.mina86@mina86.com>
References: <cover.1275481997.git.mina86@mina86.com>
	<5e151207bced1e418bcfed136a871d2da47e417e.1275481997.git.mina86@mina86.com>
	<e4cb4e647e0ebc51956d6581cd930e3d32f29b99.1275481997.git.mina86@mina86.com>
	<785f09f63fe30ba52ce15fd7cb3f5750aa279ab9.1275481997.git.mina86@mina86.com>
	<5492eaf531c8a59c7c188b9e341572c9cdaed5f2.1275481997.git.mina86@mina86.com>
	<17b54e2cc00a7f730483401f06c79c781491dc62.1275481997.git.mina86@mina86.com>
	<381c3f8318e39caaffa1ecfdf5e3cf13ed59cd27.1275481997.git.mina86@mina86.com>
	<c8725442e3c5b8c7be2cc381ed69a3dc0283ebe1.1275481997.git.mina86@mina86.com>
Date: Wed, 2 Jun 2010 21:02:54 +0800
Message-ID: <AANLkTikAhJXiKGzyK7j3V7ev_6f2mn8f-A9tDmgdHy9I@mail.gmail.com>
Subject: Re: [PATCHv3 07/11] USB: gadget: g_multi: added documentation and INF 
	files
From: Xiaofan Chen <xiaofanc@gmail.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 8:45 PM, Michal Nazarewicz
<m.nazarewicz@samsung.com> wrote:

> +**** Improvements in INF files
> +
> +It needs to be noted that we are not Windows driver experts and as
> +such we do not claim that provided INF files are flawless or that they
> +will work on each and every Windows versions (they were tested on
> +Windows XP SP3 only).
> +
> +The bottom line is, if you can improve the INF files, please do and
> +share the results[7]. :)

Seems to be very true. I think both INF files are very outdated. But
I am not familiar with RNDIS to comment on that one.

But the following INF file for serial is really outdated. For example,
it probably does not work under Vista/Win7. It also do not
support 64bit OS.

> diff --git a/Documentation/usb/gadget_multi_serial.inf b/Documentation/usb/gadget_multi_serial.inf
> new file mode 100644
> index 0000000..b04ace1
> --- /dev/null
> +++ b/Documentation/usb/gadget_multi_serial.inf
> @@ -0,0 +1,44 @@
> +[Version]
> +Signature="$Windows NT$"
> +Class=Ports
> +ClassGuid={4D36E978-E325-11CE-BFC1-08002BE10318}
> +Provider=%LINUX%
> +DriverVer=08/17/2004,0.0.2.1
> +; Copyright (C) 2004 Al Borchers (alborchers@steinerpoint.com)
> +
> +[Manufacturer]
> +%LINUX%=GSerialDeviceList
> +
> +[GSerialDeviceList]
> +%GSERIAL%=GSerialInstall, USB\VID_0525&PID_A4AB&MI_02
> +
> +[DestinationDirs]
> +DefaultDestDir=10,System32\Drivers
> +
> +[GSerialInstall]
> +CopyFiles=GSerialCopyFiles
> +AddReg=GSerialAddReg
> +
> +[GSerialCopyFiles]
> +usbser.sys
> +
> +[GSerialAddReg]
> +HKR,,DevLoader,,*ntkern
> +HKR,,NTMPDriver,,usbser.sys
> +HKR,,EnumPropPages32,,"MsPorts.dll,SerialPortPropPageProvider"
> +
> +[GSerialInstall.Services]
> +AddService = usbser,0x0002,GSerialService
> +
> +[GSerialService]
> +DisplayName = %GSERIAL_DISPLAY_NAME%
> +ServiceType = 1                  ; SERVICE_KERNEL_DRIVER
> +StartType = 3                    ; SERVICE_DEMAND_START
> +ErrorControl = 1                 ; SERVICE_ERROR_NORMAL
> +ServiceBinary = %10%\System32\Drivers\usbser.sys
> +LoadOrderGroup = Base
> +
> +[Strings]
> +LINUX = "Linux"
> +GSERIAL = "Serial Gadget/Linux Multifunction Gadget"
> +GSERIAL_DISPLAY_NAME = "Serial Gadget/Linux Multifunction Gadget"
> --

A proper example from Microchip (USB Stack V2.7).


; Windows USB CDC ACM Setup File
; Copyright (c) 2000 Microsoft Corporation
; Copyright (C) 2007 Microchip Technology Inc.

[Version]
Signature="$Windows NT$"
Class=Ports
ClassGuid={4D36E978-E325-11CE-BFC1-08002BE10318}
Provider=%MFGNAME%
LayoutFile=layout.inf
CatalogFile=%MFGFILENAME%.cat
DriverVer=11/15/2007,5.1.2600.0

[Manufacturer]
%MFGNAME%=DeviceList, NTamd64

[DestinationDirs]
DefaultDestDir=12


;------------------------------------------------------------------------------
;  Windows 2000/XP/Vista-32bit Sections
;------------------------------------------------------------------------------

[DriverInstall.nt]
include=mdmcpq.inf
CopyFiles=DriverCopyFiles.nt
AddReg=DriverInstall.nt.AddReg

[DriverCopyFiles.nt]
usbser.sys,,,0x20

[DriverInstall.nt.AddReg]
HKR,,DevLoader,,*ntkern
HKR,,NTMPDriver,,%DRIVERFILENAME%.sys
HKR,,EnumPropPages32,,"MsPorts.dll,SerialPortPropPageProvider"

[DriverInstall.nt.Services]
AddService=usbser, 0x00000002, DriverService.nt

[DriverService.nt]
DisplayName=%SERVICE%
ServiceType=1
StartType=3
ErrorControl=1
ServiceBinary=%12%\%DRIVERFILENAME%.sys

;------------------------------------------------------------------------------
;  Vista-64bit Sections
;------------------------------------------------------------------------------

[DriverInstall.NTamd64]
include=mdmcpq.inf
CopyFiles=DriverCopyFiles.NTamd64
AddReg=DriverInstall.NTamd64.AddReg

[DriverCopyFiles.NTamd64]
%DRIVERFILENAME%.sys,,,0x20

[DriverInstall.NTamd64.AddReg]
HKR,,DevLoader,,*ntkern
HKR,,NTMPDriver,,%DRIVERFILENAME%.sys
HKR,,EnumPropPages32,,"MsPorts.dll,SerialPortPropPageProvider"

[DriverInstall.NTamd64.Services]
AddService=usbser, 0x00000002, DriverService.NTamd64

[DriverService.NTamd64]
DisplayName=%SERVICE%
ServiceType=1
StartType=3
ErrorControl=1
ServiceBinary=%12%\%DRIVERFILENAME%.sys


;------------------------------------------------------------------------------
;  Vendor and Product ID Definitions
;------------------------------------------------------------------------------
; When developing your USB device, the VID and PID used in the PC side
; application program and the firmware on the microcontroller must match.
; Modify the below line to use your VID and PID.  Use the format as shown below.
; Note: One INF file can be used for multiple devices with different
VID and PIDs.
; For each supported device, append ",USB\VID_xxxx&PID_yyyy" to the
end of the line.
;------------------------------------------------------------------------------
[SourceDisksFiles]
[SourceDisksNames]
[DeviceList]
%DESCRIPTION%=DriverInstall, USB\VID_04D8&PID_000A

[DeviceList.NTamd64]
%DESCRIPTION%=DriverInstall, USB\VID_04D8&PID_000A


;------------------------------------------------------------------------------
;  String Definitions
;------------------------------------------------------------------------------
;Modify these strings to customize your device
;------------------------------------------------------------------------------
[Strings]
MFGFILENAME="mchpcdc"
DRIVERFILENAME ="usbser"
MFGNAME="Microchip Technology, Inc."
INSTDISK="Microchip Technology, Inc. Installation Disc"
DESCRIPTION="Communications Port"
SERVICE="USB RS-232 Emulation Driver"




-- 
Xiaofan http://mcuee.blogspot.com

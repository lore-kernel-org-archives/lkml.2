Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0FGMlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:41:46 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56223 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab0FGMj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:39:28 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 07 Jun 2010 14:39:55 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv4 08/13] USB: gadget: g_serial: INF file updated
In-reply-to: <9e21e4f5440d2a2fcfa11bca18e62c713317b330.1275906835.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org, linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Xiaofan Chen <xiaofanc@gmail.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <61c7dcd3597ed56ec1caa5bcb66bf9bc1b09fb66.1275906835.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <cover.1275906835.git.m.nazarewicz@samsung.com>
 <72866638a69b660e3eb534330937955d15dde4de.1275906835.git.m.nazarewicz@samsung.com>
 <df04b95ee38845c46fa735c3e53768f57f94f748.1275906835.git.m.nazarewicz@samsung.com>
 <897d8ae37d4fa2fdb7dad8787add81c720581313.1275906835.git.m.nazarewicz@samsung.com>
 <b34cbaab37bf0590cb254a03478c5297bc4a1723.1275906835.git.m.nazarewicz@samsung.com>
 <7781ec0d22fa9dde7afbd3bf915af1a592780938.1275906835.git.m.nazarewicz@samsung.com>
 <871680934027e59f08ad63399a5923960147d313.1275906835.git.m.nazarewicz@samsung.com>
 <9e21e4f5440d2a2fcfa11bca18e62c713317b330.1275906835.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated the INF file for g_serial gadget.  It should work with
most recent Windows systems now.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/usb/gadget_serial.txt |   87 +++-------------------------
 Documentation/usb/linux-cdc-acm.inf |  106 +++++++++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+), 77 deletions(-)
 create mode 100644 Documentation/usb/linux-cdc-acm.inf

diff --git a/Documentation/usb/gadget_serial.txt b/Documentation/usb/gadget_serial.txt
index eac7df9..61e67f6 100644
--- a/Documentation/usb/gadget_serial.txt
+++ b/Documentation/usb/gadget_serial.txt
@@ -151,88 +151,23 @@ instructions below to install the host side driver.
 
 Installing the Windows Host ACM Driver
 --------------------------------------
-To use the Windows ACM driver you must have the files "gserial.inf"
-and "usbser.sys" together in a folder on the Windows machine.
-
-The "gserial.inf" file is given here.
-
--------------------- CUT HERE --------------------
-[Version]
-Signature="$Windows NT$"
-Class=Ports
-ClassGuid={4D36E978-E325-11CE-BFC1-08002BE10318}
-Provider=%LINUX%
-DriverVer=08/17/2004,0.0.2.0
-; Copyright (C) 2004 Al Borchers (alborchers@steinerpoint.com)
-
-[Manufacturer]
-%LINUX%=GSerialDeviceList
-
-[GSerialDeviceList]
-%GSERIAL%=GSerialInstall, USB\VID_0525&PID_A4A7
-
-[DestinationDirs]
-DefaultDestDir=10,System32\Drivers
-
-[GSerialInstall]
-CopyFiles=GSerialCopyFiles
-AddReg=GSerialAddReg
-
-[GSerialCopyFiles]
-usbser.sys
-
-[GSerialAddReg]
-HKR,,DevLoader,,*ntkern
-HKR,,NTMPDriver,,usbser.sys
-HKR,,EnumPropPages32,,"MsPorts.dll,SerialPortPropPageProvider"
-
-[GSerialInstall.Services]
-AddService = usbser,0x0002,GSerialService
-
-[GSerialService]
-DisplayName = %GSERIAL_DISPLAY_NAME%
-ServiceType = 1                  ; SERVICE_KERNEL_DRIVER
-StartType = 3                    ; SERVICE_DEMAND_START
-ErrorControl = 1                 ; SERVICE_ERROR_NORMAL
-ServiceBinary = %10%\System32\Drivers\usbser.sys
-LoadOrderGroup = Base
-
-[Strings]
-LINUX = "Linux"
-GSERIAL = "Gadget Serial"
-GSERIAL_DISPLAY_NAME = "USB Gadget Serial Driver"
--------------------- CUT HERE --------------------
-
-The "usbser.sys" file comes with various versions of Windows.
-For example, it can be found on Windows XP typically in
-
-  C:\WINDOWS\Driver Cache\i386\driver.cab
-
-Or it can be found on the Windows 98SE CD in the "win98" folder
-in the "DRIVER11.CAB" through "DRIVER20.CAB" cab files.  You will
-need the DOS "expand" program, the Cygwin "cabextract" program, or
-a similar program to unpack these cab files and extract "usbser.sys".
-
-For example, to extract "usbser.sys" into the current directory
-on Windows XP, open a DOS window and run a command like
-
-  expand C:\WINDOWS\Driver~1\i386\driver.cab -F:usbser.sys .
-
-(Thanks to Nishant Kamat for pointing out this DOS command.)
+To use the Windows ACM driver you must have the "linux-cdc-acm.inf"
+file (provided along this document) which supports all recent versions
+of Windows.
 
 When the gadget serial driver is loaded and the USB device connected
 to the Windows host with a USB cable, Windows should recognize the
 gadget serial device and ask for a driver.  Tell Windows to find the
-driver in the folder that contains "gserial.inf" and "usbser.sys".
+driver in the folder that contains the "linux-cdc-acm.inf" file.
 
 For example, on Windows XP, when the gadget serial device is first
 plugged in, the "Found New Hardware Wizard" starts up.  Select
-"Install from a list or specific location (Advanced)", then on
-the next screen select "Include this location in the search" and
-enter the path or browse to the folder containing "gserial.inf" and
-"usbser.sys".  Windows will complain that the Gadget Serial driver
-has not passed Windows Logo testing, but select "Continue anyway"
-and finish the driver installation.
+"Install from a list or specific location (Advanced)", then on the
+next screen select "Include this location in the search" and enter the
+path or browse to the folder containing the "linux-cdc-acm.inf" file.
+Windows will complain that the Gadget Serial driver has not passed
+Windows Logo testing, but select "Continue anyway" and finish the
+driver installation.
 
 On Windows XP, in the "Device Manager" (under "Control Panel",
 "System", "Hardware") expand the "Ports (COM & LPT)" entry and you
@@ -345,5 +280,3 @@ you should be able to send data back and forth between the gadget
 side and host side systems.  Anything you type on the terminal
 window on the gadget side should appear in the terminal window on
 the host side and vice versa.
-
-
diff --git a/Documentation/usb/linux-cdc-acm.inf b/Documentation/usb/linux-cdc-acm.inf
new file mode 100644
index 0000000..0e338e5
--- /dev/null
+++ b/Documentation/usb/linux-cdc-acm.inf
@@ -0,0 +1,106 @@
+; Windows USB CDC ACM Setup File
+; Copyright (c) 2000 Microsoft Corporation
+; Copyright (C) 2007 Microchip Technology Inc.
+
+; Hacked for Linux by Michal Nazarewicz <mina86@mina86.com>
+; No, I do not understand this file, don't blame me if it does not
+; work...  Thanks to Xiaofan Chen for pointing to this file.
+
+[Version]
+Signature="$Windows NT$"
+Class=Ports
+ClassGuid={4D36E978-E325-11CE-BFC1-08002BE10318}
+Provider=%Linux%
+DriverVer=11/15/2007,5.1.2600.0
+
+[Manufacturer]
+%Linux%=DeviceList, NTamd64
+
+[DestinationDirs]
+DefaultDestDir=12
+
+
+;------------------------------------------------------------------------------
+;  Windows 2000/XP/Vista-32bit Sections
+;------------------------------------------------------------------------------
+
+[DriverInstall.nt]
+include=mdmcpq.inf
+CopyFiles=DriverCopyFiles.nt
+AddReg=DriverInstall.nt.AddReg
+
+[DriverCopyFiles.nt]
+usbser.sys,,,0x20
+
+[DriverInstall.nt.AddReg]
+HKR,,DevLoader,,*ntkern
+HKR,,NTMPDriver,,USBSER.sys
+HKR,,EnumPropPages32,,"MsPorts.dll,SerialPortPropPageProvider"
+
+[DriverInstall.nt.Services]
+AddService=usbser, 0x00000002, DriverService.nt
+
+[DriverService.nt]
+DisplayName=%SERVICE%
+ServiceType=1
+StartType=3
+ErrorControl=1
+ServiceBinary=%12%\USBSER.sys
+
+;------------------------------------------------------------------------------
+;  Vista-64bit Sections
+;------------------------------------------------------------------------------
+
+[DriverInstall.NTamd64]
+include=mdmcpq.inf
+CopyFiles=DriverCopyFiles.NTamd64
+AddReg=DriverInstall.NTamd64.AddReg
+
+[DriverCopyFiles.NTamd64]
+USBSER.sys,,,0x20
+
+[DriverInstall.NTamd64.AddReg]
+HKR,,DevLoader,,*ntkern
+HKR,,NTMPDriver,,USBSER.sys
+HKR,,EnumPropPages32,,"MsPorts.dll,SerialPortPropPageProvider"
+
+[DriverInstall.NTamd64.Services]
+AddService=usbser, 0x00000002, DriverService.NTamd64
+
+[DriverService.NTamd64]
+DisplayName=%SERVICE%
+ServiceType=1
+StartType=3
+ErrorControl=1
+ServiceBinary=%12%\USBSER.sys
+
+
+;------------------------------------------------------------------------------
+;  Vendor and Product ID Definitions
+;------------------------------------------------------------------------------
+; When developing your USB device, the VID and PID used in the PC side
+; application program and the firmware on the microcontroller must match.
+; Modify the below line to use your VID and PID.  Use the format as shown below.
+; Note: One INF file can be used for multiple devices with different
+VID and PIDs.
+; For each supported device, append ",USB\VID_xxxx&PID_yyyy" to the
+end of the line.
+;------------------------------------------------------------------------------
+[SourceDisksFiles]
+[SourceDisksNames]
+[DeviceList]
+%DESCRIPTION%=DriverInstall, USB\VID_0525&PID_A4A7
+
+[DeviceList.NTamd64]
+%DESCRIPTION%=DriverInstall, USB\VID_0525&PID_A4A7
+
+
+;------------------------------------------------------------------------------
+;  String Definitions
+;------------------------------------------------------------------------------
+;Modify these strings to customize your device
+;------------------------------------------------------------------------------
+[Strings]
+Linux               = "Linux Developer Community"
+DESCRIPTION         = "Gadget Serial"
+SERVICE             = "USB RS-232 Emulation Driver"
-- 
1.7.1


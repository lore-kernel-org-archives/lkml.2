Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab0FGMmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:42:08 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35000 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab0FGMjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:39:24 -0400
Date: Mon, 07 Jun 2010 14:39:54 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv4 07/13] USB: gadget: g_ether: updated INF file
In-reply-to: <871680934027e59f08ad63399a5923960147d313.1275906835.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org, linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Xiaofan Chen <xiaofanc@gmail.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <9e21e4f5440d2a2fcfa11bca18e62c713317b330.1275906835.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1275906835.git.m.nazarewicz@samsung.com>
 <72866638a69b660e3eb534330937955d15dde4de.1275906835.git.m.nazarewicz@samsung.com>
 <df04b95ee38845c46fa735c3e53768f57f94f748.1275906835.git.m.nazarewicz@samsung.com>
 <897d8ae37d4fa2fdb7dad8787add81c720581313.1275906835.git.m.nazarewicz@samsung.com>
 <b34cbaab37bf0590cb254a03478c5297bc4a1723.1275906835.git.m.nazarewicz@samsung.com>
 <7781ec0d22fa9dde7afbd3bf915af1a592780938.1275906835.git.m.nazarewicz@samsung.com>
 <871680934027e59f08ad63399a5923960147d313.1275906835.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated the INF file for the g_ether gadegt.  It should work with most
recent Windows systems now.  The file hase been also renamed to
linux-rndis.inf rather then linux.inf.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/usb/linux-rndis.inf |   79 +++++++++++++++
 Documentation/usb/linux.inf       |  200 -------------------------------------
 2 files changed, 79 insertions(+), 200 deletions(-)
 create mode 100644 Documentation/usb/linux-rndis.inf
 delete mode 100644 Documentation/usb/linux.inf

diff --git a/Documentation/usb/linux-rndis.inf b/Documentation/usb/linux-rndis.inf
new file mode 100644
index 0000000..fa608fa
--- /dev/null
+++ b/Documentation/usb/linux-rndis.inf
@@ -0,0 +1,79 @@
+;
+; Remote NDIS template device setup file
+; Copyright (c) Microsoft Corporation
+;
+; This is the template for the INF installation script
+; for the RNDIS-over-USB host driver.
+; This INF works for Windows XP SP2, Windows XP x64,
+; Windows Server 2003 SP1 x86, x64, and ia64, and
+; Windows Vista x86 and x64.
+; This INF will work with Windows XP, Windows XP SP1,
+; and Windows 2003 after applying specific hotfixes.
+;
+; Hacked for Linux by Michal Nazarewicz <mina86@mina86.com>
+; No, I do not understand this file, don't blame me if it
+; does not work...  Original found at:
+; <http://msdn.microsoft.com/en-us/library/ff570620.aspx>.
+; Thanks to Xiaofan Chen for pointing to this template.
+;
+
+[Version]
+Signature           = "$Windows NT$"
+Class               = Net
+ClassGUID           = {4d36e972-e325-11ce-bfc1-08002be10318}
+Provider            = %Linux%
+DriverVer           = 06/21/2006,6.0.6000.16384
+;CatalogFile        = device.cat
+
+[Manufacturer]
+%Linux%             = RndisDevices,NTx86,NTamd64,NTia64
+
+; Decoration for x86 architecture
+[RndisDevices.NTx86]
+%RndisDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2
+
+; Decoration for x64 architecture
+[RndisDevices.NTamd64]
+%RndisDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2
+
+; Decoration for ia64 architecture
+[RndisDevices.NTia64]
+%RndisDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2
+
+;@@@ This is the common setting for setup
+[ControlFlags]
+ExcludeFromSelect=*
+
+; DDInstall section
+; References the in-build Netrndis.inf
+[RNDIS.NT.5.1]
+Characteristics     = 0x84   ; NCF_PHYSICAL + NCF_HAS_UI
+BusType             = 15
+; NEVER REMOVE THE FOLLOWING REFERENCE FOR NETRNDIS.INF
+include             = netrndis.inf
+needs               = Usb_Rndis.ndi
+AddReg              = Rndis_AddReg_Vista
+
+; DDInstal.Services section
+[RNDIS.NT.5.1.Services]
+include             = netrndis.inf
+needs               = Usb_Rndis.ndi.Services
+
+; Optional registry settings. You can modify as needed.
+[RNDIS_AddReg_Vista]
+HKR, NDI\params\VistaProperty, ParamDesc,  0, %Vista_Property%
+HKR, NDI\params\VistaProperty, type,       0, "edit"
+HKR, NDI\params\VistaProperty, LimitText,  0, "12"
+HKR, NDI\params\VistaProperty, UpperCase,  0, "1"
+HKR, NDI\params\VistaProperty, default,    0, " "
+HKR, NDI\params\VistaProperty, optional,   0, "1"
+
+; No sys copyfiles - the sys files are already in-build
+; (part of the operating system).
+; We do not support XP SP1-, 2003 SP1-, ME, 9x.
+
+; Modify these strings for your device as needed.
+[Strings]
+Linux               = "Linux Developer Community"
+RndisDevice         = "Ethernet/RNDIS Gadget"
+Vista_Property      = "Optional Vista Property"
diff --git a/Documentation/usb/linux.inf b/Documentation/usb/linux.inf
deleted file mode 100644
index 2f7217d..0000000
--- a/Documentation/usb/linux.inf
+++ /dev/null
@@ -1,200 +0,0 @@
-; MS-Windows driver config matching some basic modes of the
-; Linux-USB Ethernet/RNDIS gadget firmware:
-;
-;  - RNDIS plus CDC Ethernet ... this may be familiar as a DOCSIS
-;    cable modem profile, and supports most non-Microsoft USB hosts
-;
-;  - RNDIS plus CDC Subset ... used by hardware that incapable of
-;    full CDC Ethernet support.
-;
-; Microsoft only directly supports RNDIS drivers, and bundled them into XP.
-; The Microsoft "Remote NDIS USB Driver Kit" is currently found at:
-;   http://www.microsoft.com/whdc/hwdev/resources/HWservices/rndis.mspx
-
-
-[Version]
-Signature           = "$CHICAGO$"
-Class               = Net
-ClassGUID           = {4d36e972-e325-11ce-bfc1-08002be10318}
-Provider            = %Linux%
-Compatible          = 1
-MillenniumPreferred = .ME
-DriverVer           = 03/30/2004,0.0.0.0
-; catalog file would be used by WHQL
-;CatalogFile         = Linux.cat
-
-[Manufacturer]
-%Linux%          = LinuxDevices,NT.5.1
-
-[LinuxDevices]
-; NetChip IDs, used by both firmware modes
-%LinuxDevice%    = RNDIS, USB\VID_0525&PID_a4a2
-
-[LinuxDevices.NT.5.1]
-%LinuxDevice%    = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2
-
-[ControlFlags]
-ExcludeFromSelect=*
-
-; Windows 98, Windows 98 Second Edition specific sections --------
-
-[RNDIS]
-DeviceID        = usb8023
-MaxInstance     = 512
-DriverVer           = 03/30/2004,0.0.0.0
-AddReg          = RNDIS_AddReg_98, RNDIS_AddReg_Common
-
-[RNDIS_AddReg_98]
-HKR, ,               DevLoader,        0, *ndis
-HKR, ,               DeviceVxDs,       0, usb8023.sys
-HKR, NDIS,           LogDriverName,    0, "usb8023"
-HKR, NDIS,           MajorNdisVersion, 1, 5
-HKR, NDIS,           MinorNdisVersion, 1, 0
-HKR, Ndi\Interfaces, DefUpper,         0, "ndis3,ndis4,ndis5"
-HKR, Ndi\Interfaces, DefLower,         0, "ethernet"
-HKR, Ndi\Interfaces, UpperRange,       0, "ndis3,ndis4,ndis5"
-HKR, Ndi\Interfaces, LowerRange,       0, "ethernet"
-HKR, Ndi\Install,    ndis3,            0, "RNDIS_Install_98"
-HKR, Ndi\Install,    ndis4,            0, "RNDIS_Install_98"
-HKR, Ndi\Install,    ndis5,            0, "RNDIS_Install_98"
-HKR, Ndi,            DeviceId,         0, "USB\VID_0525&PID_a4a2"
-
-[RNDIS_Install_98]
-CopyFiles=RNDIS_CopyFiles_98
-
-[RNDIS_CopyFiles_98]
-usb8023.sys, usb8023w.sys, , 0 
-rndismp.sys, rndismpw.sys, , 0 
-
-; Windows Millennium Edition specific sections --------------------
-
-[RNDIS.ME]
-DeviceID        = usb8023
-MaxInstance     = 512
-DriverVer           = 03/30/2004,0.0.0.0
-AddReg          = RNDIS_AddReg_ME, RNDIS_AddReg_Common
-Characteristics = 0x84   ; NCF_PHYSICAL + NCF_HAS_UI
-BusType         = 15
-
-[RNDIS_AddReg_ME]
-HKR, ,               DevLoader,        0, *ndis
-HKR, ,               DeviceVxDs,       0, usb8023.sys
-HKR, NDIS,           LogDriverName,    0, "usb8023"
-HKR, NDIS,           MajorNdisVersion, 1, 5
-HKR, NDIS,           MinorNdisVersion, 1, 0
-HKR, Ndi\Interfaces, DefUpper,         0, "ndis3,ndis4,ndis5"
-HKR, Ndi\Interfaces, DefLower,         0, "ethernet"
-HKR, Ndi\Interfaces, UpperRange,       0, "ndis3,ndis4,ndis5"
-HKR, Ndi\Interfaces, LowerRange,       0, "ethernet"
-HKR, Ndi\Install,    ndis3,            0, "RNDIS_Install_ME"
-HKR, Ndi\Install,    ndis4,            0, "RNDIS_Install_ME"
-HKR, Ndi\Install,    ndis5,            0, "RNDIS_Install_ME"
-HKR, Ndi,            DeviceId,         0, "USB\VID_0525&PID_a4a2"
-
-[RNDIS_Install_ME]
-CopyFiles=RNDIS_CopyFiles_ME
-
-[RNDIS_CopyFiles_ME]
-usb8023.sys, usb8023m.sys, , 0 
-rndismp.sys, rndismpm.sys, , 0 
-
-; Windows 2000 specific sections ---------------------------------
-
-[RNDIS.NT]
-Characteristics = 0x84   ; NCF_PHYSICAL + NCF_HAS_UI
-BusType         = 15
-DriverVer           = 03/30/2004,0.0.0.0
-AddReg          = RNDIS_AddReg_NT, RNDIS_AddReg_Common
-CopyFiles       = RNDIS_CopyFiles_NT
-
-[RNDIS.NT.Services]
-AddService = USB_RNDIS, 2, RNDIS_ServiceInst_NT, RNDIS_EventLog
-
-[RNDIS_CopyFiles_NT]
-; no rename of files on Windows 2000, use the 'k' names as is
-usb8023k.sys, , , 0 
-rndismpk.sys, , , 0 
-
-[RNDIS_ServiceInst_NT]
-DisplayName     = %ServiceDisplayName%
-ServiceType     = 1 
-StartType       = 3 
-ErrorControl    = 1 
-ServiceBinary   = %12%\usb8023k.sys    
-LoadOrderGroup  = NDIS
-AddReg          = RNDIS_WMI_AddReg_NT
-
-[RNDIS_WMI_AddReg_NT]
-HKR, , MofImagePath, 0x00020000, "System32\drivers\rndismpk.sys"
-
-; Windows XP specific sections -----------------------------------
-
-[RNDIS.NT.5.1]
-Characteristics = 0x84   ; NCF_PHYSICAL + NCF_HAS_UI
-BusType         = 15
-DriverVer           = 03/30/2004,0.0.0.0
-AddReg          = RNDIS_AddReg_NT, RNDIS_AddReg_Common
-; no copyfiles - the files are already in place
-
-[RNDIS.NT.5.1.Services]
-AddService      = USB_RNDIS, 2, RNDIS_ServiceInst_51, RNDIS_EventLog
-
-[RNDIS_ServiceInst_51]
-DisplayName     = %ServiceDisplayName%
-ServiceType     = 1 
-StartType       = 3 
-ErrorControl    = 1 
-ServiceBinary   = %12%\usb8023.sys    
-LoadOrderGroup  = NDIS
-AddReg          = RNDIS_WMI_AddReg_51
-
-[RNDIS_WMI_AddReg_51]
-HKR, , MofImagePath, 0x00020000, "System32\drivers\rndismp.sys"
-
-; Windows 2000 and Windows XP common sections --------------------
-
-[RNDIS_AddReg_NT]
-HKR, Ndi,               Service,        0, "USB_RNDIS"
-HKR, Ndi\Interfaces,    UpperRange,     0, "ndis5" 
-HKR, Ndi\Interfaces,    LowerRange,     0, "ethernet"
-
-[RNDIS_EventLog]
-AddReg = RNDIS_EventLog_AddReg
-
-[RNDIS_EventLog_AddReg]
-HKR, , EventMessageFile, 0x00020000, "%%SystemRoot%%\System32\netevent.dll"
-HKR, , TypesSupported,   0x00010001, 7
-
-; Common Sections -------------------------------------------------
-
-[RNDIS_AddReg_Common]
-HKR, NDI\params\NetworkAddress, ParamDesc,  0, %NetworkAddress%
-HKR, NDI\params\NetworkAddress, type,       0, "edit"
-HKR, NDI\params\NetworkAddress, LimitText,  0, "12"
-HKR, NDI\params\NetworkAddress, UpperCase,  0, "1"
-HKR, NDI\params\NetworkAddress, default,    0, " "
-HKR, NDI\params\NetworkAddress, optional,   0, "1"
-
-[SourceDisksNames]
-1=%SourceDisk%,,1
-
-[SourceDisksFiles]
-usb8023m.sys=1
-rndismpm.sys=1
-usb8023w.sys=1
-rndismpw.sys=1
-usb8023k.sys=1
-rndismpk.sys=1
-
-[DestinationDirs]
-RNDIS_CopyFiles_98    = 10, system32/drivers
-RNDIS_CopyFiles_ME    = 10, system32/drivers
-RNDIS_CopyFiles_NT    = 12
-
-[Strings]
-ServiceDisplayName    = "USB Remote NDIS Network Device Driver"
-NetworkAddress        = "Network Address"
-Linux                 = "Linux Developer Community"
-LinuxDevice           = "Linux USB Ethernet/RNDIS Gadget"
-SourceDisk            = "Ethernet/RNDIS Gadget Driver Install Disk"
-
-- 
1.7.1


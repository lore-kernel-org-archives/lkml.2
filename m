Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab0FPKH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 06:07:57 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57058 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757636Ab0FPKHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 06:07:31 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 16 Jun 2010 12:08:02 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv5 07/11] USB: gadget: g_ether: updated INF file
In-reply-to: <c7fbb2934e18cfd25df3e00a548ac33e5b0a7353.1276681840.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>, Greg KH <greg@kroah.com>,
       Xiaofan Chen <xiaofanc@gmail.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <9f32ae2ab133d27642ac4c1e81777b1e34a0c1a1.1276681840.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <20100615185527.GA22803@kroah.com>
 <cover.1276681840.git.m.nazarewicz@samsung.com>
 <7131891c93ac20a3360068e2f4b8fff0de7dfafb.1276681840.git.m.nazarewicz@samsung.com>
 <1cf0484e46e3b2b5ce0dea8cdc7396d4bfa977c5.1276681840.git.m.nazarewicz@samsung.com>
 <0022e21e1b622b3a54d1e55aed727e7e429c7c70.1276681840.git.m.nazarewicz@samsung.com>
 <45fc10256bd2374706e4153360427257d15804a9.1276681840.git.m.nazarewicz@samsung.com>
 <bb0d9f73c7caae31c0bc291d3dfce44a2f6a3736.1276681840.git.m.nazarewicz@samsung.com>
 <c7fbb2934e18cfd25df3e00a548ac33e5b0a7353.1276681840.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated the INF file for the g_ether gadegt.  It should work with most
recent Windows systems now.  The file hase been also renamed to
linux-rndis.inf rather then linux.inf.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/usb/linux.inf |  236 ++++++++++---------------------------------
 1 files changed, 52 insertions(+), 184 deletions(-)

diff --git a/Documentation/usb/linux.inf b/Documentation/usb/linux.inf
index 2f7217d..3bed2e9 100644
--- a/Documentation/usb/linux.inf
+++ b/Documentation/usb/linux.inf
@@ -1,200 +1,68 @@
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
+; Based on template INF file found at
+;    <http://msdn.microsoft.com/en-us/library/ff570620.aspx>
+; which was:
+;    Copyright (c) Microsoft Corporation
+; and released under the MLPL as found at:
+;    <http://msdn.microsoft.com/en-us/cc300389.aspx#MLPL>.
+; For use only on Windows operating systems.
 
 [Version]
-Signature           = "$CHICAGO$"
+Signature           = "$Windows NT$"
 Class               = Net
 ClassGUID           = {4d36e972-e325-11ce-bfc1-08002be10318}
 Provider            = %Linux%
-Compatible          = 1
-MillenniumPreferred = .ME
-DriverVer           = 03/30/2004,0.0.0.0
-; catalog file would be used by WHQL
-;CatalogFile         = Linux.cat
+DriverVer           = 06/21/2006,6.0.6000.16384
+;CatalogFile        = device.cat
 
 [Manufacturer]
-%Linux%          = LinuxDevices,NT.5.1
+%Linux%             = RndisDevices,NTx86,NTamd64,NTia64
+
+; Decoration for x86 architecture
+[RndisDevices.NTx86]
+%RndisDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2
 
-[LinuxDevices]
-; NetChip IDs, used by both firmware modes
-%LinuxDevice%    = RNDIS, USB\VID_0525&PID_a4a2
+; Decoration for x64 architecture
+[RndisDevices.NTamd64]
+%RndisDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2
 
-[LinuxDevices.NT.5.1]
-%LinuxDevice%    = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2
+; Decoration for ia64 architecture
+[RndisDevices.NTia64]
+%RndisDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2
 
+;@@@ This is the common setting for setup
 [ControlFlags]
 ExcludeFromSelect=*
 
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
+; DDInstall section
+; References the in-build Netrndis.inf
 [RNDIS.NT.5.1]
-Characteristics = 0x84   ; NCF_PHYSICAL + NCF_HAS_UI
-BusType         = 15
-DriverVer           = 03/30/2004,0.0.0.0
-AddReg          = RNDIS_AddReg_NT, RNDIS_AddReg_Common
-; no copyfiles - the files are already in place
-
+Characteristics     = 0x84   ; NCF_PHYSICAL + NCF_HAS_UI
+BusType             = 15
+; NEVER REMOVE THE FOLLOWING REFERENCE FOR NETRNDIS.INF
+include             = netrndis.inf
+needs               = Usb_Rndis.ndi
+AddReg              = Rndis_AddReg_Vista
+
+; DDInstal.Services section
 [RNDIS.NT.5.1.Services]
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
 [Strings]
-ServiceDisplayName    = "USB Remote NDIS Network Device Driver"
-NetworkAddress        = "Network Address"
-Linux                 = "Linux Developer Community"
-LinuxDevice           = "Linux USB Ethernet/RNDIS Gadget"
-SourceDisk            = "Ethernet/RNDIS Gadget Driver Install Disk"
-
+Linux               = "Linux Developer Community"
+RndisDevice         = "Ethernet/RNDIS Gadget"
+Vista_Property      = "Optional Vista Property"
-- 
1.7.1


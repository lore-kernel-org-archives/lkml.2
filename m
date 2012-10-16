Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab2JPVyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 17:54:46 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:64552 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab2JPVyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 17:54:32 -0400
X-Greylist: delayed 3609 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2012 17:54:31 EDT
From: minyard@acm.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 1/5] IPMI: Remove SMBus driver info from the docs
Date: Tue, 16 Oct 2012 15:53:36 -0500
Message-id: <1350420820-7156-2-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1350420820-7156-1-git-send-email-minyard@acm.org>
References: <1350420820-7156-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

Some documentation for the SMBus driver is in the IPMI docs, but that
code is not in the kernel tree at this point.  So remove the docs to
avoid confusion.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 Documentation/IPMI.txt |   65 ++---------------------------------------------
 1 files changed, 3 insertions(+), 62 deletions(-)

diff --git a/Documentation/IPMI.txt b/Documentation/IPMI.txt
index b2bea15..16eb4c9 100644
--- a/Documentation/IPMI.txt
+++ b/Documentation/IPMI.txt
@@ -42,13 +42,7 @@ The driver interface depends on your hardware.  If your system
 properly provides the SMBIOS info for IPMI, the driver will detect it
 and just work.  If you have a board with a standard interface (These
 will generally be either "KCS", "SMIC", or "BT", consult your hardware
-manual), choose the 'IPMI SI handler' option.  A driver also exists
-for direct I2C access to the IPMI management controller.  Some boards
-support this, but it is unknown if it will work on every board.  For
-this, choose 'IPMI SMBus handler', but be ready to try to do some
-figuring to see if it will work on your system if the SMBIOS/APCI
-information is wrong or not present.  It is fairly safe to have both
-these enabled and let the drivers auto-detect what is present.
+manual), choose the 'IPMI SI handler' option.
 
 You should generally enable ACPI on your system, as systems with IPMI
 can have ACPI tables describing them.
@@ -58,8 +52,7 @@ their job correctly, the IPMI controller should be automatically
 detected (via ACPI or SMBIOS tables) and should just work.  Sadly,
 many boards do not have this information.  The driver attempts
 standard defaults, but they may not work.  If you fall into this
-situation, you need to read the section below named 'The SI Driver' or
-"The SMBus Driver" on how to hand-configure your system.
+situation, you need to read the section below named 'The SI Driver'.
 
 IPMI defines a standard watchdog timer.  You can enable this with the
 'IPMI Watchdog Timer' config option.  If you compile the driver into
@@ -104,12 +97,7 @@ driver, each open file for this device ties in to the message handler
 as an IPMI user.
 
 ipmi_si - A driver for various system interfaces.  This supports KCS,
-SMIC, and BT interfaces.  Unless you have an SMBus interface or your
-own custom interface, you probably need to use this.
-
-ipmi_smb - A driver for accessing BMCs on the SMBus. It uses the
-I2C kernel driver's SMBus interfaces to send and receive IPMI messages
-over the SMBus.
+SMIC, and BT interfaces.
 
 ipmi_watchdog - IPMI requires systems to have a very capable watchdog
 timer.  This driver implements the standard Linux watchdog timer
@@ -482,53 +470,6 @@ for specifying an interface.  Note that when removing an interface,
 only the first three parameters (si type, address type, and address)
 are used for the comparison.  Any options are ignored for removing.
 
-The SMBus Driver
-----------------
-
-The SMBus driver allows up to 4 SMBus devices to be configured in the
-system.  By default, the driver will register any SMBus interfaces it finds
-in the I2C address range of 0x20 to 0x4f on any adapter.  You can change this
-at module load time (for a module) with:
-
-  modprobe ipmi_smb.o
-	addr=<adapter1>,<i2caddr1>[,<adapter2>,<i2caddr2>[,...]]
-	dbg=<flags1>,<flags2>...
-	[defaultprobe=1] [dbg_probe=1]
-
-The addresses are specified in pairs, the first is the adapter ID and the
-second is the I2C address on that adapter.
-
-The debug flags are bit flags for each BMC found, they are:
-IPMI messages: 1, driver state: 2, timing: 4, I2C probe: 8
-
-Setting smb_defaultprobe to zero disabled the default probing of SMBus
-interfaces at address range 0x20 to 0x4f.  This means that only the
-BMCs specified on the smb_addr line will be detected.
-
-Setting smb_dbg_probe to 1 will enable debugging of the probing and
-detection process for BMCs on the SMBusses.
-
-Discovering the IPMI compliant BMC on the SMBus can cause devices
-on the I2C bus to fail. The SMBus driver writes a "Get Device ID" IPMI
-message as a block write to the I2C bus and waits for a response.
-This action can be detrimental to some I2C devices. It is highly recommended
-that the known I2c address be given to the SMBus driver in the smb_addr
-parameter. The default address range will not be used when a smb_addr
-parameter is provided.
-
-When compiled into the kernel, the addresses can be specified on the
-kernel command line as:
-
-  ipmb_smb.addr=<adapter1>,<i2caddr1>[,<adapter2>,<i2caddr2>[,...]]
-	ipmi_smb.dbg=<flags1>,<flags2>...
-	ipmi_smb.defaultprobe=0 ipmi_smb.dbg_probe=1
-
-These are the same options as on the module command line.
-
-Note that you might need some I2C changes if CONFIG_IPMI_PANIC_EVENT
-is enabled along with this, so the I2C driver knows to run to
-completion during sending a panic event.
-
 
 Other Pieces
 ------------
-- 
1.7.4.1


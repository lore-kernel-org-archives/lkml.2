Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab1GIOsl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 10:48:41 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39442 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab1GIOsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 10:48:39 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 9 Jul 2011 16:48:29 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] firewire: document the sysfs ABIs
Message-ID: <20110709164829.011f17d4@stein>
In-Reply-To: <20110709164737.53cf7801@stein>
References: <20110709164226.519a81fe@stein>
	<20110709164322.2deb2f36@stein>
	<20110709164737.53cf7801@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of firewire-core and firewire-sbp2.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 Documentation/ABI/stable/sysfs-bus-firewire |  122 ++++++++++++++++++++
 1 file changed, 122 insertions(+)

Index: b/Documentation/ABI/stable/sysfs-bus-firewire
===================================================================
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-bus-firewire
@@ -0,0 +1,122 @@
+What:		/sys/bus/firewire/devices/fw[0-9]+/
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	linux1394-devel@lists.sourceforge.net
+Description:
+		IEEE 1394 node device attributes.
+		Read-only.  Mutable during the node device's lifetime.
+		See IEEE 1212 for semantic definitions.
+
+		config_rom
+			Contents of the Configuration ROM register.
+			Binary attribute; an array of host-endian u32.
+
+		guid
+			The node's EUI-64 in the bus information block of
+			Configuration ROM.
+			Hexadecimal string representation of an u64.
+
+
+What:		/sys/bus/firewire/devices/fw[0-9]+/units
+Date:		June 2009
+KernelVersion:	2.6.31
+Contact:	linux1394-devel@lists.sourceforge.net
+Description:
+		IEEE 1394 node device attribute.
+		Read-only.  Mutable during the node device's lifetime.
+		See IEEE 1212 for semantic definitions.
+
+		units
+			Summary of all units present in an IEEE 1394 node.
+			Contains space-separated tuples of specifier_id and
+			version of each unit present in the node.  Specifier_id
+			and version are hexadecimal string representations of
+			u24 of the respective unit directory entries.
+			Specifier_id and version within each tuple are separated
+			by a colon.
+
+Users:		udev rules to set ownership and access permissions or ACLs of
+		/dev/fw[0-9]+ character device files
+
+
+What:		/sys/bus/firewire/devices/fw[0-9]+[.][0-9]+/
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	linux1394-devel@lists.sourceforge.net
+Description:
+		IEEE 1394 unit device attributes.
+		Read-only.  Immutable during the unit device's lifetime.
+		See IEEE 1212 for semantic definitions.
+
+		modalias
+			Same as MODALIAS in the uevent at device creation.
+
+		rom_index
+			Offset of the unit directory within the parent device's
+			(node device's) Configuration ROM, in quadlets.
+			Decimal string representation.
+
+
+What:		/sys/bus/firewire/devices/*/
+Date:		May 2007
+KernelVersion:	2.6.22
+Contact:	linux1394-devel@lists.sourceforge.net
+Description:
+		Attributes common to IEEE 1394 node devices and unit devices.
+		Read-only.  Mutable during the node device's lifetime.
+		Immutable during the unit device's lifetime.
+		See IEEE 1212 for semantic definitions.
+
+		These attributes are only created if the root directory of an
+		IEEE 1394 node or the unit directory of an IEEE 1394 unit
+		actually contains according entries.
+
+		hardware_version
+			Hexadecimal string representation of an u24.
+
+		hardware_version_name
+			Contents of a respective textual descriptor leaf.
+
+		model
+			Hexadecimal string representation of an u24.
+
+		model_name
+			Contents of a respective textual descriptor leaf.
+
+		specifier_id
+			Hexadecimal string representation of an u24.
+			Mandatory in unit directories according to IEEE 1212.
+
+		vendor
+			Hexadecimal string representation of an u24.
+			Mandatory in the root directory according to IEEE 1212.
+
+		vendor_name
+			Contents of a respective textual descriptor leaf.
+
+		version
+			Hexadecimal string representation of an u24.
+			Mandatory in unit directories according to IEEE 1212.
+
+
+What:		/sys/bus/firewire/drivers/sbp2/fw*/host*/target*/*:*:*:*/ieee1394_id
+		formerly
+		/sys/bus/ieee1394/drivers/sbp2/fw*/host*/target*/*:*:*:*/ieee1394_id
+Date:		Feb 2004
+KernelVersion:	2.6.4
+Contact:	linux1394-devel@lists.sourceforge.net
+Description:
+		SCSI target port identifier and logical unit identifier of a
+		logical unit of an SBP-2 target.  The identifiers are specified
+		in SAM-2...SAM-4 annex A.  They are persistent and world-wide
+		unique properties the SBP-2 attached target.
+
+		Read-only attribute, immutable during the target's lifetime.
+		Format, as exposed by firewire-sbp2 since 2.6.22, May 2007:
+		Colon-separated hexadecimal string representations of
+			u64 EUI-64 : u24 directory_ID : u16 LUN
+		without 0x prefixes, without whitespace.  The former sbp2 driver
+		(removed in 2.6.37 after being superseded by firewire-sbp2) used
+		a somewhat shorter format which was not as close to SAM.
+
+Users:		udev rules to create /dev/disk/by-id/ symlinks


-- 
Stefan Richter
-=====-==-== -=== -=--=
http://arcgraph.de/sr/

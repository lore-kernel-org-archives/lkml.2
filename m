Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965313Ab2ERQsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:48:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758552Ab2ERQdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:33:05 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC v26 58/66] Edac: Add ABI Documentation for the new device nodes
Date: Fri, 18 May 2012 13:32:45 -0300
Message-Id: <1337358773-6919-59-git-send-email-mchehab@redhat.com>
In-Reply-To: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EDAC ABI were extended to add support for per-DIMM or per-rank
information and silkscreen labels. Properly document them.

Most of the comments there came from edac.txt descriptions of the
fields that are part of the legacy csrowX ABI (e. g.
/sys/devices/system/edac/mc/mc*/csrow*/*).

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/ABI/testing/sysfs-devices-edac |   64 ++++++++++++++++++++++++++
 1 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-edac b/Documentation/ABI/testing/sysfs-devices-edac
index 40db633..30ee78a 100644
--- a/Documentation/ABI/testing/sysfs-devices-edac
+++ b/Documentation/ABI/testing/sysfs-devices-edac
@@ -74,3 +74,67 @@ Description:	Read/Write attribute file that controls memory scrubbing.
 		Reading the file will return the actual scrubbing rate employed.
 		If configuration fails or memory scrubbing is not implemented,
 		the value of the attribute file will be -1.
+
+What:		/sys/devices/system/edac/mc/mc*/max_location
+Date:		April 2012
+Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+		linux-edac@vger.kernel.org
+Description:	This attribute file displays the information about the last
+		available memory slot in this memory controller. It is used by
+		userspace tools in order to display the memory filling layout.
+
+What:		/sys/devices/system/edac/mc/mc*/(dimm|rank)*/size
+Date:		April 2012
+Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+		linux-edac@vger.kernel.org
+Description:	This attribute file will display the size of dimm or rank.
+		For dimm*/size, this is the size, in MB of the DIMM memory
+		stick. For rank*/size, this is the size, in MB for one rank
+		of the DIMM memory stick. On single rank memories (1R), this
+		is also the total size of the dimm. On dual rank (2R) memories,
+		this is half the size of the total DIMM memories.
+
+What:		/sys/devices/system/edac/mc/mc*/(dimm|rank)*/dimm_dev_type
+Date:		April 2012
+Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+		linux-edac@vger.kernel.org
+Description:	This attribute file will display what type of DRAM device is
+		being utilized on this DIMM (x1, x2, x4, x8, ...).
+
+What:		/sys/devices/system/edac/mc/mc*/(dimm|rank)*/dimm_edac_mode
+Date:		April 2012
+Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+		linux-edac@vger.kernel.org
+Description:	This attribute file will display what type of Error detection
+		and correction is being utilized. For example: S4ECD4ED would
+		mean a Chipkill with x4 DRAM.
+
+What:		/sys/devices/system/edac/mc/mc*/(dimm|rank)*/dimm_label
+Date:		April 2012
+Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+		linux-edac@vger.kernel.org
+Description:	This control file allows this DIMM to have a label assigned
+		to it. With this label in the module, when errors occur
+		the output can provide the DIMM label in the system log.
+		This becomes vital for panic events to isolate the
+		cause of the UE event.
+		DIMM Labels must be assigned after booting, with information
+		that correctly identifies the physical slot with its
+		silk screen label. This information is currently very
+		motherboard specific and determination of this information
+		must occur in userland at this time.
+
+What:		/sys/devices/system/edac/mc/mc*/(dimm|rank)*/dimm_location
+Date:		April 2012
+Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+		linux-edac@vger.kernel.org
+Description:	This attribute file will display the location (csrow/channel,
+		branch/channel/slot or channel/slot) of the dimm or rank.
+
+What:		/sys/devices/system/edac/mc/mc*/(dimm|rank)*/dimm_mem_type
+Date:		April 2012
+Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+		linux-edac@vger.kernel.org
+Description:	This attribute file will display what type of memory is
+		currently on this csrow. Normally, either buffered or
+		unbuffered memory (for example, Unbuffered-DDR3).
-- 
1.7.8


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab2DQMGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 08:06:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030Ab2DQMGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 08:06:22 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Greg K H <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] edac: move documentation ABI to ABI/testing/sysfs-devices-edac
Date: Tue, 17 Apr 2012 09:06:11 -0300
Message-Id: <1334664371-10499-1-git-send-email-mchehab@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EDAC MC API is currently stored at the wrong place. Move the
parts of the EDAC MC ABI that will be kept to
ABI/testing/sysfs-devices-edac.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---

I'm actually in doubt if this patch is right, due to two reasons:

1) Date. I've no idea since when those sysfs nodes exist. As I'm moving it today
   to the right place, I'm marking them as April 2012, but maybe it would be better
   to get an approximate date since when those existing sysfs nodes exist.

2) Contact. I'm putting there the EDAC ML and my name, as I wrote the patch.
   Yet, the descriptions there are just what used to be at edac.txt. I'm not
   the author of the texts there for those existing nodes. So, maybe it would
   be better to just keep there the ML, as I suspect that the one(s) that wrote
   the original text is(are) not active anymore.

Greg,

Comments?

After fixing (if needed), I'll add there the new stuff.

 Documentation/ABI/testing/sysfs-devices-edac |   83 +++++++++++++++++++
 Documentation/edac.txt                       |  112 ++------------------------
 2 files changed, 91 insertions(+), 104 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-edac

diff --git a/Documentation/ABI/testing/sysfs-devices-edac b/Documentation/ABI/testing/sysfs-devices-edac
new file mode 100644
index 0000000..556830e
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-edac
@@ -0,0 +1,83 @@
+What:		/sys/devices/system/edac/mc/mc*/reset_counters
+Date:		April 2012
+Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+		linux-edac@vger.kernel.org
+Description:	This write-only control file will zero all the statistical
+		counters for UE and CE errors.  Zeroing the counters will also
+		reset the timer indicating how long since the last counter
+		were reset. This is useful for computing errors/time.  Since
+		the counters are always reset at driver initialization time,
+		no module/kernel parameter is available.
+
+What:		/sys/devices/system/edac/mc/mc*/seconds_since_reset
+Date:		April 2012
+Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+		linux-edac@vger.kernel.org
+Description:	This attribute file displays how many seconds have elapsed
+		since the last counter reset. This can be used with the error
+		counters to measure error rates.
+
+What:		/sys/devices/system/edac/mc/mc*/mc_name
+Date:		April 2012
+Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+		linux-edac@vger.kernel.org
+Description:	This attribute file displays the type of memory controller
+		that is being utilized.
+
+What:		/sys/devices/system/edac/mc/mc*/size_mb
+Date:		April 2012
+Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+		linux-edac@vger.kernel.org
+Description:	This attribute file displays, in count of megabytes, of memory
+		that this instance of memory controller manages.
+
+What:		/sys/devices/system/edac/mc/mc*/ue_count
+Date:		April 2012
+Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+		linux-edac@vger.kernel.org
+Description:	This attribute file displays the total count of uncorrectable
+		errors that have occurred on this memory controller. If
+		panic_on_ue is set, this counter will not have a chance to
+		increment, since EDAC will panic the system
+
+What:		/sys/devices/system/edac/mc/mc*/ue_noinfo_count
+Date:		April 2012
+Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+		linux-edac@vger.kernel.org
+Description:	This attribute file displays the number of UEs that have
+		occurred with no information as to which DIMM slot is having
+		errors.
+
+What:		/sys/devices/system/edac/mc/mc*/ce_count
+Date:		April 2012
+Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+		linux-edac@vger.kernel.org
+Description:	This attribute file displays the total count of correctable
+		errors that have occurred on this memory controller. This
+		count is very important to examine. CEs provide early
+		indications that a DIMM is beginning to fail. This count
+		field should be monitored for non-zero values and report
+		such information to the system administrator.
+
+What:		/sys/devices/system/edac/mc/mc*/ce_noinfo_count
+Date:		April 2012
+Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+		linux-edac@vger.kernel.org
+Description:	This attribute file displays the number of CEs that
+		have occurred wherewith no information as to which DIMM slot
+		is having errors. Memory is handicapped, but operational,
+		yet no information is available to indicate which slot
+		the failing memory is in. This count field should be also
+		be monitored for non-zero values.
+
+What:		/sys/devices/system/edac/mc/mc*/sdram_scrub_rate
+Date:		April 2012
+Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+		linux-edac@vger.kernel.org
+Description:	Read/Write attribute file that controls memory scrubbing.
+		The scrubbing rate is set by writing a minimum bandwidth in
+		bytes/sec to the attribute file. The rate will be translated
+		to an internal value that gives at least the specified rate.
+		Reading the file will return the actual scrubbing rate employed.
+		If configuration fails or memory scrubbing is not implemented,
+		the value of the attribute file will be -1.
diff --git a/Documentation/edac.txt b/Documentation/edac.txt
index 249822c..c25f086 100644
--- a/Documentation/edac.txt
+++ b/Documentation/edac.txt
@@ -232,116 +232,20 @@ EDAC control and attribute files.
 
 
 In 'mcX' directories are EDAC control and attribute files for
-this 'X' instance of the memory controllers:
-
-
-Counter reset control file:
-
-	'reset_counters'
-
-	This write-only control file will zero all the statistical counters
-	for UE and CE errors.  Zeroing the counters will also reset the timer
-	indicating how long since the last counter zero.  This is useful
-	for computing errors/time.  Since the counters are always reset at
-	driver initialization time, no module/kernel parameter is available.
-
-	RUN TIME: echo "anything" >/sys/devices/system/edac/mc/mc0/counter_reset
-
-		This resets the counters on memory controller 0
-
-
-Seconds since last counter reset control file:
-
-	'seconds_since_reset'
-
-	This attribute file displays how many seconds have elapsed since the
-	last counter reset. This can be used with the error counters to
-	measure error rates.
-
-
-
-Memory Controller name attribute file:
-
-	'mc_name'
-
-	This attribute file displays the type of memory controller
-	that is being utilized.
-
-
-Total memory managed by this memory controller attribute file:
-
-	'size_mb'
-
-	This attribute file displays, in count of megabytes, of memory
-	that this instance of memory controller manages.
-
-
-Total Uncorrectable Errors count attribute file:
-
-	'ue_count'
-
-	This attribute file displays the total count of uncorrectable
-	errors that have occurred on this memory controller. If panic_on_ue
-	is set this counter will not have a chance to increment,
-	since EDAC will panic the system.
-
-
-Total UE count that had no information attribute fileY:
-
-	'ue_noinfo_count'
-
-	This attribute file displays the number of UEs that have occurred
-	with no information as to which DIMM slot is having errors.
-
-
-Total Correctable Errors count attribute file:
-
-	'ce_count'
-
-	This attribute file displays the total count of correctable
-	errors that have occurred on this memory controller. This
-	count is very important to examine. CEs provide early
-	indications that a DIMM is beginning to fail. This count
-	field should be monitored for non-zero values and report
-	such information to the system administrator.
-
-
-Total Correctable Errors count attribute file:
-
-	'ce_noinfo_count'
-
-	This attribute file displays the number of CEs that
-	have occurred wherewith no information as to which DIMM slot
-	is having errors. Memory is handicapped, but operational,
-	yet no information is available to indicate which slot
-	the failing memory is in. This count field should be also
-	be monitored for non-zero values.
-
-Device Symlink:
-
-	'device'
-
-	Symlink to the memory controller device.
-
-Sdram memory scrubbing rate:
-
-	'sdram_scrub_rate'
-
-	Read/Write attribute file that controls memory scrubbing. The scrubbing
-	rate is set by writing a minimum bandwidth in bytes/sec to the attribute
-	file. The rate will be translated to an internal value that gives at
-	least the specified rate.
-
-	Reading the file will return the actual scrubbing rate employed.
-
-	If configuration fails or memory scrubbing is not implemented, the value
-	of the attribute file will be -1.
+this 'X' instance of the memory controllers.
 
+For a description of the sysfs API, please see:
+	Documentation/ABI/testing/sysfs/devices-edac
 
 
 ============================================================================
 'csrowX' DIRECTORIES
 
+When CONFIG_EDAC_LEGACY_SYSFS is enabled, the sysfs will contain the
+csrowX directories. As this API doesn't work properly for Rambus, FB-DIMMs
+and modern Intel Memory Controllers, this is being deprecated in favor
+of dimmX directories.
+
 In the 'csrowX' directories are EDAC control and attribute files for
 this 'X' instance of csrow:
 
-- 
1.7.8


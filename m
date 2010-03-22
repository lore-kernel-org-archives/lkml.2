Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab0CVWHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 18:07:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49931 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab0CVWH3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 18:07:29 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Greg KH <gregkh@suse.de>
CC: "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 23 Mar 2010 03:33:50 +0530
Subject: RE: [PATCH 4/6] drivers:misc: sources for Init manager module
Thread-Topic: [PATCH 4/6] drivers:misc: sources for Init manager module
Thread-Index: AcrKB99xRpqeFIklQ0GpqYJtUErQMwAA66iQ
Message-ID: <19F8576C6E063C45BE387C64729E7394044DB828A2@dbde02.ent.ti.com>
References: <1269292756-7469-1-git-send-email-pavan_savoy@ti.com>
 <1269292756-7469-2-git-send-email-pavan_savoy@ti.com>
 <1269292756-7469-3-git-send-email-pavan_savoy@ti.com>
 <1269292756-7469-4-git-send-email-pavan_savoy@ti.com>
 <1269292756-7469-5-git-send-email-pavan_savoy@ti.com>,<20100322213629.GD420@suse.de>
In-Reply-To: <20100322213629.GD420@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----------------------
Thanks & Regards,
Pavan Savoy | x0099669
________________________________________
From: Greg KH [gregkh@suse.de]
Sent: Tuesday, March 23, 2010 3:06 AM
To: Savoy, Pavan
Cc: alan@lxorguk.ukuu.org.uk; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module

On Mon, Mar 22, 2010 at 04:19:14PM -0500, pavan_savoy@ti.com wrote:
> +/* structures specific for sysfs entries */
> +static struct kobj_attribute pid_attr =
> +__ATTR(pid, 0644, (void *)show_pid, (void *)store_pid);
> +
> +static struct kobj_attribute list_protocols =
> +__ATTR(protocols, 0444, (void *)show_list, NULL);

>As you are creating sysfs attributes, you have to have
>Documentation/ABI/ updates as well.  Please include them so we can see
>what you are trying to do here.
>And why "raw" attributes and not device ones?
>thanks,
>greg k-h

[pavan] >>>>>>>>
I am creating a sysfs entry for the daemon/service to write in it's PID to the sysfs entry, so
as to whenever a new protocol driver - BT/FM or GPS wants to use the N_TI_SHARED ldisc, 
the driver would then send signal to daemon on this PID.

The source for this problem, was that I could not install line discipline from kernel space.
i.e make N_TI_SHARED line discipline the current ldisc from kernel space itself.
>>>>>>

>From 92d89d132b5036d8ab58ce4f36b24bb1859610e0 Mon Sep 17 00:00:00 2001
From: Pavan Savoy <pavan_savoy@ti.com>
Date: Mon, 22 Mar 2010 18:11:32 -0400
Subject: [PATCH 1/1] Documentation/ABI: for N_TI_SHARED ldisc
N_TI_SHARED creates a sysfs entry to communicate
with the application/daemon which would want to install/
un-install the line discipline, it's documentation
now exists in testing/ subdirectory.
Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 Documentation/ABI/testing/sysfs-uim |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-uim
diff --git a/Documentation/ABI/testing/sysfs-uim b/Documentation/ABI/testing/sysfs-uim
new file mode 100644
index 0000000..899aa4d
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-uim
@@ -0,0 +1,24 @@
+What:           /sys/uim
+Date:           March 22
+Contact:        Pavan Savoy <pavan_savoy@ti.com>
+Description:
+                Create a new kobject to pass information about the
+  N_TI_SHARED line discipline created to application/daemon
+  which would install/un-install line discipline.
+
+What:           /sys/uim/pid
+Date:           March 22
+Contact:        Pavan Savoy <pavan_savoy@ti.com>
+Description:
+  The daemon/application wanting to use the line discipline
+  N_TI_SHARED will write in it's process Id, for the LDISC
+  driver to send SIGUSR2 signal to the process whenever a
+  upper layer protocol driver wants to make use of the LDISC
+  driver.
+
+What:           /sys/uim/protocols
+Date:           March 22
+Contact:        Pavan Savoy <pavan_savoy@ti.com>
+Description:
+  List the protocols currently making use of the LDISC to ensure
+  LDISC is not un-installed when BT/FM or GPS is making use of it.
-- 
1.5.4.3
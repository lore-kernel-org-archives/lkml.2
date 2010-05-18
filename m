Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab0ERUbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:31:24 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:39113 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab0ERUbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:31:22 -0400
Date: Tue, 18 May 2010 22:30:49 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, dwmw2@infradead.org,
       broonie@opensource.wolfsonmicro.com, len.brown@intel.com,
       astarikovskiy@suse.de, mreimer@vpop.net, zbr@ioremap.net, tj@kernel.org,
       Anton Vorontsov <cbou@mail.ru>
Subject: [PATCH] power/ds2760_battery: document ABI change
Message-ID: <20100518203049.GK30801@buzzloop.caiaq.de>
References: <20100517194016.GA12147@oksana.dev.rtsoft.ru>
 <1274212193-16669-2-git-send-email-daniel@caiaq.de>
 <20100518195624.GA20057@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518195624.GA20057@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7ed6b078c1cb718509a0faf79ac53f768fa5cfc4 Mon Sep 17 00:00:00 2001
From: Daniel Mack <daniel@caiaq.de>
Date: Tue, 18 May 2010 22:26:40 +0200
Subject: [PATCH] power/ds2760_battery: document ABI change

Add some documentation for the newly added writeable properties.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
---
On Tue, May 18, 2010 at 12:56:24PM -0700, Greg KH wrote:
> On Tue, May 18, 2010 at 09:49:52PM +0200, Daniel Mack wrote:
> > This patch adds support for writeable power supply properties and
> > exposes them as writeable to sysfs.
> 
> Please properly document this in Documentation/ABI as you are changing
> the userspace ABI.
> 
> thanks,
> 
> greg k-h

Is something like the following appropriate?


 Documentation/ABI/testing/sysfs-class-power |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-power

diff --git a/Documentation/ABI/testing/sysfs-class-power b/Documentation/ABI/testing/sysfs-class-power
new file mode 100644
index 0000000..f46ad66
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-power
@@ -0,0 +1,21 @@
+What:		/sys/class/power/ds2760-battery.*/charge_now
+Date:		May 2010
+KernelVersion:	2.6.35
+Contact:	Daniel Mack <daniel@caiaq.de>
+Description:
+		This file is writeable and can be used to set the current
+		coloumb counter value inside the battery monitor chip. This
+		is needed for unavoidable corrections of aging batteries.
+		A userspace daemon can monitor the battery charging logic
+		and once the counter drops out of considerable bounds, take
+		appropriate action.
+
+What:		/sys/class/power/ds2760-battery.*/charge_full
+Date:		May 2010
+KernelVersion:	2.6.35
+Contact:	Daniel Mack <daniel@caiaq.de>
+Description:
+		This file is writeable and can be used to set the assumed
+		battery 'full level'. As batteries age, this value has to be
+		amended over time.
+
-- 
1.7.1

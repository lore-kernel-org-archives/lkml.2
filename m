Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab1CRAsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 20:48:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39498 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab1CRAso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 20:48:44 -0400
Date: Fri, 18 Mar 2011 11:48:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        matt mooney <mfm@muteddisk.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: linux-next: manual merge of the kbuild tree with the hwmon-staging
 tree
Message-Id: <20110318114836.04c76926.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Today's linux-next merge of the kbuild tree got a conflict in
drivers/hwmon/Makefile between commit 442aba78728e ("hwmon: PMBus device
driver") from the hwmon-staging tree and commit 5c39e31195f4 ("hwmon:
change to new flag variable") from the kbuild tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/hwmon/Makefile
index aaf6ca9,974f9cc..0000000
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@@ -114,14 -112,5 +114,12 @@@ obj-$(CONFIG_SENSORS_W83L786NG)	+= w83l
  obj-$(CONFIG_SENSORS_WM831X)	+= wm831x-hwmon.o
  obj-$(CONFIG_SENSORS_WM8350)	+= wm8350-hwmon.o
  
 +# PMBus drivers
 +obj-$(CONFIG_PMBUS)		+= pmbus_core.o
 +obj-$(CONFIG_SENSORS_PMBUS)	+= pmbus.o
 +obj-$(CONFIG_SENSORS_MAX16064)	+= max16064.o
 +obj-$(CONFIG_SENSORS_MAX34440)	+= max34440.o
 +obj-$(CONFIG_SENSORS_MAX8688)	+= max8688.o
 +
- ifeq ($(CONFIG_HWMON_DEBUG_CHIP),y)
- EXTRA_CFLAGS += -DDEBUG
- endif
+ ccflags-$(CONFIG_HWMON_DEBUG_CHIP) := -DDEBUG
  

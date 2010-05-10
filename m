Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab0EJKg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 06:36:56 -0400
Received: from smtp.nokia.com ([192.100.105.134]:57423 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab0EJKgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 06:36:51 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
       Linux-OMAP <linux-omap@vger.kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       ext Tony Lindgren <tony@atomide.com>,
       ext Kevin Hilman <khilman@deeprootsystems.com>,
       Peter De-Schrijver <Peter.De-Schrijver@nokia.com>,
       santosh.shilimkar@ti.com, Ambresh <a0393775@ti.com>,
       felipe.balbi@nokia.com, Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv4 0/4] Introduce the /proc/socinfo and use it to export OMAP data
Date: Mon, 10 May 2010 13:37:33 +0300
Message-Id: <1273487857-32281-1-git-send-email-eduardo.valentin@nokia.com>
X-Mailer: git-send-email 1.7.0.4.361.g8b5fe.dirty
X-OriginalArrivalTime: 10 May 2010 10:35:33.0041 (UTC) FILETIME=[84C80A10:01CAF02C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Here is the patch set to export OMAP id code, production id and die id.
The history of this change is as follows:

1. First attempt tried adding those data under sysfs node. Original patch by
Peter De Schrijver [1]. Then, it was suggested to move it to debugfs, which was
rejected as this info is actually needed in production systems.

2. Then it has been moved to /proc/cpuinfo [2]. Then, it was suggested to do
not add this kind of info there, as it is not really CPU data.

Now, I'm sending this version which will introduce first the /proc/socinfo.
Then, following patches will add OMAP data into that node. And finally,
will add OMAP id, production and die id code.

Just for reference, I'm also pasting the previous 0/4 message:

-------------------------------------------------------------------------------
I'm resending this series with minor change in the subject prefix of patch 4/4.
Removed the PM: prefix. Everything else is same. So, I kept the v3 prefix as well.

v3:
And now v3 of this series. Basically a minor change wrt string manipulation.
No need to use strlen in so many places. Previous log for reference:

v2:

Here is the version 2 of this series. Now die id is protected using
same x86 protection mechanism to hide x86 product number. Besides,
a compilation Kconfig option has been added for DIE ID as well.

Here is previous PATCH 0/4 message:

v1:

This series is to continue what has been discussed several weeks ago
wrt IDCODE patch. Original patch was made by Peter and discussion is here:
http://www.mail-archive.com/linux-omap@vger.kernel.org/msg17553.html

So, the conclusion was that IDCODE info is useful even in production systems,
and for that debugfs is not a good choice to export it. One suggestion was to
add it under /proc/cpuinfo. However this entry nowadays exports only ARM related
information.

So this series does the trick by extending the ARM /proc/cpuinfo to include
soc info data. There are a few ways to add a hook for soc specific data. But
I've decided to implement it via the simplest way I found. Basically it is
same thing which is done for system_rev, system_serial_low and system_serial_high.
Then, now we have system_soc_info, which is printed only if there is something
useful there.

As usual, comments are welcome.

BR,

Eduardo Valentin (4):
  procfs: Introduce socinfo under /proc
  mach-omap2: export omap2 info under /proc/socinfo
  mach-omap1: export omap1 info under /proc/socinfo
  OMAP3: export chip IDCODE, Production ID and Die ID

 Documentation/filesystems/proc.txt  |    1 +
 Documentation/kernel-parameters.txt |    2 +
 arch/arm/Kconfig                    |    1 +
 arch/arm/mach-omap1/id.c            |   45 +++++++++++++++++---
 arch/arm/mach-omap2/Kconfig         |   10 ++++
 arch/arm/mach-omap2/id.c            |   81 ++++++++++++++++++++++++++++++++---
 fs/proc/Kconfig                     |    7 +++
 fs/proc/Makefile                    |    1 +
 fs/proc/socinfo.c                   |   33 ++++++++++++++
 9 files changed, 169 insertions(+), 12 deletions(-)
 create mode 100644 fs/proc/socinfo.c

-------------------------------------------------------------------------------
[1] - http://www.mail-archive.com/linux-omap@vger.kernel.org/msg17553.html
[2] - http://marc.info/?l=linux-omap&m=127304890312365&w=2


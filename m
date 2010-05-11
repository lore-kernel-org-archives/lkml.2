Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab0EKOM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:12:58 -0400
Received: from smtp.nokia.com ([192.100.122.230]:41621 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104Ab0EKOMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:12:52 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
       Linux-OMAP <linux-omap@vger.kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       ext Tony Lindgren <tony@atomide.com>,
       ext Kevin Hilman <khilman@deeprootsystems.com>,
       Peter De-Schrijver <Peter.De-Schrijver@nokia.com>,
       santosh.shilimkar@ti.com, Ambresh <a0393775@ti.com>,
       felipe.balbi@nokia.com, Jouni Hogander <jouni.hogander@nokia.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv5 0/3] Introduce the /proc/socinfo and use it to export OMAP data
Date: Tue, 11 May 2010 17:15:28 +0300
Message-Id: <1273587331-24604-1-git-send-email-eduardo.valentin@nokia.com>
X-Mailer: git-send-email 1.7.0.4.361.g8b5fe.dirty
X-OriginalArrivalTime: 11 May 2010 14:12:05.0391 (UTC) FILETIME=[EF3D11F0:01CAF113]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Here is the version 5 of the change to export OMAP data to userspace
(name, revision, id code, production id and die id).

Basically, this version is still attempting to create a new file under /proc.
It is the /proc/socinfo, which should be used to export bits which are SoC specific
(not CPU related, nor machine related).

So, differences between previous version are:
- merged patch 02/04 with 03/04 to avoid compilation breakages.
- simplified the seq_file usage by using the single_open and single_release functions
- exported a function to register a seq_operation .show callback
- adapted the changes accordingly

As usual, comments are welcome.

BR,

-------------------------------------------------------------------------------
v4:

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
v3:
I'm resending this series with minor change in the subject prefix of patch 4/4.
Removed the PM: prefix. Everything else is same. So, I kept the v3 prefix as well.

And now v3 of this series. Basically a minor change wrt string manipulation.
No need to use strlen in so many places. Previous log for reference:

-------------------------------------------------------------------------------
v2:

Here is the version 2 of this series. Now die id is protected using
same x86 protection mechanism to hide x86 product number. Besides,
a compilation Kconfig option has been added for DIE ID as well.

Here is previous PATCH 0/4 message:

-------------------------------------------------------------------------------
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

-------------------------------------------------------------------------------
BR,

Eduardo Valentin (3):
  procfs: Introduce socinfo under /proc
  OMAP: export OMAP info under /proc/socinfo
  OMAP3: export chip IDCODE, Production ID and Die ID

 Documentation/filesystems/proc.txt  |    1 +
 Documentation/kernel-parameters.txt |    2 +
 arch/arm/Kconfig                    |    1 +
 arch/arm/mach-omap1/id.c            |   31 ++++++++++---
 arch/arm/mach-omap2/Kconfig         |   10 ++++
 arch/arm/mach-omap2/id.c            |   65 +++++++++++++++++++++++++---
 fs/proc/Kconfig                     |    7 +++
 fs/proc/Makefile                    |    1 +
 fs/proc/socinfo.c                   |   80 +++++++++++++++++++++++++++++++++++
 include/linux/socinfo.h             |   17 +++++++
 10 files changed, 202 insertions(+), 13 deletions(-)
 create mode 100644 fs/proc/socinfo.c
 create mode 100644 include/linux/socinfo.h


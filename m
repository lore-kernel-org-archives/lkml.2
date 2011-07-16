Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab1GPWbn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 18:31:43 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:34460 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab1GPWbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 18:31:40 -0400
Date: Sat, 16 Jul 2011 18:31:23 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] ACPI patches for 3.0.0-rc7
Message-id: <alpine.LFD.2.02.1107161829450.11045@x980>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="8323328-652834494-1310855484=:11045"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-652834494-1310855484=:11045
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This will update the files shown below.

thanks!

Len Brown
Intel Open Source Technology Center

 drivers/acpi/apei/hest.c        |   12 +++++++++++-
 drivers/acpi/osl.c              |   17 -----------------
 include/acpi/acpi_bus.h         |    2 +-
 include/acpi/acpiosxf.h         |    3 +++
 include/acpi/platform/aclinux.h |   18 ++++++++++++++++++
 5 files changed, 33 insertions(+), 19 deletions(-)

through these commits:

Huang Ying (1):
      ACPI, APEI, HEST, Detect duplicated hardware error source ID

Lin Ming (1):
      ACPI: Fixes device power states array overflow

Rafael J. Wysocki (1):
      ACPI: Fix lockdep false positives in acpi_power_off()

with this log:

commit 7fb574a97f7147610c44cef55d0cde2409392a80
Merge: b4a03b9 4d2b295 07e49a7
Author: Len Brown <len.brown@intel.com>
Date:   Thu Jul 14 00:16:38 2011 -0400

    Merge branches 'd3cold', 'bugzilla-37412' and 'bugzilla-38152' into release

commit b4a03b9aa96cc186bf3cfd7a55cb7d7227f0cf4d
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Wed Jun 1 23:54:02 2011 +0800

    ACPI: Fixes device power states array overflow
    
    Commit 28c2103 added new state ACPI_STATE_D3_COLD, so the device power
    states array must be expanded by one also.
    
    v2: Use ACPI_D_STATE_COUNT instead of number 5 for the array size.
    
    Reported-by: Dan Carpenter <error27@gmail.com>
    Suggested-by: Oldøich Jedlièka <oldium.pro@seznam.cz>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4d2b2956ef1113f1cc43e98e947c20d9c7d2712c
Author: Huang Ying <ying.huang@intel.com>
Date:   Wed Jul 13 13:14:12 2011 +0800

    ACPI, APEI, HEST, Detect duplicated hardware error source ID
    
    The firmware on some machine will report duplicated hardware error
    source ID in HEST.  This is considered a firmware bug.  To provide
    better warning message, this patch adds duplicated hardware error
    source ID detecting and corresponding printk.
    
    This patch fixes #37412 on kernel bugzilla:
    https://bugzilla.kernel.org/show_bug.cgi?id=37412
    
    Reported-by: marconifabio@ubuntu-it.org
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Tested-by: Mathias <janedo.spam@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 07e49a7a31153a95caa270d8ad7350a0bcd4d511
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Wed Jul 6 20:44:25 2011 +0200

    ACPI: Fix lockdep false positives in acpi_power_off()
    
    All ACPICA locks are allocated by the same function,
    acpi_os_create_lock(), with the help of a local variable called
    "lock".  Thus, when lockdep is enabled, it uses "lock" as the
    name of all those locks and regards them as instances of the same
    lock, which causes it to report possible locking problems with them
    when there aren't any.
    
    To work around this problem, define acpi_os_create_lock() as a macro
    and make it pass its argument to spin_lock_init(), so that lockdep
    uses it as the name of the new lock.  Define this macron in a
    Linux-specific file, to minimize the resulting modifications of
    the OS-independent ACPICA parts.
    
    This change is based on an earlier patch from Andrea Righi and it
    addresses a regression from 2.6.39 tracked as
    https://bugzilla.kernel.org/show_bug.cgi?id=38152
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Reported-and-tested-by: Borislav Petkov <bp@alien8.de>
    Tested-by: Andrea Righi <andrea@betterlinux.com>
    Reviewed-by: Florian Mickler <florian@mickler.org>
    Signed-off-by: Len Brown <len.brown@intel.com>
--8323328-652834494-1310855484=:11045--

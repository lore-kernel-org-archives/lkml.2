Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab0FDT45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 15:56:57 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:60310 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab0FDT44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 15:56:56 -0400
Date: Fri, 04 Jun 2010 15:56:51 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [git pull request] ACPI patches for 2.6.35-rc1
Message-id: <alpine.LFD.2.00.1006041553380.4073@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This includes one rc1 regression fix,
plus a couple of fixes that I should have included in the merge window.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.35/acpi-release-20100428-2.6.35-rc1.diff.gz

 Documentation/feature-removal-schedule.txt |    9 ----
 drivers/acpi/ec.c                          |   22 ++++++++---
 drivers/acpi/internal.h                    |    5 +-
 drivers/acpi/processor_idle.c              |   17 +++-----
 drivers/acpi/sleep.c                       |   57 ++++++++++++++-------------
 5 files changed, 55 insertions(+), 55 deletions(-)

through these commits:

Len Brown (1):
      ACPI: update feature-removal.txt to reflect deleted acpi=ht option

Rafael J. Wysocki (2):
      ACPI / EC / PM: Fix race between EC transactions and system suspend
      ACPI / EC / PM: Fix names of functions that block/unblock EC transactions

Venkatesh Pallipadi (1):
      ACPI: Eliminate us to pm ticks conversion in common path

Zhao Yakui (1):
      ACPI: Fix the incorrect calculation about C-state idle time

with this log:

commit 85f1bb4ace038289d587bcff64128be10613f9f3
Merge: b42f5b0 bceefad
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jun 4 15:23:02 2010 -0400

    Merge branch 'acpi-idle' into release

commit bceefad59ab66d1b1a815a1738744ea013da966e
Author: Venkatesh Pallipadi <venki@google.com>
Date:   Wed Jun 2 10:01:09 2010 -0700

    ACPI: Eliminate us to pm ticks conversion in common path
    
    acpi_enter_[simple|bm] routines does us to pm tick conversion on every
    idle wakeup and the value is only used in /proc/acpi display. We can
    store the time in us and convert it into pm ticks before printing instead and
    avoid the conversion in the common path.
    
    Signed-off-by: Venkatesh Pallipadi <venki@google.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 157317ba3ec3e5a4d9683b8d24ba40b4f8f3296b
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Wed Jun 2 11:04:09 2010 +0800

    ACPI: Fix the incorrect calculation about C-state idle time
    
    The C-state idle time is not calculated correctly, which will return the wrong
    residency time in C-state. It will have the following effects:
       1.  The system can't choose the deeper C-state when it is idle next time.
    Of course the system power is increased. E.g. On one server machine about 40W
    idle power is increased.
       2.  The powertop shows that it will stay in C0 running state about 95% time
    although the system is idle at most time.
    
    2.6.35-rc1 regression caused-by: 2da513f582a96c053aacc2c92873978d2ea7abff
    (ACPI: Minor cleanup eliminating redundant PMTIMER_TICKS to NS conversion)
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Reported-by: Yu Zhidong <zhidong.yu@intel.com>
    Tested-by: Yu Zhidong <zhidong.yu@intel.com>
    Acked-by: Venkatesh Pallipadi <venki@google.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b42f5b0f0fd8c1c442c1b29a3fbcb338e8bd7732
Merge: fe95568 0a76a34
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jun 1 22:53:36 2010 -0400

    Merge branches 'bugzilla-14668' and 'misc-2.6.35' into release

commit 0a76a34ff0804f1f413807b2e2d12117c2b602ca
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jun 1 12:13:23 2010 -0400

    ACPI: update feature-removal.txt to reflect deleted acpi=ht option
    
    Per plan, acpi=ht was removed in 2.6.35-rc1.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fe955682d2153b35dffcf1673dff0491096a3f0a
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Apr 9 01:40:38 2010 +0200

    ACPI / EC / PM: Fix names of functions that block/unblock EC transactions
    
    The names of the functions used for blocking/unblocking EC
    transactions during suspend/hibernation suggest that the transactions
    are suspended and resumed by them, while in fact they are disabled
    and enabled.  Rename the functions (and the flag used by them) to
    better reflect what they really do.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d5a64513c6a171262082c250592c062e97a2c693
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Apr 9 01:39:40 2010 +0200

    ACPI / EC / PM: Fix race between EC transactions and system suspend
    
    There still is a race that may result in suspending the system in
    the middle of an EC transaction in progress, which leads to problems
    (like the kernel thinking that the ACPI global lock is held during
    resume while in fact it's not).
    
    To remove the race condition, modify the ACPI platform suspend and
    hibernate callbacks so that EC transactions are blocked right after
    executing the _PTS global control method and are allowed to happen
    again right after the low-level wakeup.
    
    Introduce acpi_pm_freeze() that will disable GPEs, wait until the
    event queues are empty and block EC transactions.  Use it wherever
    GPEs are disabled in preparation for switching local interrupts off.
    Introduce acpi_pm_thaw() that will allow EC transactions to happen
    again and enable runtime GPEs.  Use it to balance acpi_pm_freeze()
    wherever necessary.
    
    In addition to that use acpi_ec_resume_transactions_early() to
    unblock EC transactions as early as reasonably possible during
    resume.  Also unblock EC transactions in acpi_hibernation_finish()
    and in the analogous suspend routine to make sure that the EC
    transactions are enabled in all error paths.
    
    Fixes https://bugzilla.kernel.org/show_bug.cgi?id=14668
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Reported-and-tested-by: Maxim Levitsky <maximlevitsky@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

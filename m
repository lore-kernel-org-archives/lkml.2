Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597Ab2K0KMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 05:12:55 -0500
Received: from goliath.siemens.de ([192.35.17.28]:24292 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933401Ab2K0KMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 05:12:50 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fenghua Yu <fenghua.yu@intel.com>, Kay Sievers <kay@vrfy.org>,
        linux-ia64@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, sparclinux@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 00/13] Add gdb python scripts as kernel debugging helpers
Date: Tue, 27 Nov 2012 11:11:31 +0100
Message-Id: <cover.1354011091.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is version 3 of my gdb helper scripts. Changes in this release are
related to improving compatibility with older gdb versions (down to 7.1)
and the with latest one (7.5). Also, proper reloading of updated kernel
and module symbols was implemented.

Andrew, I got the suggestion to pass these patches through your hands.
Could you take them?


Here is the original intro for reference:

This adds the infrastructure and first tools that make kernel debugging
through gdb more comfortable. Since 7.0, gdb supports python scripting.
And this opens the doors to automate steps like the tedious loading of
module symbols at the right address, resolving per-cpu variables or even
retrieving the current kernel log without resuming an stopped target.

Many of the helpers naturally depend on the layout of structures or
internal mechanics of the kernel. So the best place to maintain such
things, keeping them consistent with the corresponding kernel is, well,
the kernel itself.

While these scripts have been originally developed for debugging via
QEMU/KVM, I've now also added the required bits for KGDB. Works fine,
but as QEMU/KVM tends to outperform KGDB it remains the recommendation
- when available.

There are two architecture dependencies so far, one regarding per-cpu,
the other regarding thread_info calculation. None of them I was able to
test on a target, so I'm counting on review/testing by the corresponding
communities.

This series should be considered the foundation of much more kernel
state exploration helpers, e.g. around tasks, timers, locks, sockets -
I guess people will have even more ideas.

Hope it's useful!

PS: Also available via git://git.kiszka.org/linux.git queues/gdb-scripts

CC: "David S. Miller" <davem@davemloft.net>
CC: Fenghua Yu <fenghua.yu@intel.com>
CC: Kay Sievers <kay@vrfy.org>
CC: linux-ia64@vger.kernel.org
CC: linux-kbuild@vger.kernel.org
CC: Michal Marek <mmarek@suse.cz>
CC: sparclinux@vger.kernel.org
CC: Tony Luck <tony.luck@intel.com>

Jan Kiszka (13):
  scripts/gdb: Add infrastructure
  scripts/gdb: Add container_of helper and convenience function
  scripts/gdb: Add lx-symbols command
  scripts/gdb: Add get_target_endianness helper
  scripts/gdb: Add read_u16/32/64 helpers
  scripts/gdb: Add lx-dmesg command
  scripts/gdb: Add task iteration helper
  scripts/gdb: Add helper and convenience function to look up tasks
  scripts/gdb: Add is_target_arch helper
  scripts/gdb: Add internal helper and convenience function to retrieve
    thread_info
  scripts/gdb: Add get_gdbserver_type helper
  scripts/gdb: Add internal helper and convenience function for per-cpu
    lookup
  scripts/gdb: Add lx_current convenience function

 Makefile                   |    5 +-
 scripts/Makefile           |    3 +-
 scripts/gdb/Makefile       |    9 +++
 scripts/gdb/dmesg.py       |   63 ++++++++++++++++++
 scripts/gdb/percpu.py      |   76 +++++++++++++++++++++
 scripts/gdb/symbols.py     |  155 ++++++++++++++++++++++++++++++++++++++++++++
 scripts/gdb/task.py        |  108 ++++++++++++++++++++++++++++++
 scripts/gdb/utils.py       |  137 ++++++++++++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |   28 ++++++++
 9 files changed, 582 insertions(+), 2 deletions(-)
 create mode 100644 scripts/gdb/Makefile
 create mode 100644 scripts/gdb/dmesg.py
 create mode 100644 scripts/gdb/percpu.py
 create mode 100644 scripts/gdb/symbols.py
 create mode 100644 scripts/gdb/task.py
 create mode 100644 scripts/gdb/utils.py
 create mode 100644 scripts/gdb/vmlinux-gdb.py

-- 
1.7.3.4


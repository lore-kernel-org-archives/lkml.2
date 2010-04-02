Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab0DBGRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 02:17:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:51906 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758028Ab0DBGRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 02:17:36 -0400
Message-ID: <4BB58BCE.8090106@kernel.org>
Date: Fri, 02 Apr 2010 15:16:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: lkml <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dimitri Sivanich <sivanich@sgi.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, dipankar@in.ibm.com,
       josh@freedesktop.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] sched/core: implement and cpuhog
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 06:16:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Can you please pull from the following git tree into sched/core to
receive cpuhog patches?

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git cpuhog

Both sched/core and the patches remained the same from the second
take[2].  Rusty Russell acked stop_machine changes and Oleg likes the
changes.

Peter agrees with the mechanics but is unhappy with the naming and
suggests using stop_cpu/machine() names instead.  Currently, visible
API is

* hog_one_cpu()
* hog_cpus()
* [__]stop_machine()

IIUC, Peter is suggesting something like (please feel free to correct
if I got it wrong)

* stop_one_cpu()
* stop_cpus()
* [__]stop_machine()

The renaming shouldn't be difficult one way or the other but I think
hog is better because it better describes what the API does (it
doesn't really stop the cpu or cpus).  Please refer to the discussions
in the first take[1] and second take[2] for details.

The branch contains the following changes.

Tejun Heo (4):
      cpuhog: implement cpuhog
      stop_machine: reimplement using cpuhog
      scheduler: replace migration_thread with cpuhog
      scheduler: kill paranoia check in synchronize_sched_expedited()

 Documentation/RCU/torture.txt |   10 -
 arch/s390/kernel/time.c       |    1 -
 drivers/xen/manage.c          |   14 +--
 include/linux/cpuhog.h        |   24 +++
 include/linux/rcutiny.h       |    2 -
 include/linux/rcutree.h       |    1 -
 include/linux/stop_machine.h  |   20 ---
 kernel/Makefile               |    2 +-
 kernel/cpu.c                  |    8 -
 kernel/cpuhog.c               |  368 +++++++++++++++++++++++++++++++++++++++++
 kernel/module.c               |   14 +--
 kernel/rcutorture.c           |    2 +-
 kernel/sched.c                |  282 ++++++--------------------------
 kernel/sched_fair.c           |   39 +++--
 kernel/stop_machine.c         |  162 +++++--------------
 15 files changed, 511 insertions(+), 438 deletions(-)
 create mode 100644 include/linux/cpuhog.h
 create mode 100644 kernel/cpuhog.c

Thanks.

-- 
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/958743
[2] http://thread.gmane.org/gmane.linux.kernel/962635

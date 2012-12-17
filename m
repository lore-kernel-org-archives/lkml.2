Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab2LQTRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:17:31 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:38848 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab2LQTR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:17:29 -0500
Message-ID: <50CF6FC5.20005@kernel.org>
Date: Mon, 17 Dec 2012 14:17:25 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] power tools for Linux-3.8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these power tools patches.
This updates the tree w/ the latest version of turbostat,
which reports temperature and - on SNB and later - Watts.

There will be a logical conflict with the uapi changes
which breaks the turbostat build.  It can be fixed this way:

diff --git a/tools/power/x86/turbostat/Makefile b/tools/power/x86/turbostat/Makefile
index e48ef07..f09641d 100644
--- a/tools/power/x86/turbostat/Makefile
+++ b/tools/power/x86/turbostat/Makefile
@@ -5,7 +5,7 @@ DESTDIR         :=
 
 turbostat : turbostat.c
 CFLAGS +=      -Wall
-CFLAGS +=      -I../../../../arch/x86/include/
+CFLAGS +=      -I../../../../arch/x86/include/uapi/


thanks!
Len Brown, Intel Open Source Technology Center


The following changes since commit d91bb17c2a874493603c4d99db305d8caf2d180c:

  tools/power turbostat: graceful fail on garbage input (2012-11-01 00:22:00 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git next

for you to fetch changes up to 55f1f545f709a6023371848028a3029118855576:

  tools: Allow tools to be installed in a user specified location (2012-11-30 01:09:45 -0500)

----------------------------------------------------------------
Colin Ian King (1):
      tools/power x86_energy_perf_policy: close /proc/stat in for_every_cpu()

Josh Boyer (1):
      tools: Allow tools to be installed in a user specified location

Len Brown (5):
      tools/power/x86/turbostat: share kernel MSR #defines
      x86 power: define RAPL MSRs
      tools/power turbostat: prevent infinite loop on migration error path
      tools/power turbostat: fix output buffering issue
      tools/power turbostat: v3.0: monitor Watts and Temperature

Mark Asselstine (1):
      tools/power: turbostat: make Makefile a bit more capable

 arch/x86/include/asm/msr-index.h                   |  37 ++
 tools/power/x86/turbostat/Makefile                 |  21 +-
 tools/power/x86/turbostat/turbostat.8              | 103 ++--
 tools/power/x86/turbostat/turbostat.c              | 677 +++++++++++++++++++--
 tools/power/x86/x86_energy_perf_policy/Makefile    |   6 +-
 .../x86_energy_perf_policy.c                       |   2 +-
 6 files changed, 765 insertions(+), 81 deletions(-)

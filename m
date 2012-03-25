Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab2CYSjw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 14:39:52 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:34979 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756736Ab2CYSju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 14:39:50 -0400
Date: Sun, 25 Mar 2012 20:38:07 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: [git pull] cpupowerutils updates for 3.4
Message-ID: <20120325183807.GA26398@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	torvalds@osdl.org, linux-kernel@vger.kernel.org,
	cpufreq@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

a few cpupower updates for 3.4 are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/cpupowerutils.git master

Please pull from that location. The diffstat and list of changes is below,
the individual diffs are sent (at least) to the cpufreq list.

Thanks,
        Dominik

Franck Bui-Huu (5):
      cpupower tool: remove use of undefined variables from the clean target of the top makefile
      cpupower tool: makefile: simplify the recipe used to generate cpupower.pot target
      cpupower tool: allow to build in a separate directory
      cpupower tools: allow to build debug tools in a separate directory too
      cpupower tools: add install target to the debug tools' makefiles

Ozan Çağlayan (1):
      cpupower: Fix linking with --as-needed

Thomas Renninger (7):
      cpupower: Better interface for accessing AMD pci registers
      cpupower: AMD fam14h/Ontario monitor can also be used by fam12h cpus
      cpupower: Add cpupower-idle-info manpage
      cpupower: Unify cpupower-frequency-* manpages
      cpupower: Fix number of idle states
      cpupower: Remove unneeded code and by that fix a memleak
      cpupower: Fix broken mask values

 tools/power/cpupower/Makefile                      |   93 ++++++++++++--------
 tools/power/cpupower/bench/Makefile                |   23 +++--
 tools/power/cpupower/debug/i386/Makefile           |   40 ++++++---
 tools/power/cpupower/debug/x86_64/Makefile         |   26 +++++-
 tools/power/cpupower/man/cpupower-frequency-info.1 |    4 +-
 tools/power/cpupower/man/cpupower-frequency-set.1  |    4 +-
 tools/power/cpupower/man/cpupower-idle-info.1      |   90 +++++++++++++++++++
 tools/power/cpupower/man/cpupower-monitor.1        |    2 +-
 tools/power/cpupower/utils/cpuidle-info.c          |   12 +--
 tools/power/cpupower/utils/helpers/amd.c           |    4 +-
 tools/power/cpupower/utils/helpers/helpers.h       |   11 ++-
 tools/power/cpupower/utils/helpers/pci.c           |   35 +++++---
 .../cpupower/utils/idle_monitor/amd_fam14h_idle.c  |   25 +++---
 13 files changed, 259 insertions(+), 110 deletions(-)
 create mode 100644 tools/power/cpupower/man/cpupower-idle-info.1

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab2J2D51 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 23:57:27 -0400
Received: from mga14.intel.com ([143.182.124.37]:33739 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab2J2D50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 23:57:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,669,1344236400"; 
   d="scan'208";a="210544396"
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH v5 0/8] perf tools: Add script browser and runtime data file switch 
Date: Tue, 30 Oct 2012 11:56:01 +0800
Message-Id: <1351569369-26732-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and all,

This patch set make 2 changes to perf tool:
1. Add a browser for perf script, which will be integrated into the
main hists and annotation browser.
2. Add the inital support for runtime perf data file switch in the
'perf report' window.

Patch 1    Add the global variable "input_name"
patch 2-5  Introduce the script browser and integrate it to
           hists/annotation browser
patch 6-8  Add the runtime data file switch for 'perf report' 

The patches are on top of current perf/core branch of your git tree. 
Please help to review. 

Thanks to Andi/Arnaldo/Namhyung for the great suggestions/reviews.

Changelog:
	Since v4:
	* Rebase againt post-3.7 ACME's perf tree
	
	Since v3:
	* Fix memory leak for input_name
	* Add return value check for strdup
	* Fix some small bugs in scripts browser

	Since v2:
	* add more filter to find_scripts()
	* add runtime data file switch for 'perf report'
	* emphasize the script browser doesn't cover 'record'
	  in commit log
	
	Since v1:
	* Add filter for scripts can't be run in script browser
	* Fix some bugs about buffer handling and error check 

Thanks,
Feng

--------------

Feng Tang (8):
  perf tool: Add a global variable "const char *input_name"
  perf script: Add more filter to find_scripts()
  perf ui/browser: Add a browser for perf script
  perf ui/browser: Integrate script browser into annotation browser
  perf ui/browser: Integrate script browser into main hists browser
  perf header: Add is_perf_magic() func
  perf hists browser: Add option for runtime switching perf data file
  perf report: Enable the runtime switching of perf data file

 tools/perf/Makefile               |    4 +
 tools/perf/builtin-annotate.c     |    5 +-
 tools/perf/builtin-buildid-list.c |    6 +-
 tools/perf/builtin-evlist.c       |    5 +-
 tools/perf/builtin-kmem.c         |    5 +-
 tools/perf/builtin-lock.c         |    2 -
 tools/perf/builtin-report.c       |   31 ++++--
 tools/perf/builtin-sched.c        |    5 +-
 tools/perf/builtin-script.c       |   83 +++++++++++++++-
 tools/perf/builtin-timechart.c    |    5 +-
 tools/perf/perf.c                 |    1 +
 tools/perf/perf.h                 |    1 +
 tools/perf/ui/browsers/annotate.c |    6 ++
 tools/perf/ui/browsers/hists.c    |  142 ++++++++++++++++++++++++++++
 tools/perf/ui/browsers/scripts.c  |  189 +++++++++++++++++++++++++++++++++++++
 tools/perf/ui/keysyms.h           |    1 +
 tools/perf/util/header.c          |   10 ++
 tools/perf/util/header.h          |    1 +
 tools/perf/util/hist.h            |    7 ++
 19 files changed, 475 insertions(+), 34 deletions(-)
 create mode 100644 tools/perf/ui/browsers/scripts.c

-- 
1.7.9.5


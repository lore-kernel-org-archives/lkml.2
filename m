Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab2IXPab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:30:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:23562 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756387Ab2IXPa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:30:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,476,1344236400"; 
   d="scan'208";a="196413125"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH v3 0/9] perf tools: Add script browser and runtime data file switch 
Date: Mon, 24 Sep 2012 23:24:02 +0800
Message-Id: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and all,

This is a patch set mainly to add a browser for perf script, which
will be integrated into the main hists and annotation browser. It
also add the inital support for runtime perf data file switch in the
'perf report' window.

Patch 1    is a simple cleanup not related with the main part
Patch 2    add the global variable "input_name"
patch 3-6  introduce the script browser and integrate it to
           hists/annotation browser
patch 7-9  add the runtime data file switch for 'perf report' 

The patches are on top of current perf/core branch of your git tree. 
Please help to review. 

Thanks to Andi/Arnaldo/Namhyung for the great suggestions/reviews.


Changelog:
	Since v2:
	* add more filter to find_scripts()
	* add runtime data file switch for 'perf report'
	* emphasize the script browser doesn't cover 'record'
	  in commit log
	
	Since v1:
	* Add filter for scripts can't be run in script browser
	* Fix some bugs about buffer handling and error check 

Feng
----------------------
Feng Tang (9):
  perf hists: Move hists_init() from util/evsel.c to util/hist.c
  perf tool: Add a global variable "const char *input_name"
  perf script: Add more filter to find_scripts()
  perf ui/browser: Add a browser for perf script
  perf ui/browser: Integrate script browser into annotation browser
  perf ui/browser: Integrate script browser into main hists browser
  perf header: Add check_perf_magic() func
  perf hists browser: Add option for runtime switching perf data file
  perf report: Enable the runtime switching of perf data file

 tools/perf/Makefile               |    4 +
 tools/perf/builtin-annotate.c     |    5 +-
 tools/perf/builtin-buildid-list.c |    1 -
 tools/perf/builtin-evlist.c       |    5 +-
 tools/perf/builtin-inject.c       |    3 +-
 tools/perf/builtin-kmem.c         |    2 -
 tools/perf/builtin-lock.c         |    2 -
 tools/perf/builtin-report.c       |   31 +++++--
 tools/perf/builtin-sched.c        |    5 +-
 tools/perf/builtin-script.c       |   78 +++++++++++++++-
 tools/perf/builtin-timechart.c    |    2 -
 tools/perf/perf.c                 |    1 +
 tools/perf/perf.h                 |    1 +
 tools/perf/ui/browsers/annotate.c |    6 +
 tools/perf/ui/browsers/hists.c    |  110 ++++++++++++++++++++++
 tools/perf/ui/browsers/scripts.c  |  182 +++++++++++++++++++++++++++++++++++++
 tools/perf/ui/keysyms.h           |    1 +
 tools/perf/util/evsel.c           |   10 --
 tools/perf/util/evsel.h           |    2 -
 tools/perf/util/header.c          |   11 ++
 tools/perf/util/header.h          |    1 +
 tools/perf/util/hist.c            |   10 ++
 tools/perf/util/hist.h            |    8 ++
 23 files changed, 437 insertions(+), 44 deletions(-)
 create mode 100644 tools/perf/ui/browsers/scripts.c


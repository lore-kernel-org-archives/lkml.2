Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab2I1IhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:37:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:21636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab2I1IhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:37:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,501,1344236400"; 
   d="scan'208";a="150188583"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH v4 0/8] perf tools: Add script browser and runtime data file switch 
Date: Fri, 28 Sep 2012 16:30:32 +0800
Message-Id: <1348821040-9724-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and all,

This is a patch set mainly to add a browser for perf script, which
will be integrated into the main hists and annotation browser. It
also add the inital support for runtime perf data file switch in the
'perf report' window.

Patch 1    Add the global variable "input_name"
patch 2-5  Introduce the script browser and integrate it to
           hists/annotation browser
patch 6-8  Add the runtime data file switch for 'perf report' 

The patches are on top of current perf/core branch of your git tree. 
Please help to review. 

Thanks to Andi/Arnaldo/Namhyung for the great suggestions/reviews.

Changelog:
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
 tools/perf/builtin-buildid-list.c |    1 -
 tools/perf/builtin-evlist.c       |    5 +-
 tools/perf/builtin-inject.c       |    3 +-
 tools/perf/builtin-kmem.c         |    2 -
 tools/perf/builtin-lock.c         |    2 -
 tools/perf/builtin-report.c       |   31 +++++--
 tools/perf/builtin-sched.c        |    5 +-
 tools/perf/builtin-script.c       |   84 +++++++++++++++-
 tools/perf/builtin-timechart.c    |    2 -
 tools/perf/perf.c                 |    1 +
 tools/perf/perf.h                 |    1 +
 tools/perf/ui/browsers/annotate.c |    6 +
 tools/perf/ui/browsers/hists.c    |  142 ++++++++++++++++++++++++++++
 tools/perf/ui/browsers/scripts.c  |  189 +++++++++++++++++++++++++++++++++++++
 tools/perf/ui/keysyms.h           |    1 +
 tools/perf/util/header.c          |   10 ++
 tools/perf/util/header.h          |    1 +
 tools/perf/util/hist.h            |    7 ++
 20 files changed, 470 insertions(+), 32 deletions(-)
 create mode 100644 tools/perf/ui/browsers/scripts.c


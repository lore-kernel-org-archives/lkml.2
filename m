Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab2IGIsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 04:48:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:28377 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066Ab2IGIsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:48:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,384,1344236400"; 
   d="scan'208";a="219252864"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH v2 0/7] perf ui/browser: Add browser for perf script 
Date: Fri,  7 Sep 2012 16:42:22 +0800
Message-Id: <1347007349-3102-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and all,

This is a patch set mainly to add a browser for perf script, which
will be integrated into the main hists and annotation browser.

Patch 1-4 are some preparation for adding the script
patch 5 introduce the script browser
patch 6-7 integrate the browser to hists browser and annotation browser

The patches are on top of current perf/core branch of your git tree. 
Please help to review. 

Namhyung,

Many thanks for providing many good comments for the v1 patch sets. In
this v2, I addressed most of those comments, for the suggestion to use
browser for "perf script -l", I'll handle it later, and would post the
v2 first for review.

Changelog:
	Since v1:
	* Add filter for scripts can't be run in script browser
	* Fix some bugs about buffer handling and error check 

Feng
-----------------------
Feng Tang (7):
  perf symbols: Filter samples with unresolved symbol when "--symbols"
    option is used
  perf scripts: Add --symbols option to handle specific symbols
  perf scripts: Add event_analyzing_sample-record/report
  perf scripts: Export a find_scripts() function
  perf ui/browser: Add a browser for perf script
  perf ui/browser: Integrate script browser into annotation browser
  perf ui/browser: Integrate script browser into main hists browser

 tools/perf/Makefile                                |    4 +
 tools/perf/builtin-script.c                        |   58 ++++++
 tools/perf/builtin.h                               |    1 +
 .../python/bin/event_analyzing_sample-record       |    8 +
 .../python/bin/event_analyzing_sample-report       |    3 +
 tools/perf/ui/browsers/annotate.c                  |    6 +
 tools/perf/ui/browsers/hists.c                     |   37 ++++
 tools/perf/ui/browsers/scripts.c                   |  182 ++++++++++++++++++++
 tools/perf/util/event.c                            |    5 +-
 tools/perf/util/hist.h                             |    7 +
 10 files changed, 309 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/scripts/python/bin/event_analyzing_sample-record
 create mode 100644 tools/perf/scripts/python/bin/event_analyzing_sample-report
 create mode 100644 tools/perf/ui/browsers/scripts.c


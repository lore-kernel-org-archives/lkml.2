Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab2FRGOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:14:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:47903 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab2FRGOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:14:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="181384459"
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Robert Richter <robert.richter@amd.com>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>, Feng Tang <feng.tang@intel.com>
Subject: [PATCH v3 0/3] perf script: Add general event support to event handler of python script 
Date: Mon, 18 Jun 2012 14:10:36 +0800
Message-Id: <1339999839-14007-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current python script can only handle trace point type of events, this
patch serie try to follow Robert Richter's idea in commit 37a058ea0
	"perf script: Add generic perl handler to process events"
to similarly add a python handler for general events other than
tracepoints.

Please help to revew, thanks.

- Feng


Change logs:
	Since v2:
	* Correct some __unused usage
	* Add a new parameter: event name to event handler 

	Since v1:
	* Use dictory as the paramter passwd from c to python 
	* Use "process_event" name to comply with perl

----------------
Feng Tang (3):
  perf script: Add general python handler to process non-tracepoint
    events
  perf script: Replace "struct thread" with "struct addr_location" as a
    parameter for "process_event()"
  perf script/python: Pass event/thread/dso name and symbol info to
    event handler in python

 tools/perf/builtin-script.c                        |    5 +-
 .../perf/util/scripting-engines/trace-event-perl.c |   13 ++--
 .../util/scripting-engines/trace-event-python.c    |   81 +++++++++++++++++++-
 tools/perf/util/trace-event-scripting.c            |    2 +-
 tools/perf/util/trace-event.h                      |    4 +-
 5 files changed, 93 insertions(+), 12 deletions(-)


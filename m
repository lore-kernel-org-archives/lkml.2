Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259Ab2EDRLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 13:11:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759246Ab2EDRLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 13:11:46 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHv2 0/4] perf, tool: Fix endian issues
Date: Fri,  4 May 2012 19:11:29 +0200
Message-Id: <1336151493-8328-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
sending fixies to properly handle perf.data endians.

v2 changes:
  - added patches 3 and 4 to handle sample_id_all header endianity

Attached patches:
  1/4 perf, tool: Handle different endians properly during symbol load
  2/4 perf, tool: Carry perf_event_attr bitfield throught different endians
  3/4 perf, tool: Handle endianity swap on sample_id_all header data
  4/4 perf, tool: Fix 32 bit values endianity swap for sample_id_all header

thanks,
jirka
---
 tools/perf/util/evsel.c   |   32 +++++++++++---
 tools/perf/util/session.c |  101 +++++++++++++++++++++++++++++++++++++++-----
 tools/perf/util/symbol.c  |   33 ++++++++++++++-
 tools/perf/util/symbol.h  |   30 +++++++++++++
 4 files changed, 176 insertions(+), 20 deletions(-)

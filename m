Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab2EBCH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 22:07:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:46532 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556Ab2EBCHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 22:07:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="138970339"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, jolsa@redhat.com, ming.m.lin@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH V3 0/9] perf: Intel uncore pmu counting support
Date: Wed,  2 May 2012 10:07:11 +0800
Message-Id: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

Here is the V3 patches to add uncore counting support for Nehalem,
Sandy Bridge and Sandy Bridge-EP, applied on top of current tip.
The code is based on Lin Ming's old patches.

For Nehalem and Sandy Bridge-EP, A few general events are exported
under directory:
  /sys/bus/event_source/devices/${uncore_dev}/events/

Each file in the events directory defines an event. The content is
like:
  config=1,config1=2

You can use 'perf stat' to access to the uncore pmu. For example:
  perf stat -a -C 0 -e 'uncore_imc0/CAS_COUNT_RD/' sleep 1

Any comment is appreciated.
Thank you
---
Changes since v1:
 - Modify perf tool to parse events from sysfs
 - A few minor code cleanup

Changes since v2:
 - Place all events for a particular socket onto a single cpu
 - Make the events parser in perf tool reentrantable
 - A few code cleanup


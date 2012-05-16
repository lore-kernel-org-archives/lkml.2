Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967269Ab2EPFAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 01:00:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:40526 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967069Ab2EPFAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 01:00:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100616997"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, jolsa@redhat.com, ming.m.lin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH V4 0/10] perf: Intel uncore pmu counting support
Date: Wed, 16 May 2012 12:59:53 +0800
Message-Id: <1337144403-30841-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

Here is the V4 patches to add uncore counting support for Nehalem,
Sandy Bridge and Sandy Bridge-EP, applied on top of current tip.
The code is based on Lin Ming's old patches.

For Nehalem and Sandy Bridge-EP, A few general events are exported
under sysfs directory:
  /sys/bus/event_source/devices/${uncore_dev}/events/

Each file in the events directory defines an event. The content is
a string such as:
  config=1,config1=2

You can use 'perf stat' to access to the uncore pmu. For example:
  perf stat -a -C 0 -e 'Uncore_iMC_0/CAS_COUNT_RD/' sleep 1

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

Changes since v3:
 - Use per cpu pointer to track uncore box
 - Rework the cpu hotplug code because topology_physical_package_id()
   return wrong result when the cpu is offline
 - Rework the event alias code, event terms are stored in the alias
   structure instead events string



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab0HRH4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 03:56:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:46534 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab0HRH4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 03:56:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,226,1280732400"; 
   d="scan'208";a="546367199"
Subject: [RFC PATCH 0/3] perf: show package power consumption in perf
From: Zhang Rui <rui.zhang@intel.com>
To: peterz@infradead.org
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu, robert.richter@amd.com,
        acme@redhat.com, paulus@samba.org, dzickus@redhat.com,
        gorcunov@gmail.com, fweisbec@gmail.com,
        Lin Ming <ming.m.lin@intel.com>, "Brown, Len" <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 15:59:10 +0800
Message-ID: <1282118350.5181.115.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all,

RAPL(running average power limit) is a new feature which provides
mechanisms to enforce power consumption limit, on some new processors.

Generally speaking, by using RAPL, OS can set a power budget in a
certain time window, and let Hardware to throttle the processor
P/T-state to meet this energy limitation.

RAPL also provides a new MSR, i.e. MSR_PKG_ENERGY_STATUS, which reports
the total amount of energy consumed by the package.

I'm not sure if to support RAPL or not, but anyway, it sounds like a
good idea to export the energy status in perf.

So a new perf pmu and event to show the package energy consumed is
introduced in this patch.

Here is what I get after applying the three patches,

#./perf stat -e energy test
Performance counter stats for 'test':

	202	Joules cost by package
7.926001238	seconds time elapsed


Note that this patch set is made based on Peter's perf-pmu branch,
git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-perf.git
 which provides better interfaces to register/unregister a new pmu.

any comment are welcome. :)

thanks,
rui


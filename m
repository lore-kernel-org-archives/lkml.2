Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab0EQIR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 04:17:56 -0400
Received: from mga10.intel.com ([192.55.52.92]:34273 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753461Ab0EQIRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 04:17:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,246,1272870000"; 
   d="scan'208";a="799052565"
Message-ID: <4BF0FBB0.1080707@linux.intel.com>
Date: Mon, 17 May 2010 16:17:52 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 0/3] Fix boot_pageset sharing issue for new populated zones
 of hotadded nodes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In our recent cpu/memory hotadd testing, with multiple nodes hotadded,
kernel easily panics under stress workload like kernel building.

The root cause is that the new populated zones of hotadded nodes are
sharing same per_cpu_pageset, i.e. boot strapping boot_pageset, which
finally causes page state wrong.

The following three patches will setup the pagesets for hotadded nodes
with dynamically allocated per_cpu_pageset struct.

---
  include/linux/memory_hotplug.h |    8 +++++
  include/linux/mmzone.h         |    2 +-
  init/main.c                    |    2 +-
  mm/memory_hotplug.c            |   27 +++++++++++-----
  mm/page_alloc.c                |   66 +++++++++++++++++++++++++++-------------
  5 files changed, 74 insertions(+), 31 deletions(-)

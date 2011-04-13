Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab1DMIFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 04:05:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:57951 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756972Ab1DMIFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 04:05:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,203,1301900400"; 
   d="scan'208";a="908921314"
Message-Id: <20110413075715.090406229@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 13 Apr 2011 15:57:15 +0800
From: shaohua.li@intel.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, cl@linux.com, tj@kernel.org,
        eric.dumazet@gmail.com
Subject: [patch v2 0/4] percpu_counter: cleanup and fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup percpu_counter code and fix some bugs. The main purpose is to convert
percpu_counter to use atomic64, which is useful for workloads which cause
percpu_counter->lock contented. In a workload I tested, the atomic method is
50x faster (please see patch 4 for detail).

patch 1&2: clean up
patch 3: fix bug of percpu_counter for 32-bit systems.
patch 4: convert percpu_counter to use atomic64

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab1DNCHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 22:07:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:47076 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757398Ab1DNCHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 22:07:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,208,1301900400"; 
   d="scan'208";a="733085185"
Message-Id: <20110414020447.979946152@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 14 Apr 2011 10:04:47 +0800
From: shaohua.li@intel.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tj@kernel.org, cl@linux.com,
        eric.dumazet@gmail.com
Subject: [patch v3 0/3] percpu_counter: cleanup and fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup percpu_counter code and fix some bugs. The main purpose is to convert
percpu_counter to use atomic64, which is useful for workloads which cause
percpu_counter->lock contented. In a workload I tested, the atomic method is
7x faster (please see patch 3 for detail).

Note, patch 3 is against Christoph's 'percpu: preemptless __per_cpu_counter_add'

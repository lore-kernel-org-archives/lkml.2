Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab1DZJvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 05:51:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:46561 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab1DZJvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 05:51:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,267,1301900400"; 
   d="scan'208";a="634172776"
Message-Id: <20110426094352.030753173@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 26 Apr 2011 17:43:52 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Tim Chen <tim.c.chen@intel.com>
cc: Li Shaohua <shaohua.li@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 0/3] reduce readahead overheads on tmpfs mmap page faults
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This kills unnessesary ra->mmap_miss and ra->prev_pos updates on every page
fault when the readahead is disabled.

They fix the cache line bouncing problem in the mosbench exim benchmark, which
does multi-threaded page faults on shared struct file on tmpfs.

Thanks,
Fengguang


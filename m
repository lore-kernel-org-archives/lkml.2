Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab0ERXgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 19:36:09 -0400
Received: from mga05.intel.com ([192.55.52.89]:50292 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752708Ab0ERXgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 19:36:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,258,1272870000"; 
   d="scan'208";a="799692257"
Subject: [PATCH 0/2] tmpfs: Improve tmpfs scalability
From: tim <tim.c.chen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 16:34:26 -0700
Message-ID: <1274225666.31973.8949.camel@mudge.jf.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We created a token jar library implementing
per cpu cache of tokens to avoid lock contentions whenever
we retrieve or return a token to a token jar.  Using this library
with tmpfs, we find Aim7 fserver throughput improved 270% 
on a 4 socket, 32 cores NHM-EX system.

In current implementation of tmpfs, whenever we
get a new page, stat_lock in shmem_sb_info needs to be acquired.  
This causes a lot of lock contentions when multiple
threads are using tmpfs simultaneously, which makes
system with large number of cpus scale poorly.
Almost 75% of cpu time was spent contending on
stat_lock when we ran Aim7 fserver load with 128 threads
on a 4 socket, 32 cores NHM-EX system.

The first patch in the series implements the quick token jar. 
The second patch update the shmem code of tmpfs to use this
library to improve tmpfs performance.

Regards,
Tim Chen 


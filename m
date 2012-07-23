Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab2GWG5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 02:57:25 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60081 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab2GWG5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 02:57:24 -0400
Subject: [RFC PATCH 0/1] sched: Add a new API to find the prefer idlest cpu
From: Shirley Ma <mashirle@us.ibm.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, vivek@us.ibm.com, sri@us.ibm.com
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Jul 2012 23:57:14 -0700
Message-ID: <1343026634.13461.15.camel@oc3660625478.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072306-7606-0000-0000-00000233C374
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new API to choose per-cpu thread from cgroup control cpuset
(allowed) and preferred cpuset (local numa-node).

The receiving cpus of a networking device are not under cgroup controls.
When such a networking device uses per-cpu thread model, the cpu which
is chose to process the packets might not be part of cgroup cpusets
without this API. On numa system, the preferred cpusets would help to
reduce expensive cross memory access to/from the other node.

Signed-off-by: Shirley Ma <xma@us.ibm.com>
---

 include/linux/sched.h |    2 ++
 kernel/sched/fair.c   |   30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 0 deletions(-)

Thanks
Shirley




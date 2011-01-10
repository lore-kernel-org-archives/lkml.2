Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab1AJFOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 00:14:54 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:36715 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1AJFOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 00:14:53 -0500
Date: Mon, 10 Jan 2011 10:44:45 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -tip 0/2] sched: Get group names back in /proc/sched_debug
Message-ID: <20110110051445.GB2772@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With autogroup patches, the group names got dropped off from
/proc/sched_debug. Without group name info, it is difficult to figure out
which cfs_rq or task belongs to which group in /proc/sched_debug output.

This patchset brings back the group name and also adds autogroup names
to /proc/sched_debug output.

Before this patchset
====================
# grep cfs_rq /proc/sched_debug 
cfs_rq[0]:
cfs_rq[0]:
cfs_rq[1]:
cfs_rq[1]:
cfs_rq[2]:
cfs_rq[2]:
cfs_rq[3]:
cfs_rq[3]:
cfs_rq[4]:
cfs_rq[5]:
cfs_rq[6]:
cfs_rq[7]:
cfs_rq[8]:
cfs_rq[9]:
cfs_rq[10]:
cfs_rq[11]:
cfs_rq[12]:
cfs_rq[13]:
cfs_rq[13]:
cfs_rq[14]:
cfs_rq[14]:
cfs_rq[15]:
cfs_rq[15]:

# grep while1 /proc/sched_debug 
R         while1  2203     48420.920338      5007   120     48420.920338     48951.419166         7.485277
R         while1  2226     23823.872648      2865   120     23823.872648     28347.561387         3.988024
R         while1  2204     43006.490234      4851   120     43006.490234     48459.814725         0.000000

With this patchset
==================
# grep cfs_rq /proc/sched_debug 
cfs_rq[0]:/autogroup-52
cfs_rq[0]:/autogroup-0
cfs_rq[1]:/autogroup-54
cfs_rq[1]:/autogroup-0
cfs_rq[2]:/autogroup-51
cfs_rq[2]:/autogroup-0
cfs_rq[3]:/autogroup-0
cfs_rq[4]:/autogroup-50
cfs_rq[4]:/autogroup-0
cfs_rq[5]:/autogroup-11
cfs_rq[5]:/autogroup-0
cfs_rq[6]:/autogroup-0
cfs_rq[7]:/autogroup-0
cfs_rq[8]:/autogroup-13
cfs_rq[8]:/autogroup-0
cfs_rq[9]:/autogroup-0
cfs_rq[10]:/autogroup-52
cfs_rq[10]:/autogroup-0
cfs_rq[11]:/autogroup-52
cfs_rq[11]:/autogroup-0
cfs_rq[12]:/autogroup-0
cfs_rq[13]:/autogroup-0
cfs_rq[14]:/1
cfs_rq[14]:/autogroup-0
cfs_rq[15]:/autogroup-0

# grep while1 /proc/sched_debug 
R         while1  2208     38199.296761      3826   120     38199.296761     38200.395907         4.341835 /autogroup-54
R         while1  2205     31251.518310      5629   120     31251.518310     54431.493631         6.882145 /autogroup-50
R         while1  2206     43920.889967      5402   120     43920.889967     53954.315334         0.000000 /1

Regards,
Bharata.

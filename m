Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab2HPGte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 02:49:34 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:53690 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab2HPGtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 02:49:32 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-79-502c97fbe423
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mike Turquette <mturquette@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Xiaoguang Chen <chenxg@marvell.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 0/2] devfreq: Add sysfs node for representing frequency
 transition information.
Date: Thu, 16 Aug 2012 15:49:25 +0900
Message-id: <1345099767-13467-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJMWRmVeSWpSXmKPExsVy+t9jQd3f03UCDC69FbC4vGsOm8Xn3iOM
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVM2H2RuWA3T8Xu7fuYGhivcnYxcnJICJhIrPu0jAnC
	FpO4cG89WxcjF4eQwHRGid7ZvWwgCSGBFiaJ5T81QGw2AR2J//tusoPYIgJWEi/aX7GDNDAL
	fGCU2Na/mhUkISyQKPGo4SwjiM0ioCqxp+ER0AYODl4BD4kp90IglilILLj3lm0CI/cCRoZV
	jKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMG+fCa1g3Flg8UhRgEORiUeXgkmnQAh1sSy4src
	Q4wSHMxKIry3a4FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeY29v/oLCaQnlqRmp6YWpBbBZJk4
	OKUaGJnXXgxRY/3JlBK3Qj1w8jJnFz/RUx7i3kGH/99fuzX7nuozpQ/vGwuqTyolvv7+fdmP
	uPq3nHf/zk05sn1SoNrL4xNMGSLDRL8Fupi/YvqnHH7F5N5Gu5mHuSTPcQeXtzx4oNzNdf3t
	U72UaRqS56OnCk/gKd7zsefV4f45D9OmNx+eGHV75gQlluKMREMt5qLiRADTWAke4QEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds sysfs node to devfreq's frame work to measure trasition of frequency on runtime.
It will be created under '/sys/class/devfreq/<device name>/' as the name of 'trans_state'.
It contains transition table which represents total number of transition of each frerquency state to
others and also time spent the state.

--- example for device having 3 frequency levels ----------------------------------------------------
			 <freq level #1>        <freq level #2>       <freq level #3>	   time_spent
* <freq level #1>		              # of freq1 to freq2    # of freq1 to freq3       t1
  <freq level #2>       # of freq2 to freq1			     # of freq2 to freq3       t2
  <freq level #3>       # of freq3 to freq1   # of freq3 to freq2			       t3
 total transition : N
-----------------------------------------------------------------------------------------------------
('*' represents last frequency changed at the time you inspect the node.)

Patch 1: Make sysfs node to DEVFREQ frame work.
Patch 2: Initialize freq_table and max_state in exynos4 devfreq driver to be
	 used for frequency trnasition measurement.

Jonghwa Lee (2):
  devfreq: Add sysfs node for representing frequency transition
    information.
  devfreq: exynos4: Support initialization of freq_table and max_state
    of devfreq's profile.

 drivers/devfreq/devfreq.c     |   89 +++++++++++++++++++++++++++++++++++++++++
 drivers/devfreq/exynos4_bus.c |   30 +++++++++++++-
 include/linux/devfreq.h       |    9 ++++
 3 files changed, 127 insertions(+), 1 deletions(-)

-- 
1.7.4.1


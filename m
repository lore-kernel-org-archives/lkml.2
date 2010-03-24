Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942Ab0CXUrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:47:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756808Ab0CXUru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:47:50 -0400
Date: Wed, 24 Mar 2010 21:45:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Balbir Singh <balbir@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Spencer Candland <spencer@bluehost.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC,PATCH 0/2] cputimers/proc: can't we make /proc/pid/stat less
	accurate?
Message-ID: <20100324204545.GA31769@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly to provoke the discussion and untested, please comment.

In short: I do not actually know if /proc/pid/stat should be "really"
accurate wrt cpu accounting. I mean, I don't know how much /bin/top
and friends depend on xtime monotonicity.

However, it is sad that /proc/pid/stat iterates over ->thread_group
_twice_ under ->siglock.

Any thoughts?

Oleg.


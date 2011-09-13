Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab1IMPWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 11:22:04 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39475 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab1IMPWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 11:22:02 -0400
Date: Tue, 13 Sep 2011 17:21:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>, Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 00/11 v5] cgroups: Task counter subsystem
Message-ID: <20110913152153.GD23424@somewhere>
References: <1315869091-18933-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315869091-18933-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 01:11:20AM +0200, Frederic Weisbecker wrote:
> No functional changes. Only documentation and comments added.
> Checkpatch.pl fixes, etc...
> 
> This mostly addresses Andrew's reviews on v4.
> 
> Changes in v5:
> 
> - commented res_counter_common_ancestor (patch 6)
> - commented res_counter_inherit (patch 2)
> - merged documentation and task counter subsystem patch (patch 9)
> - rename cgroup_task_counter_res in cgroup_task_res_counter (patch 9)
> - more comments/ fix comments in cgroup_task_counter.c (patch 9)
> - document res_counter_charge return value (patch 8)
> - document res_counter_charge_until (patch 5)
> - more comment in kconfig help (patch 9)
> - fix various checkpatch reported issues

There is a test tool that you can download there:

https://tglx.de/~fweisbec/task_counter_test.tar.gz

It tests various things to ensure the subsystem behaves
as expected:

- correct tasks.usage value when tasks are moved around
- correct fork and cgroup migration rejects if limit
is reached
- correct propagation of limit to parents
- correct protection against forkbombs
- test killing of tasks in a cgroup
- ...

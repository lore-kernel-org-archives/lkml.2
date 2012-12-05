Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab2LEPTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 10:19:39 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:53641 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab2LEPTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 10:19:38 -0500
MIME-Version: 1.0
Date: Wed, 5 Dec 2012 23:19:37 +0800
Message-ID: <CAGjg+kFZ2+tzxOS4SVo3PTzEDJJ=B0gZJ0aEOhNHvTycFuVT6Q@mail.gmail.com>
Subject: weakness of runnable load tracking?
From: Alex Shi <lkml.alex@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Alex Shi <alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul&Ingo:

Runnable load tracking patch set introduce a good way to tracking each
entity/rq's running time.
But when I try to enable it in load balance, I found burst forking
many new tasks will make just few cpu heavy while other cpu has no
much task assigned. That is due to the new forked task's
load_avg_contrib is zero after just created. then no matter how many
tasks assigned to a CPU can not increase the cfs_rq->runnable_load_avg
or rq->avg.load_avg_contrib if this cpu idle.
Actually, if just for new task issue, we can set new task's initial
load_avg same as load_weight. but if we want to burst wake up many
long time sleeping tasks, it has the same issue here since their were
decayed to zero. So what solution I can thought is recording the se's
load_avg_contrib just before dequeue, and don't decay the value, when
it was waken up, add this value to new cfs_rq. but if so, the runnable
load tracking is total meaningless.
So do you have some idea of burst wakeup balancing with runnable load tracking?


-- 
Thanks
    Alex

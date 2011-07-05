Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab1GEAiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 20:38:23 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46133 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab1GEAiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 20:38:22 -0400
MIME-Version: 1.0
In-Reply-To: <20110704130838.27757.87486.stgit@localhost6>
References: <20110704130838.27757.87486.stgit@localhost6>
Date: Tue, 5 Jul 2011 08:38:21 +0800
X-Google-Sender-Auth: kafnluUkBRz-CnubmjmZe56g8Is
Message-ID: <CANejiEV75k9SrkQFsb5H3n_307j7yA941WMgymioPOT-vxhWcQ@mail.gmail.com>
Subject: Re: [PATCH RFC 1/2] cfq: request-deadline policy
From: Shaohua Li <shli@kernel.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/4 Konstantin Khlebnikov <khlebnikov@openvz.org>:
> CFQ is designed for sharing disk bandwidth proportionally between queues and groups
> and for reordering requests to reduce disks seek time. Currently it cannot
> gurantee or estimate latency for individual requests, even if latencies are low
> for almost all requests, some of them can stuck inside scheduler for a long time.
> The fair policy is good as long as someone luckless begins to die due to a timeout.
>
> This patch implements fifo requests dispatching with deadline policy: now cfq
> obliged to dispatch request if it stuck in the queue for more than deadline.
>
> This way now cfq can try to ensure the expected latency of requests execution.
> It is like a safety valve, it should not work all time, but it should keep latency
> in sane range when the scheduler is unable to effectively handle flow of requests,
> especially in cases when the "noop" or "deadline" shows better performance.
>
> deadline can be tuned via /sys/block/<device>/queue/iosched/deadline_{sync,async}
> it by default 2000ms for sync and 4000ms for async requests, use 0 to disable it.
I'm afraid this takes too far away. It completed breaks fairness of
CFQ. The sync/async and priority of queues lose meaning.
Even deadline is meaningful of some kind, maybe we should add a policy
in preempt. If a queue has very old requests, don't preempt such
queue. But we should be careful to tune how long slice the queue can
take so fairness isn't broken.

Thanks,
Shaohua

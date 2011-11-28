Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab1K1LSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 06:18:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:52608 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1K1LSo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 06:18:44 -0500
Message-ID: <1322479108.2921.106.camel@twins>
Subject: Re: [PATCH] perf, core: rate limit perf_sched_events jump_label
 patching
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
        Jason Baron <jbaron@redhat.com>, rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 28 Nov 2011 12:18:28 +0100
In-Reply-To: <20111127155909.GO2557@redhat.com>
References: <20111127155909.GO2557@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-11-27 at 17:59 +0200, Gleb Natapov wrote:
> jump_lable patching is very expensive operation that involves pausing all
> cpus. The patching of perf_sched_events jump_label is easily controllable
> from userspace by unprivileged user. When user runs loop like this
> "while true; do perf stat -e cycles true; done" the performance of my
> test application that just increments a counter for one second drops by
> 4%. This is on a 16 cpu box with my test application using only one of
> them. An impact on a real server doing real work will be much worse.
> Performance of KVM PMU drops nearly 50% due to jump_lable for "perf
> record" since KVM PMU implementation creates and destroys perf event
> frequently.
> 
> This patch introduce the way to rate limit jump_label patching and uses
> it to fix above problem. I believe that as jump_label use will spread
> the problem will become more common and thus solving it in a generic
> code is appropriate. Also fixing it in a perf code will result in moving
> jump_label accounting logic to perf code with all the ifdefs in case
> of JUMP_LABEL=n kernel. With this patch all details are nicely hidden
> inside jump_label code. 

Looks good, thanks!

Should appear in:

git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git perf/core

at some point in the not too distant future.



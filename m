Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab2BLShc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 13:37:32 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:60791 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754264Ab2BLShb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 13:37:31 -0500
MIME-Version: 1.0
Date: Sun, 12 Feb 2012 12:37:30 -0600
X-Google-Sender-Auth: 3kIE1-QKlnNpxmQIskaJAIAPhHo
Message-ID: <CAN_5kQB+BjPc5Sj=a-4B80-6t5D3C4WkvP6bz_BRcMd6LKAzqw@mail.gmail.com>
Subject: Question about resetting a sampling counter in kernel
From: heechul Yun <heechul@illinois.edu>
To: linux-kernel@vger.kernel.org
Cc: Vince Weaver <vweaver1@eecs.utk.edu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a question about controlling performance counter in kernel.

I created a kernel counter which generates an interrupt at every
10000 cache-misses as shown below.

struct perf_event_attr sched_perf_hw_attr = {
     .type = PERF_TYPE_HARDWARE,
     .config = PERF_COUNT_HW_CACHE_MISSES,
     .sample_period = 10000,
     .size = sizeof(struct perf_event_attr),
     .pinned = 1,
     .disbled = 1,
}

event = perf_event_create_kernel_counter(&sched_perf_hw_attr, cpu,
       NULL, event_overflow_callback, NULL);

What I would like to do is to "reset" the counter before the
overflow interrupt occurs (e.g, reset at 5000th event),
and then to restart the sampling from 0.

I found perf_event_enable() and perf_event_disable() only
start/stop the counting but couln't figure out how to reset the
sampling as I described above.

I would be really thankful if you explain how I can efficiently reset the
sampling counter.

Thanks.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2FEP3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:29:52 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47502 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752453Ab2FEP3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:29:51 -0400
Date: Tue, 5 Jun 2012 11:29:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: yoshihiro.yunomae.ez@hitachi.com
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: ivring driver
Message-ID: <20120605152947.GA21787@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yoshihiro,

I stumbled on your post on ivring (https://lkml.org/lkml/2012/6/5/143)
for buffering trace data from guest to host. I notice that it would be
very interesting to see a comparison of its performance against:

- ftrace ring buffer
- perf ring buffer
- lttng 2.0 ring buffer
- lttng-ust 2.0 (user-space tracing) ring buffer

Comparing only with network-related mechanisms does not seem to provide
a complete picture of where it stands wrt other ring buffers out there.

One of the metric we have used in the past is the number of nanoseconds
it takes to write a single event, based on a test that writes lots of
events into various buffer sizes, into flight recorder mode buffers
(which overwrites oldest information on buffer full condition, with data
collection to disk disabled, to remove I/O from the picture -- I/O can
then be performed in "snapshot" mode, after some error condition is
detected).

Best regards,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

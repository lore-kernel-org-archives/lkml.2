Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab0KXLfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 06:35:54 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57438 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab0KXLfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 06:35:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:x-gnus-delayed:date:message-id:user-agent
         :mime-version:content-type;
        b=mmKEcrAGb/rewpxphL4gyEpNaXvAxV/B0zsU1x7dOL7aqOZmmPV5rTs4kNy/3KqJk4
         3OPsWMHbhBtknzKosEVXkwKXAaQmzthsijCwjqWMheRo8lFG9L/UzWgQrzgYg4Y7pMjs
         N215efG3royFOJd+OiFZlB/G9FVedIASiaaKA=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: perf: some questions about perf software events
X-Gnus-Delayed: Wed, 24 Nov 2010 12:12:31 +0100
Date: Wed, 24 Nov 2010 12:35:36 +0100
Message-ID: <m3tyj73qev.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter,

I've still a couple of questions after looking at the software events
code, hope you don't mind.

For pure software events (ie excluding {task,cpu}-clock), does it make
sense to set a sample frequency ? I would have done something like this:


diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 31515200..df27fd8 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4671,6 +4671,8 @@ static int perf_swevent_init(struct perf_event *event)
 
 	if (event->attr.type != PERF_TYPE_SOFTWARE)
 		return -ENOENT;
+	if (event->attr.freq)
+		return -EINVAL;
 
 	switch (event_id) {
 	case PERF_COUNT_SW_CPU_CLOCK:



That is for no 'contiguous' events, setting a sampling frequency doesn't
really make sense since for example you could set a frequency to 1000 HZ
for the software ALIGNMENT_FAULT event and never get any samplings or at
least getting sampling but with a totally different rate. And the
current code doesn't look to handle sample_freq anyway.

Also I'm currently not seeing any real differences between cpu-clock and
task-clock events. They both seem to count the time elapsed when the
task is running on a CPU. Am I wrong ?

Thanks
-- 
		Franck

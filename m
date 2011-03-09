Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab1CIMUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 07:20:37 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38021 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab1CIMUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 07:20:35 -0500
Message-ID: <4D77708F.1000800@monstr.eu>
Date: Wed, 09 Mar 2011 13:20:31 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Subject: Revert "irq: Add tracepoint to softirq_raise" - microblaze build
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

I have compiled ftrace support for Microblaze and I have reached a compilation failure.

I bisected it and I found that
"irq: Add tracepoint to softirq_raise"
(sha1:2bf2160d8805de64308e2e7c3cd97813cb58ed2f)
caused it.

I also found one thread which could be related.
http://kerneltrap.org/mailarchive/linux-kernel/2010/9/8/4616941

It is likely any missing header or so.

Do you know what can be wrong?

Thanks,
Michal


[ALL  ]   CC      kernel/trace/power-traces.o
[ALL  ] In file included from 
/mnt/projects/petalinux-v1.00-devel/software/linux-2.6.x/arch/microblaze/include/asm/irq.h:15,
[ALL  ]                  from include/linux/irq.h:27,
[ALL  ]                  from include/asm-generic/hardirq.h:12,
[ALL  ]                  from 
/mnt/projects/petalinux-v1.00-devel/software/linux-2.6.x/arch/microblaze/include/asm/hardirq.h:15,
[ALL  ]                  from include/linux/hardirq.h:7,
[ALL  ]                  from include/linux/ftrace_event.h:7,
[ALL  ]                  from include/trace/ftrace.h:19,
[ALL  ]                  from include/trace/define_trace.h:96,
[ALL  ]                  from include/trace/events/power.h:240,
[ALL  ]                  from kernel/trace/power-traces.c:14:
[ALL  ] include/linux/interrupt.h: In function '__raise_softirq_irqoff':
[ERROR] include/linux/interrupt.h:413: error: implicit declaration of function 'trace_softirq_raise'
[ALL  ] In file included from include/trace/ftrace.h:554,
[ALL  ]                  from include/trace/define_trace.h:96,
[ALL  ]                  from include/trace/events/power.h:240,
[ALL  ]                  from kernel/trace/power-traces.c:14:
[ALL  ] include/trace/events/irq.h: In function 'ftrace_test_probe_irq_handler_entry':
[ERROR] include/trace/events/irq.h:37: error: implicit declaration of function 
'check_trace_callback_type_irq_handler_entry'
[ALL  ] include/trace/events/irq.h: In function 'ftrace_test_probe_irq_handler_exit':
[ERROR] include/trace/events/irq.h:67: error: implicit declaration of function 
'check_trace_callback_type_irq_handler_exit'
[ALL  ] include/trace/events/irq.h: In function 'ftrace_test_probe_softirq_entry':
[ERROR] include/trace/events/irq.h:112: error: implicit declaration of function 
'check_trace_callback_type_softirq_entry'
[ALL  ] include/trace/events/irq.h: In function 'ftrace_test_probe_softirq_exit':
[ERROR] include/trace/events/irq.h:126: error: implicit declaration of function 
'check_trace_callback_type_softirq_exit'
[ALL  ] include/trace/events/irq.h: In function 'ftrace_test_probe_softirq_raise':
[ERROR] include/trace/events/irq.h:140: error: implicit declaration of function 
'check_trace_callback_type_softirq_raise'
[ERROR] make[5]: *** [kernel/trace/power-traces.o] Error 1
[ERROR] make[4]: *** [kernel/trace] Error 2
[ERROR] make[3]: *** [kernel] Error 2


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian

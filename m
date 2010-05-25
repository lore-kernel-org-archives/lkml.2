Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708Ab0EYTby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 15:31:54 -0400
Received: from adelie.canonical.com ([91.189.90.139]:45807 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab0EYTbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 15:31:52 -0400
Subject: Tracing configuration review
From: Chase Douglas <chase.douglas@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 May 2010 15:31:46 -0400
Message-ID: <1274815906.9757.83.camel@cndougla-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm going through our Ubuntu kernel configuration for our next release
to ensure we have all the trace options enabled that may be useful. I
have a few questions about what tracer options we should have enabled.

Our guiding principle in regards to these options is: if an option can
be turned on and has no performance impact unless explicitly enabled on
the kernel command line or at runtime, we are happy to enable it.
Secondarily, we don't want to enable options that are headed for
deprecation.

The following options are what I am looking to set for our x86
configurations. I've only included those that I am not 100% sure of.
Comments are what I could gather from documentation and Kconfig, but
they may not be accurate:

# CONFIG_IRQSOFF_TRACER is not set (performance impact by default)
# CONFIG_SYSPROF_TRACER is not set (don't know much about this)
# CONFIG_SCHED_TRACER is not set (headed for deprecation?)
CONFIG_FTRACE_SYSCALLS=y (no performance impact by default)
CONFIG_BOOT_TRACER=y (no performance impact by default)
CONFIG_KSYM_TRACER=y (no performance impact by default)
# CONFIG_STACK_TRACER is not set (Kconfig says N if unsure)
# CONFIG_KMEMTRACE is not set (Kconfig says N if unsure)
CONFIG_WORKQUEUE_TRACER=y (no performance impact by default)

Lastly, what options are safe for performance when
HAVE_DYNAMIC_FTRACE=n, like on our ARM kernels. It is not clear to me
through what's in Documentation/trace/* and the Kconfig entries what
options could cause a performance decrease due to the inability to
dynamically enable and disable tracing at runtime.

Thanks,

-- Chase


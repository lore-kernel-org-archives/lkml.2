Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab1BCVJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:09:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51368
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752426Ab1BCVJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:09:28 -0500
Date: Thu, 03 Feb 2011 13:10:04 -0800 (PST)
Message-Id: <20110203.131004.226772735.davem@davemloft.net>
To: jengelh@medozas.de
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Kernel crash with repeated NF invocation
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.01.1102031605330.21536@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1102031605330.21536@obet.zrqbmnf.qr>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@medozas.de>
Date: Thu, 3 Feb 2011 16:19:56 +0100 (CET)

> I remember there being a kernel config option 
> (CONFIG_DEBUG_STACKOVERFLOW) that would emit messages 
> similar to
> "process foobar (12345) used greatest stack depth: 2042" --
> would that also work for softirqs?

The kernel stack tracer is your best bet right now, it's easy to
enable, it's something like just writing "1" to the /sys filesystem
file that controls it.

Enable CONFIG_STACK_TRACER in your config.

config STACK_TRACER
	bool "Trace max stack"
	depends on HAVE_FUNCTION_TRACER
	select FUNCTION_TRACER
	select STACKTRACE
	select KALLSYMS
	help
	  This special tracer records the maximum stack footprint of the
	  kernel and displays it in /sys/kernel/debug/tracing/stack_trace.

	  This tracer works by hooking into every function call that the
	  kernel executes, and keeping a maximum stack depth value and
	  stack-trace saved.  If this is configured with DYNAMIC_FTRACE
	  then it will not have any overhead while the stack tracer
	  is disabled.

	  To enable the stack tracer on bootup, pass in 'stacktrace'
	  on the kernel command line.

	  The stack tracer can also be enabled or disabled via the
	  sysctl kernel.stack_tracer_enabled

	  Say N if unsure.


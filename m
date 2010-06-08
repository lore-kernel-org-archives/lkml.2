Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab0FHWBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 18:01:13 -0400
Received: from adelie.canonical.com ([91.189.90.139]:41975 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab0FHWBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 18:01:12 -0400
Subject: Re: Tracing configuration review
From: Chase Douglas <chase.douglas@canonical.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Soeren Sandmann <sandmann@daimi.au.dk>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com
In-Reply-To: <20100608103517.ac380ad4.randy.dunlap@oracle.com>
References: <1274815906.9757.83.camel@cndougla-ubuntu>
	 <20100525201259.GA5370@nowhere> <1274821799.9346.17.camel@cndougla-ubuntu>
	 <20100608103517.ac380ad4.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Jun 2010 18:00:34 -0400
Message-ID: <1276034434.8645.56.camel@cndougla-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-08 at 10:35 -0700, Randy Dunlap wrote:
> Hi Chase,
> 
> Would you mind sharing your final tracing config options?

Sure.

Our source tree for Maverick encompasses all our major supported
platforms in one git branch. Thus, we have one common config file and a
bunch of arch and flavour (generic, server, virtual, pae) specific
config files. One note about the common configs: if a config option
would not exist because an option in a specific config file is set a
certain way, then you can ignore it for that specific arch/flavour. For
example, the common config has CONFIG_DYNAMIC_FTRACE=y, but the armel
config has "CONFIG_FUNCTION_TRACER is not set" so the former would not
have any affect on armel builds.

You can find the source branch at
http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-maverick.git;a=summary

$ grep -Ir "TRAC[EI]" debian.master/config
./amd64/config.common.amd64:CONFIG_FUNCTION_TRACER=y
./amd64/config.common.amd64:CONFIG_STACK_TRACER=y
./i386/config.common.i386:CONFIG_FUNCTION_TRACER=y
./i386/config.common.i386:CONFIG_STACK_TRACER=y
./armel/config.common.armel:# CONFIG_FUNCTION_TRACER is not set
./armel/config.common.armel:# CONFIG_STACK_TRACER is not set
./config.common.ubuntu:# CONFIG_BACKTRACE_SELF_TEST is not set
./config.common.ubuntu:CONFIG_BLK_DEV_IO_TRACE=y
./config.common.ubuntu:# CONFIG_BOOT_TRACER is not set
./config.common.ubuntu:CONFIG_CAN_PM_TRACE=y
./config.common.ubuntu:CONFIG_CAPI_TRACE=y
./config.common.ubuntu:CONFIG_CONTEXT_SWITCH_TRACER=y
./config.common.ubuntu:CONFIG_DYNAMIC_FTRACE=y
./config.common.ubuntu:CONFIG_EVENT_TRACING=y
./config.common.ubuntu:CONFIG_FTRACE=y
./config.common.ubuntu:CONFIG_FTRACE_MCOUNT_RECORD=y
./config.common.ubuntu:CONFIG_FTRACE_NMI_ENTER=y
./config.common.ubuntu:# CONFIG_FTRACE_STARTUP_TEST is not set
./config.common.ubuntu:CONFIG_FTRACE_SYSCALLS=y
./config.common.ubuntu:CONFIG_FUNCTION_GRAPH_TRACER=y
./config.common.ubuntu:CONFIG_GENERIC_TRACER=y
./config.common.ubuntu:CONFIG_HAVE_ARCH_TRACEHOOK=y
./config.common.ubuntu:CONFIG_HAVE_DYNAMIC_FTRACE=y
./config.common.ubuntu:CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
./config.common.ubuntu:CONFIG_HAVE_FTRACE_NMI_ENTER=y
./config.common.ubuntu:CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
./config.common.ubuntu:CONFIG_HAVE_FUNCTION_TRACER=y
./config.common.ubuntu:CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
./config.common.ubuntu:CONFIG_HAVE_MMIOTRACE_SUPPORT=y
./config.common.ubuntu:CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
./config.common.ubuntu:# CONFIG_IRQSOFF_TRACER is not set
./config.common.ubuntu:CONFIG_IWLWIFI_DEVICE_TRACING=y
./config.common.ubuntu:# CONFIG_KMEMTRACE is not set
./config.common.ubuntu:# CONFIG_KSYM_TRACER is not set
./config.common.ubuntu:CONFIG_MMIOTRACE=y
./config.common.ubuntu:# CONFIG_MMIOTRACE_TEST is not set
./config.common.ubuntu:CONFIG_NETFILTER_XT_TARGET_TRACE=m
./config.common.ubuntu:CONFIG_NOP_TRACER=y
./config.common.ubuntu:CONFIG_PM_TRACE=y
./config.common.ubuntu:CONFIG_PM_TRACE_RTC=y
./config.common.ubuntu:# CONFIG_RCU_TRACE is not set
./config.common.ubuntu:CONFIG_SCHED_TRACER=y
./config.common.ubuntu:# CONFIG_SCSI_IPR_TRACE is not set
./config.common.ubuntu:CONFIG_STACKTRACE=y
./config.common.ubuntu:CONFIG_STACKTRACE_SUPPORT=y
./config.common.ubuntu:# CONFIG_SYSPROF_TRACER is not set
./config.common.ubuntu:CONFIG_TRACEPOINTS=y
./config.common.ubuntu:CONFIG_TRACER_MAX_TRACE=y
./config.common.ubuntu:CONFIG_TRACE_IRQFLAGS_SUPPORT=y
./config.common.ubuntu:CONFIG_TRACING=y
./config.common.ubuntu:CONFIG_TRACING_SUPPORT=y
./config.common.ubuntu:# CONFIG_TREE_RCU_TRACE is not set
./config.common.ubuntu:CONFIG_USER_STACKTRACE_SUPPORT=y
./config.common.ubuntu:# CONFIG_VXGE_DEBUG_TRACE_ALL is not set
./config.common.ubuntu:# CONFIG_WORKQUEUE_TRACER is not set

Some of the above is not FTRACE. I also snipped the matches in
config.common.ports because they are slightly different due to what the
ports architectures support, but they should be pretty similar.

Please let me know if anything stands out at you as incorrect.

Thanks,

-- Chase


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab1DOLRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 07:17:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54361 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982Ab1DOLR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 07:17:29 -0400
Subject: Re: Regression from 2.6.36
From: Mel Gorman <mgorman@suse.de>
To: azurIt <azurit@pobox.sk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Changli Gao <xiaosuo@gmail.com>,
        Am?rico Wang <xiyou.wangcong@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <20110415125651.68156745@pobox.sk>
References: <1302178426.3357.34.camel@edumazet-laptop>
	 <BANLkTikxWy-Pw1PrcAJMHs2R7JKksyQzMQ@mail.gmail.com>
	 <1302190586.3357.45.camel@edumazet-laptop>
	 <20110412154906.70829d60.akpm@linux-foundation.org>
	 <BANLkTincoaxp5Soe6O-eb8LWpgra=k2NsQ@mail.gmail.com>
	 <20110412183132.a854bffc.akpm@linux-foundation.org>
	 <1302662256.2811.27.camel@edumazet-laptop>
	 <20110413141600.28793661.akpm@linux-foundation.org>
	 <20110414102501.GE11871@csn.ul.ie> <20110415115903.315DEAA1@pobox.sk>
	 <20110415104700.GD22688@suse.de>  <20110415125651.68156745@pobox.sk>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 15 Apr 2011 12:17:27 +0100
Message-ID: <1302866247.12428.25.camel@machina.109elm.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-15 at 12:56 +0200, azurIt wrote:
> # mount -t debugfs none /sys/kernel/debug
> mount: mount point /sys/kernel/debug does not exist
> 
> # mkdir /sys/kernel/debug
> mkdir: cannot create directory `/sys/kernel/debug': No such file or directory
> 

Mount sysfs first

mount -t sysfs none /sys

> 
> config file used for testing is here:
> http://watchdog.sk/lkml/config
> 

Try setting the following

CONFIG_TRACEPOINTS=y
CONFIG_STACKTRACE=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_GENERIC_TRACER=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_MMIOTRACE=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y

-- 
Mel Gorman
SUSE Labs


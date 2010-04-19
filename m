Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab0DSES5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 00:18:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49994
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209Ab0DSES4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 00:18:56 -0400
Date: Sun, 18 Apr 2010 21:19:00 -0700 (PDT)
Message-Id: <20100418.211900.183039797.davem@davemloft.net>
To: fweisbec@gmail.com
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, lizf@cn.fujitsu.com, laijs@cn.fujitsu.com
Subject: Re: [PATCH] tracing: Dump either the oops's cpu source or all cpus
 buffers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1271623810-23700-1-git-send-regression-fweisbec@gmail.com>
References: <1271623810-23700-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Sun, 18 Apr 2010 22:50:10 +0200

> The ftrace_dump_on_oops kernel parameter, sysctl and sysrq let one
> dump every cpu buffers when an oops or panic happens.
> 
> It's nice when you have few cpus but it may take ages if have many,
> plus you miss the real origin of the problem in all the cpu traces.
> 
> Sometimes, all you need is to dump the cpu buffer that triggered the
> opps, most of the time it is our main interest.
> 
> This patch modifies ftrace_dump_on_oops to handle this choice.
> 
> The ftrace_dump_on_oops kernel parameter, when it comes alone, has
> the same behaviour than before. But ftrace_dump_on_oops=orig_cpu
> will only dump the buffer of the cpu that oops'ed.
> 
> Similarly, sysctl kernel.ftrace_dump_on_oops=1 and
> echo 1 > /proc/sys/kernel/ftrace_dump_on_oops keep their previous
> behaviour. But setting 2 jumps into cpu origin dump mode.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks I was trying to figure out a way to make ftrace dump
do exactly this over the past few days :-)

Acked-by: David S. Miller <davem@davemloft.net>

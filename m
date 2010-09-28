Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab0I1N5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:57:32 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:37949 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753230Ab0I1N5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:57:31 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+QvJ0tfHuQjM5q6TuO1MsC0+uNwa3FMYGlFGKIfY
	Q/l4K7+GH4lvxV
Subject: Re: [PATCH 0/3][RFC] Improve load balancing when tasks have large
 weight differential
From: Mike Galbraith <efault@gmx.de>
To: Nikhil Rao <ncrao@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1285633798-26886-1-git-send-email-ncrao@google.com>
References: <1285633798-26886-1-git-send-email-ncrao@google.com>
Content-Type: text/plain
Date: Tue, 28 Sep 2010 15:57:53 +0200
Message-Id: <1285682273.7469.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 17:29 -0700, Nikhil Rao wrote:
> Hi all,
> 
> I have attached a series of patches that improve load balancing when there is a
> large weight differential between tasks. These patches are based off the
> feedback Peter Zijlstra gave in an earlier post (see http://thread.gmane.org/gmane.linux.kernel/1015966).
> They can be applied to v2.6.36-rc5 or -tip without conflicts.
> 
> Tested with the following setup.
> - Test machine is a 16 cpu box (quad-socket, quad-core).
> - Baseline is v2.6.36-rc5 kernel
> 
> We spawn 16 SCHED_IDLE soaker threads and one SCHED_NORMAL task. On the
> baseline kernel, the machine has ~18% idle time. With these patches applied on
> top of baseline, idle time drops to 0%.

Hm. I can get it stuck with one core idle on ym little quad.

top - 15:53:22 up 11 min, 17 users,  load average: 5.05, 4.40, 2.51
Tasks: 270 total,   7 running, 263 sleeping,   0 stopped,   0 zombie
Cpu(s): 75.3%us,  0.0%sy,  0.0%ni, 24.7%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 7455 root       5 -15  7996  340  256 R  100  0.0   0:59.93 1 pert
 7421 root      20   0  7996  340  256 R   50  0.0   4:20.01 3 pert
 7422 root      20   0  7996  340  256 R   50  0.0   3:45.81 2 pert
 7423 root      20   0  7996  340  256 R   50  0.0   4:09.45 2 pert
 7424 root      20   0  7996  344  256 R   50  0.0   4:12.75 3 pert



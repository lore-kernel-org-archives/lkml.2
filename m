Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319Ab0FQUVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:21:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933314Ab0FQUU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:20:58 -0400
Date: Thu, 17 Jun 2010 17:20:32 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH] perf: prevent kill(0, SIGTERM);
Message-ID: <20100617202032.GC1626@ghostprotocols.net>
References: <1276072680-17378-1-git-send-email-imunsie@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276072680-17378-1-git-send-email-imunsie@au1.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jun 09, 2010 at 06:38:00PM +1000, Ian Munsie escreveu:
> At exit, perf record will kill the process it was profiling by sending a
> SIGTERM to child_pid (if it had been initialised), but in certain
> situations child_pid may be 0 and perf would mistakenly kill more
> processes than intended.
> 
> child_pid is set to the return of fork() to either 0 or the pid of the
> child. Ordinarily this would not present an issue as the child calls
> execvp to spawn the process to be profilled and would therefore never
> run it's sig_atexit and never attempt to kill pid 0.

before:

[root@emilia mingo]# perf record bla
bla: No such file or directory
Terminated

after:

[root@emilia mingo]# perf record bla
bla: No such file or directory
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.006 MB perf.data (~259 samples) ]
[root@emilia mingo]#

Got it, queuing it in perf/urgent,

Thanks!

- Arnaldo

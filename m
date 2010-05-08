Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab0EHICB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 04:02:01 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:57184 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab0EHIB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 04:01:59 -0400
Message-ID: <4BE51A90.2060305@dcl.info.waseda.ac.jp>
Date: Sat, 08 May 2010 17:02:24 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH] perf lock: track only specified threads
References: <4BE28C8D.8000408@dcl.info.waseda.ac.jp> <1273138376-23323-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100507004945.GA8069@nowhere>
In-Reply-To: <20100507004945.GA8069@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/10 09:49, Frederic Weisbecker wrote:
 > On Thu, May 06, 2010 at 06:32:56PM +0900, Hitoshi Mitake wrote:
 >> I implemented the feature of tracking only specified threads to perf 
lock.
 >> With -t option, users can specify which threads should be tracked.
 >>
 >> Example of usage:
 >> | % sudo ./perf lock info -t                    # info -t is 
convenient with this feature
 >> |  Thread ID: comm
 >> |          0: swapper
 >> |          1: init
 >> |         12: migration/3
 >> |         13: ksoftirqd/3
 >> |         27: events/0
 >> |         28: events/1
 >> |         29: events/2
 >> |         30: events/3
 >> |         31: events/4
 >> |        857: kondemand/0
 >> |        858: kondemand/1
 >> |        859: kondemand/2
 >> | ...
 >> | % sudo ./perf lock -t 27,28,29,30,31 report   # track only these 
threads
 >> |                 Name   acquired  contended total wait (ns)   max 
wait (ns)   min wait (ns)
 >
 >
 >
 > I'm not sure we want such per thread granularity filtering. I'm not
 > sure it will be very useful. But per process yeah.
 >
 > And actually we should do that on tracing time rather than on 
post-processing.
 > This will lower the tracing overhead a lot.
 >
 > Ideally I think we need:
 > 	./perf lock record ls -R /
 >
 > This would trace locks taken by this instance of ls only, ie: drop the -a
 > if we pass a command line.
 >
 > What do you think?
 >
 >

Ah, I completely agree with your opinion :)
Even if user wants to append "-a",
   ./perf lock record -a ls -R /
is enough. "-a" should not in default set of arguments.

I'll send the patch to drop "-a" later.

Thanks,
	Hitoshi

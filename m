Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0JUJDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 05:03:09 -0400
Received: from [120.204.251.227] ([120.204.251.227]:42060 "EHLO
	LC-SHMAIL-01.SHANGHAI.LEADCORETECH.COM" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755389Ab0JUJDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 05:03:07 -0400
Subject: Re: Ftrace: can trace kthread?
From: "Figo.zhang" <zhangtianfei@leadcoretech.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <AANLkTi=D_a_BH-HW9mqwLim+DjxARWzT8mxP_dah5iLY@mail.gmail.com>
References: <1287647732.2237.7.camel@myhost>
	 <AANLkTim7g+8_rQSyewC6n_5WmC04kU-rj1g9k61=O2Vm@mail.gmail.com>
	 <1287649283.2237.8.camel@myhost>
	 <AANLkTikzSZNtTGfOcP-87u+pMZyW8WrdxwV52ZV3f=nX@mail.gmail.com>
	 <1287650668.2237.12.camel@myhost>
	 <AANLkTi=D_a_BH-HW9mqwLim+DjxARWzT8mxP_dah5iLY@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 16:59:02 +0800
Message-ID: <1287651542.2237.17.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Oct 2010 09:03:04.0720 (UTC) FILETIME=[C5787100:01CB70FE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I just
> echo  0 > tracing_enabled
> echo function > current_tracer
> echo 374(pid of flush) > set_ftrace_pid
> echo 1 > tracing_enabled
> wait some time
> echo 0 > tracing_enabled
> cat trace
> 
> So I think this answer your question "could kthread be traced?"

i do it the same of you.

[root@myhost tracing]# ps -ax | grep flush
Warning: bad ps syntax, perhaps a bogus '-'? See http://procps.sf.net/faq.html
 1205 ?        S      0:01 [flush-8:0]
11852 pts/1    S+     0:00 grep flush
[root@myhost tracing]# 

so my flusher pid is 1205, i do it as below:

[root@myhost tracing]# echo 0 > tracing_enabled 
[root@myhost tracing]# echo function > current_tracer
[root@myhost tracing]# echo 1205 > set_ftrace_pid 
[root@myhost tracing]# echo 1 > tracing_enabled 

wait ... and open some pdf files, let system eat huge memory...

[root@myhost tracing]# echo 0 > tracing_enabled 
[root@myhost tracing]# cat trace
# tracer: function
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |


but i canot trace nothing. 



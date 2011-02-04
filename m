Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab1BDT33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 14:29:29 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:26597 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751538Ab1BDT32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 14:29:28 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: IS8d_TgVM1ls6ifn5m5s_UbBd73Aw77TbUHiGdkXWa4RRBE
 OLzoq45ZEaLpWcaZN6ts7Vj_pb8XsmHPWUS9FDgNH5dhHL64EUd4VMEBPsos
 yn_GymgzWCV3yG0ElCB_KHd0lodXe6ny5eRWRMHkUK3eARBxAcVTHCG.fAll
 LRUOJ8BbtuSEhwl.4BAqMN5qITklDyYLyBmlUW6aYOzh4dxg8Kf4un8p_Qq5
 78L43nWbZYxuD44CiMCc1EL40Nrwnkxxguo2pgiG6eUNVrow-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 4 Feb 2011 13:29:25 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
cc: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Subject: Re: Thread Affinity structure
In-Reply-To: <AANLkTinbnrAMMKVZSBQChtZjUyw6Yk1otp8xmqJNvWm3@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1102041326330.4611@router.home>
References: <AANLkTinbnrAMMKVZSBQChtZjUyw6Yk1otp8xmqJNvWm3@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Feb 2011, Sri Ram Vemulpali wrote:

>     I have doubt regarding how the thread affinity (to processor) is
> defined in a process (task). If there is only single thread in a
> process, then when process calls itself on binding to a core, will let
> run on that core forever. But, what if there are multiple threads, in
> a process (task). If the main thread calls set affinity to a core, is
> it going to get inherited to all other threads, or just the calling
> thread in a task. What happens when forked a process with threads that
> has affinity to a core. Please can anyone point me to the literature
> on this. Thanks in advance.

See "man sched_setaffinity"

"
The affinity mask is actually a per-thread attribute that can be
adjusted independently for each of the threads in a thread group.  The
value returned  from a call to gettid(2) can be passed in the argument
pid.  Specifying pid as 0 will set the attribute for the calling thread,
and passing the value returned from a call to getpid(2) will set the
attribute for the main thread of the thread group.  (If you  are  using
the  POSIX threads API, then use pthread_setaffinity_np(3) instead of
sched_setaffinity().)
"



The setting of the affinity occurs for the running thread if pid == 0.
Affinity masks are inherited across forks.






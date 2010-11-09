Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab0KIUVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:21:05 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:40167 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490Ab0KIUVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:21:03 -0500
X-ASG-Debug-ID: 1289334055-6b657b9e0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CD9AD22.9030006@fusionio.com>
Date: Tue, 9 Nov 2010 21:20:50 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
CC: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH] ioprio: rcu_read_lock/unlock protect find_task_by_vpid
  call (V2)
References: <20101109102124.GA3916@swordfish.minsk.epam.com> <20101109201557.GS4032@linux.vnet.ibm.com>
X-ASG-Orig-Subj: Re: [PATCH] ioprio: rcu_read_lock/unlock protect find_task_by_vpid
  call (V2)
In-Reply-To: <20101109201557.GS4032@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1289334055
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.1178 1.0000 -1.2867
X-Barracuda-Spam-Score: -1.29
X-Barracuda-Spam-Status: No, SCORE=-1.29 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.46161
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-09 21:15, Paul E. McKenney wrote:
> On Tue, Nov 09, 2010 at 12:21:24PM +0200, Sergey Senozhatsky wrote:
>> Commit 4221a9918e38b7494cee341dda7b7b4bb8c04bde "Add RCU check for
>> find_task_by_vpid()" introduced rcu_lockdep_assert to find_task_by_pid_ns..
>> Assertion failed in sys_ioprio_get. The patch is fixing assertion
>> failure in ioprio_set as well.
>>
>>  kernel/pid.c:419 invoked rcu_dereference_check() without protection!
>>
>>  stack backtrace:
>>  Pid: 4254, comm: iotop Not tainted
>>  Call Trace:
>>  [<ffffffff810656f2>] lockdep_rcu_dereference+0xaa/0xb2
>>  [<ffffffff81053c67>] find_task_by_pid_ns+0x4f/0x68
>>  [<ffffffff81053c9d>] find_task_by_vpid+0x1d/0x1f
>>  [<ffffffff811104e2>] sys_ioprio_get+0x50/0x2da
>>  [<ffffffff81002182>] system_call_fastpath+0x16/0x1b
>>                      
>> V2: rcu critical section expanded according to comment by Paul E. McKenne:
>> | Looking over the patch again, the scope of the RCU read-side critical
>> | section needs to expand to cover the use of the pointer as well as the
>> | call to find_task_by_vpid().
> 
> Thank you, Sergey!
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Jens, are you willing to take this one?

Certainly, thanks guys!

-- 
Jens Axboe


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab0EFJbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 05:31:46 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:54157 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab0EFJbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 05:31:44 -0400
Message-ID: <4BE28C8D.8000408@dcl.info.waseda.ac.jp>
Date: Thu, 06 May 2010 18:31:57 +0900
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
Subject: Re: [PATCH v3] perf lock: add "info" subcommand for dumping misc
 information
References: <4BDE5AFD.6040603@dcl.info.waseda.ac.jp> <1272863520-16179-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100505211053.GG6320@nowhere>
In-Reply-To: <20100505211053.GG6320@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/10 06:10, Frederic Weisbecker wrote:
 > On Mon, May 03, 2010 at 02:12:00PM +0900, Hitoshi Mitake wrote:
 >> Hi Frederic,
 >>
 >> I added "info" subcommand to perf lock,
 >> this can be used as dumping metadata like thread or address of lock 
instances.
 >> "map" was removed because info should do the work of it.
 >>
 >> This will be useful not only for debugging but also for ordinary 
analyzing.
 >>
 >> I made this patch on perf/core of your tree, could you queue this?
 >>
 >> v2: adding example of usage
 >> % sudo ./perf lock info -t
 >>   | Thread ID: comm
 >>   | 	 0: swapper
 >>   |         1: init
 >>   |        18: migration/5
 >>   |        29: events/2
 >>   |        32: events/5
 >>   |        33: events/6
 >> ...
 >>
 >> % sudo ./perf lock info -m
 >> | Address of instance: name of class
 >> |  0xffff8800b95adae0:&(&sighand->siglock)->rlock
 >> |  0xffff8800bbb41ae0:&(&sighand->siglock)->rlock
 >> |  0xffff8800bf165ae0:&(&sighand->siglock)->rlock
 >> |  0xffff8800b9576a98:&p->cred_guard_mutex
 >> |  0xffff8800bb890a08:&(&p->alloc_lock)->rlock
 >> |  0xffff8800b9522a08:&(&p->alloc_lock)->rlock
 >> |  0xffff8800bb8aaa08:&(&p->alloc_lock)->rlock
 >> |  0xffff8800bba72a08:&(&p->alloc_lock)->rlock
 >> |  0xffff8800bf18ea08:&(&p->alloc_lock)->rlock
 >> |  0xffff8800b8a0d8a0:&(&ip->i_lock)->mr_lock
 >> |  0xffff88009bf818a0:&(&ip->i_lock)->mr_lock
 >> |  0xffff88004c66b8a0:&(&ip->i_lock)->mr_lock
 >> |  0xffff8800bb6478a0:&(shost->host_lock)->rlock
 >>
 >> v3: fixed some problems Frederic pointed out
 >>   * better rbtree tracking in dump_threads()
 >>   * removed printf() and used pr_info() and pr_debug()
 >
 >
 >
 > Applied, thanks Hitoshi!
 >

Thanks Frederic!

And I prepared another patch for tracking only specified threads.

I'll send the new patch in this thread later.
But, the new one is not so big and hardly depends on "info -t" patch.
If you think the new patch and previous one should be in single patch,
please tell me. I'll merge them.

Thanks,
	Hitoshi

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab1CQOJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 10:09:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41294 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab1CQOI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 10:08:59 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=MpKEIbNVzpcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=CdYqGkZsO4NgjcsSJgAA:9 a=21QOces148NqF1O3X6jEqYBUhpQA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: um: WARNING: at kernel/futex.c:786 __unqueue_futex
From: Steven Rostedt <rostedt@goodmis.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: laijs@cn.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net, dvhart@linux.intel.com
In-Reply-To: <AANLkTi=e+tM-WTerLmkZfLTQqKCLsJHVBgQ5sj+TMjc4@mail.gmail.com>
References: <AANLkTi=e+tM-WTerLmkZfLTQqKCLsJHVBgQ5sj+TMjc4@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 17 Mar 2011 10:08:56 -0400
Message-ID: <1300370936.16880.96.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 13:25 +0100, richard -rw- weinberger wrote:
> Lai,
> 
> Your commit 2e12978a
> (futex,plist: Pass the real head of the priority list to plist_del())
> triggers gazillions warnings on User Mode Linux (x86, Linus' tree as of today):
> 
> ------------[ cut here ]------------
> WARNING: at kernel/futex.c:786 __unqueue_futex+0x12/0x16()
> Modules linked in:
> 27d4cce8:  [<081c13fe>] dump_stack+0x1c/0x20
> 27d4cd00:  [<08071aa0>] warn_slowpath_common+0x49/0x5f
> 27d4cd18:  [<08071acb>] warn_slowpath_null+0x15/0x19
> 27d4cd28:  [<0808fdb8>] __unqueue_futex+0x12/0x16
> 27d4cd38:  [<0808fef3>] futex_wait+0x137/0x1ed
> 27d4cdd0:  [<080910c3>] do_futex+0x78/0x7c4
> 27d4cedc:  [<080918e6>] sys_futex+0xd7/0xed
> 27d4cf28:  [<0805abf6>] handle_syscall+0x7a/0x98
> 27d4cf78:  [<080685d9>] userspace+0x2c9/0x370
> 27d4cfe0:  [<08058be5>] fork_handler+0x53/0x5b
> 27d4cffc:  [<00000000>] 0x0
> 
> ---[ end trace ed7709f235f82328 ]---
> 
> !spin_is_locked(q->lock_ptr) in the WARN_ON() at line 786
> triggers the warnings.

Crap, I bet you are running CONFIG_SMP=n. I'll test this. We may need to
make that a WARN_ON_SMP().

-- Steve

> 
> I'm not sure whether this shows a bug within UML
> or the WARN_ON() is wrong.
> 
> What do you think?
> 



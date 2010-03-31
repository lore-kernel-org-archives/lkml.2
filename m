Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab0CaWSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 18:18:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754373Ab0CaWSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 18:18:13 -0400
Date: Wed, 31 Mar 2010 15:17:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [2.6.31 and later] "struct pid" leak.
Message-Id: <20100331151719.8a92b302.akpm@linux-foundation.org>
In-Reply-To: <tnxbpe5ygfy.fsf@e102109-lin.cambridge.arm.com>
References: <201003272121.ADE39095.JLFHOOMtSVOFQF@I-love.SAKURA.ne.jp>
	<tnxbpe5ygfy.fsf@e102109-lin.cambridge.arm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Mar 2010 16:31:13 +0100
Catalin Marinas <catalin.marinas@arm.com> wrote:

> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
> > I got below report with 2.6.33.1 .
> >
> > unreferenced object 0xde144600 (size 64):
> >   comm "init", pid 1, jiffies 4294678101 (age 291.508s)
> >   hex dump (first 32 bytes):
> >     02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 04 76 ae de d1 76 43 c0 d6 08 00 00  .....v...vC.....
> >   backtrace:
> >     [<c0481704>] create_object+0x121/0x1ef
> >     [<c05f546b>] kmemleak_alloc+0x25/0x42
> >     [<c047e326>] kmemleak_alloc_recursive+0x1c/0x22
> >     [<c047e36e>] kmem_cache_alloc+0x42/0x68
> >     [<c0437701>] alloc_pid+0x19/0x288
> >     [<c0428acc>] copy_process+0x95a/0xdac
> >     [<c04290d8>] do_fork+0x129/0x261
> >     [<c0407de5>] sys_clone+0x1f/0x24
> >     [<c040292d>] ptregs_clone+0x15/0x28
> >     [<ffffffff>] 0xffffffff
> > unreferenced object 0xdfa96a40 (size 64):
> >   comm "login", pid 2259, jiffies 4294719437 (age 250.179s)
> >   hex dump (first 32 bytes):
> >     02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 60 39 ae de d1 76 43 c0 bb 09 00 00  ....`9...vC.....
> >   backtrace:
> >     [<c0481704>] create_object+0x121/0x1ef
> >     [<c05f546b>] kmemleak_alloc+0x25/0x42
> >     [<c047e326>] kmemleak_alloc_recursive+0x1c/0x22
> >     [<c047e36e>] kmem_cache_alloc+0x42/0x68
> >     [<c0437701>] alloc_pid+0x19/0x288
> >     [<c0428acc>] copy_process+0x95a/0xdac
> >     [<c04290d8>] do_fork+0x129/0x261
> >     [<c0407de5>] sys_clone+0x1f/0x24
> >     [<c040292d>] ptregs_clone+0x15/0x28
> >     [<ffffffff>] 0xffffffff
> 
> I reported similar leaks last year -
> http://lkml.org/lkml/2009/7/8/422. There is some analysis in the thread
> above of the reference counting but I couldn't figure out where it goes
> wrong. It looks to me like there isn't any reference to a struct pid
> block but its reference count is 2.
> 
> There is a bugzilla entry as well -
> https://bugzilla.kernel.org/show_bug.cgi?id=13868
> 

Let's bug some people by cc'ing them ;)

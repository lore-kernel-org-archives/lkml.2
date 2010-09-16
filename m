Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab0IPJ06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 05:26:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab0IPJ05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 05:26:57 -0400
Message-ID: <4C91E2CC.9040709@redhat.com>
Date: Thu, 16 Sep 2010 11:26:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Christopher Yeoh <cyeoh@au1.ibm.com>
CC: Bryan Donlan <bdonlan@gmail.com>, linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH] Cross Memory Attach
References: <20100915104855.41de3ebf@lilo>	<4C90A6C7.9050607@redhat.com>	<AANLkTi=rmUUPCm212Sju-wW==5cT4eqqU+FEP_hX-Z_y@mail.gmail.com> <20100916104819.36d10acb@lilo>
In-Reply-To: <20100916104819.36d10acb@lilo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/16/2010 03:18 AM, Christopher Yeoh wrote:
> On Wed, 15 Sep 2010 23:46:09 +0900
> Bryan Donlan<bdonlan@gmail.com>  wrote:
>
> >  On Wed, Sep 15, 2010 at 19:58, Avi Kivity<avi@redhat.com>  wrote:
> >
> >  >  Instead of those two syscalls, how about a vmfd(pid_t pid, ulong
> >  >  start, ulong len) system call which returns an file descriptor that
> >  >  represents a portion of the process address space.  You can then
> >  >  use preadv() and pwritev() to copy memory, and
> >  >  io_submit(IO_CMD_PREADV) and io_submit(IO_CMD_PWRITEV) for
> >  >  asynchronous variants (especially useful with a dma engine, since
> >  >  that adds latency).
> >  >
> >  >  With some care (and use of mmu_notifiers) you can even mmap() your
> >  >  vmfd and access remote process memory directly.
> >
> >  Rather than introducing a new vmfd() API for this, why not just add
> >  implementations for these more efficient operations to the existing
> >  /proc/$pid/mem interface?
>
> Perhaps I'm misunderstanding something here, but
> accessing /proc/$pid/mem requires ptracing the target process.
> We can't really have all these MPI processes ptraceing each other
> just to send/receive a message....
>

You could have each process open /proc/self/mem and pass the fd using 
SCM_RIGHTS.

That eliminates a race; with copy_to_process(), by the time the pid is 
looked up it might designate a different process.

-- 
error compiling committee.c: too many arguments to function


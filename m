Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab0IPBSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 21:18:31 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:56800 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab0IPBSb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 21:18:31 -0400
Date: Thu, 16 Sep 2010 10:48:19 +0930
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH] Cross Memory Attach
Message-ID: <20100916104819.36d10acb@lilo>
In-Reply-To: <AANLkTi=rmUUPCm212Sju-wW==5cT4eqqU+FEP_hX-Z_y@mail.gmail.com>
References: <20100915104855.41de3ebf@lilo>
	<4C90A6C7.9050607@redhat.com>
	<AANLkTi=rmUUPCm212Sju-wW==5cT4eqqU+FEP_hX-Z_y@mail.gmail.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 23:46:09 +0900
Bryan Donlan <bdonlan@gmail.com> wrote:

> On Wed, Sep 15, 2010 at 19:58, Avi Kivity <avi@redhat.com> wrote:
> 
> > Instead of those two syscalls, how about a vmfd(pid_t pid, ulong
> > start, ulong len) system call which returns an file descriptor that
> > represents a portion of the process address space.  You can then
> > use preadv() and pwritev() to copy memory, and
> > io_submit(IO_CMD_PREADV) and io_submit(IO_CMD_PWRITEV) for
> > asynchronous variants (especially useful with a dma engine, since
> > that adds latency).
> >
> > With some care (and use of mmu_notifiers) you can even mmap() your
> > vmfd and access remote process memory directly.
> 
> Rather than introducing a new vmfd() API for this, why not just add
> implementations for these more efficient operations to the existing
> /proc/$pid/mem interface?

Perhaps I'm misunderstanding something here, but
accessing /proc/$pid/mem requires ptracing the target process.
We can't really have all these MPI processes ptraceing each other
just to send/receive a message....

Regards,

Chris
-- 
cyeoh@au.ibm.com

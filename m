Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab0IPB6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 21:58:13 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49809 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0IPB6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 21:58:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Bryan Donlan <bdonlan@gmail.com>
Subject: Re: [RFC][PATCH] Cross Memory Attach
Cc: kosaki.motohiro@jp.fujitsu.com, Avi Kivity <avi@redhat.com>,
        Christopher Yeoh <cyeoh@au1.ibm.com>, linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <AANLkTi=rmUUPCm212Sju-wW==5cT4eqqU+FEP_hX-Z_y@mail.gmail.com>
References: <4C90A6C7.9050607@redhat.com> <AANLkTi=rmUUPCm212Sju-wW==5cT4eqqU+FEP_hX-Z_y@mail.gmail.com>
Message-Id: <20100916105311.CA00.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 16 Sep 2010 10:58:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Sep 15, 2010 at 19:58, Avi Kivity <avi@redhat.com> wrote:
> 
> > Instead of those two syscalls, how about a vmfd(pid_t pid, ulong start,
> > ulong len) system call which returns an file descriptor that represents a
> > portion of the process address space.  You can then use preadv() and
> > pwritev() to copy memory, and io_submit(IO_CMD_PREADV) and
> > io_submit(IO_CMD_PWRITEV) for asynchronous variants (especially useful with
> > a dma engine, since that adds latency).
> >
> > With some care (and use of mmu_notifiers) you can even mmap() your vmfd and
> > access remote process memory directly.
> 
> Rather than introducing a new vmfd() API for this, why not just add
> implementations for these more efficient operations to the existing
> /proc/$pid/mem interface?

As far as I heared from my friend, old HP MPI implementation used /proc/$pid/mem
for this purpose. (I don't know current status). However almost implementation
doesn't do that because /proc/$pid/mem required the process is ptraced.
As far as I understand , very old /proc/$pid/mem doesn't require it. but It changed
for security concern. Then, Anybody haven't want to change this interface because
they worry break security.

But, I don't know what exactly protected "the process is ptraced" check. If anyone
explain the reason and we can remove it. I'm not againt at all.




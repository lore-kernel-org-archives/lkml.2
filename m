Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab2EAGkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 02:40:31 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44626 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab2EAGka convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 02:40:30 -0400
MIME-Version: 1.0
In-Reply-To: <CANkdjvZinRvHYPKLCFsd6z3FXgM4ScS1Ar9OjO3s1SLDFnridw@mail.gmail.com>
References: <CANkdjvZinRvHYPKLCFsd6z3FXgM4ScS1Ar9OjO3s1SLDFnridw@mail.gmail.com>
Date: Tue, 1 May 2012 16:40:29 +1000
Message-ID: <CAPa8GCBdVXx+iF9QAoURWchAY0avesYNwbQs_Do1Kn6Pyx+8+Q@mail.gmail.com>
Subject: Re: read() syscall slowing down due to other threads?
From: Nick Piggin <npiggin@gmail.com>
To: George Porter <gmporter@cs.ucsd.edu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 May 2012 16:03, George Porter <gmporter@cs.ucsd.edu> wrote:
> Hi all,
>
> I've run into a weird phenomenon I was hoping someone could help me pin down.
>
> I've got a multithreaded program which reads data off of 8 input
> disks, and does some processing on it.  I have 8 Reader threads, each
> of which reads data off of one of the eight input disks.  That data
> gets passed to other threads, which do some processing (this is an 8
> core machine).  If I do no or minimal processing in those other
> threads, the read() calls go at the speed of the disks (~100 MBps).  I
> measure that speed by taking a timestamp before the read syscall, then
> afterwards, and dividing that into the read size (5MB).  All seems
> good.
>
> However, if I start doing more computation on those other threads, the
> read() syscalls take longer to read the same amount of data,
> eventually slowing down to 50 MBps (50% slower).  I've used
> setaffinity() to isolate the Reader threads to one set of cores, and
> the compute threads to a different set of cores, and so I don't think
> it is CPU/scheduling interference.
>
> Thoughts?  Has anyone run into this before?

It could be memory or coherency traffic that's causing a slowdown across
the system?

Could a dynamic core frequency / thermal throttling explain any of the
slowdown?

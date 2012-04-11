Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759851Ab2DKAMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 20:12:40 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35423 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab2DKAMi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 20:12:38 -0400
MIME-Version: 1.0
In-Reply-To: <87r4vzjl0r.fsf@blp.benpfaff.org>
References: <20120401125741.GA7484@p183.telecom.by> <4F78D0BA.9040709@zytor.com>
 <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com>
 <4F7F1864.8090606@zytor.com> <87r4vzjl0r.fsf@blp.benpfaff.org>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 10 Apr 2012 20:12:17 -0400
Message-ID: <CAHGf_=qkdUBYVTGzqpmmviCsn93gPFEKeS8eZR2fNN-d0NdYpQ@mail.gmail.com>
Subject: Re: [PATCH] nextfd(2)
To: Ben Pfaff <blp@cs.stanford.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 7, 2012 at 5:21 PM, Ben Pfaff <blp@cs.stanford.edu> wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
>
>> On 04/06/2012 02:54 AM, Alexey Dobriyan wrote:
>>>
>>> Without proc knowledge about fdtable is gathered linearly and still unreliable.
>>> With nextfd(2), even procful environments could lose several failure branches.
>>> And they can keep old dumb fd++ or smart /proc/self/fd loops for a change.
>>>
>>
>> Incidentally, if we were to create a system call for this -- which I so
>> far see no reason for -- I would make it return a select-style bitmask
>> of file descriptors in use, not a "next fd" which would require a system
>> call per iteration.
>
> It's already possible to do something a little like that with the
> existing "poll" system call:
>
> #include <stdio.h>
> #include <sys/poll.h>
>
> int
> main(void)
> {
>  enum { N_FDS = 1024 };
>  struct pollfd fds[N_FDS];

Your code has a muximum fd assumption here. that is one of that we
really want to avoid.

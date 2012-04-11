Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759853Ab2DKAKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 20:10:20 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64138 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759833Ab2DKAKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 20:10:17 -0400
MIME-Version: 1.0
In-Reply-To: <4F7F1864.8090606@zytor.com>
References: <20120401125741.GA7484@p183.telecom.by> <4F78D0BA.9040709@zytor.com>
 <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com> <4F7F1864.8090606@zytor.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 10 Apr 2012 20:09:56 -0400
Message-ID: <CAHGf_=rsJ8o8Fnd2z5Z8jHGc=cz370ay0_t3bhkiYRCBh3puVw@mail.gmail.com>
Subject: Re: [PATCH] nextfd(2)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        drepper@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 12:23 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/06/2012 02:54 AM, Alexey Dobriyan wrote:
>>
>> Without proc knowledge about fdtable is gathered linearly and still unreliable.
>> With nextfd(2), even procful environments could lose several failure branches.
>> And they can keep old dumb fd++ or smart /proc/self/fd loops for a change.
>>
>
> Incidentally, if we were to create a system call for this -- which I so
> far see no reason for -- I would make it return a select-style bitmask
> of file descriptors in use, not a "next fd" which would require a system
> call per iteration.

I know the reason. fcntl(F_NEXT) is one of a proposal of next SUS enhancement.

  http://austingroupbugs.net/view.php?id=149

nextfd() has a semantics of F_NEXT.

Next, why shoundn't we implement fcntl(F_NEXT) in our kernel? I think
we have two reason.

1) As linus pointed out, linux specific "flags" argument may be useful.
2) The name of F_NEXT is not fixed yet. another url of the austin says
it is FD_NEXT.
     So, we can't choose right name yet. Moreover, A meanings of 3rd
argument of F_NEXT
     haven't been fixed.


I dont think following #ifdef is insane. but glibc also can provide
correct F_NEXT when next SUS is published.

#ifdef FOO
#define NEXTFD(fd) nextfd(fd, flags)
#else
#define NEXTFD(fd) fcntl(fd, F_NEXT, O_FDWR)
#endif


In short, kernel developer don't care any standard at all. but
application programmer usually care it.

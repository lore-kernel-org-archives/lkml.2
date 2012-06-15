Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab2FOD5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 23:57:43 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44781 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab2FOD5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 23:57:41 -0400
MIME-Version: 1.0
In-Reply-To: <CABfYdSpnAB6mHWSjy91wvUB91vb74a1JG=TVxKh4XwAvKqeKiQ@mail.gmail.com>
References: <1338332348-3469-1-git-send-email-filbranden@gmail.com>
	<1339464499-10270-2-git-send-email-filbranden@gmail.com>
	<20120612161946.GA11244@redhat.com>
	<CABfYdSpnAB6mHWSjy91wvUB91vb74a1JG=TVxKh4XwAvKqeKiQ@mail.gmail.com>
Date: Thu, 14 Jun 2012 23:57:41 -0400
Message-ID: <CABe66sUm966WHSMuDLHkWxiREsEdBCu+tPY=geYQugQ2xVGyJw@mail.gmail.com>
Subject: Re: [PATCHv2 1/1] prctl: move pdeath_signal from task_struct to signal_struct
From: Filipe Brandenburger <filbranden@gmail.com>
To: Albert Cahalan <acahalan@gmail.com>,
        David Wilcox <davidvsthegiant@gmail.com>,
        "Adam H. Peterson" <AlphaEtaPi@hotmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 13, 2012 at 11:46 AM, Albert Cahalan <acahalan@gmail.com> wrote:
>> On 06/11, Filipe Brandenburger wrote:
>>> Documentation clearly states that PR_SET_PDEATHSIG and PR_GET_PDEATHSIG should
>>> act on processes, in particular case #1 is very counter intuitive because the
>>> child process should not care whether the parent is multi-threaded or not.
>
> You are assuming that the child and parent are normal separate
> applications, developed by separate people, with one just being
> run by the other. That is actually the odd case AFAIK, because
> why then would there be reason to care about parent death?
> The more normal case IMHO is that the child and parent are
> deeply aware of each other. Most likely they are the same program.
>
> In my case I have an in-process emulator, kind of like valgrind,
> that uses real threads for accuracy and performance. It makes
> extra threads for monitoring and control. These extra threads
> keep an eye on the app being examined; obviously none of this
> would work if the death signal were not per-thread.
>
> Fix the documentation to match reality, then add a per-process one
> if there is any use for it. I don't think I've ever seen use for a
> per-process death signal, so perhaps it shouldn't be added even
> though it does make sense.

The issue I have with the current implementation is that it's non
obvious, it has some quite awkward corner cases (see
https://bugzilla.kernel.org/show_bug.cgi?id=43300) and it ends up
exposing implementation details of the Linux kernel that should not
really be that visible to userland...

But I don't really have a strong case for needing this change, I only
got involved on it through the Bugzilla report, it struck me as odd...

I'm copying David Wilcox who opened the Bugzilla issue and Adam
Peterson who commented on the issue, they both seem to have use cases
for the code to match the documentation, they might be able to give
better arguments of why they would like to have this behavior changed.

Thanks,
Filipe

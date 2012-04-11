Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222Ab2DKUX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:23:58 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42116 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933207Ab2DKUXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:23:54 -0400
MIME-Version: 1.0
In-Reply-To: <4F85E045.9070706@zytor.com>
References: <20120401125741.GA7484@p183.telecom.by> <4F78D0BA.9040709@zytor.com>
 <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com>
 <4F7F1864.8090606@zytor.com> <CAHGf_=rsJ8o8Fnd2z5Z8jHGc=cz370ay0_t3bhkiYRCBh3puVw@mail.gmail.com>
 <4F85C640.3060608@zytor.com> <CA+55aFzT1OomhJkDx+crnqRmH-kowAM4w8SRqsmPVMyh8gEwZQ@mail.gmail.com>
 <4F85C96B.2070803@zytor.com> <CAHGf_=qBY1uVqWiDoOQY5UrxqK8G47+J_o=HQAbutGZNdhX5Ug@mail.gmail.com>
 <4F85E045.9070706@zytor.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 11 Apr 2012 16:23:34 -0400
Message-ID: <CAHGf_=pjksePXKsnfmxBC1BNgd_jDuy=-q9WMvM4UHjKi_fPaQ@mail.gmail.com>
Subject: Re: [PATCH] nextfd(2)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> a) inherently racy in a multithreaded environment;
>>
>> I would say two things. 1) I know and I agree we _can_ misuse the interface.
>> but many already existed interface also can be misused. 2) As I
>> already explained
>> this can be used correctly.
>>
>> So, I have a question. Why do you bother a possibility of misuse? Of
>> if you didn't point out misuse, can you please point out a real world
>> use case of multi threads + fd interation?
>
> This were brought up in the POSIX discussion as part of why these
> interfaces were considered undesirable.

Hmmm.... I'm sorry I don't find "considered undesirable". Maybe because
my English is not very good. can you please help me clarify?

This text says,


> so a future revision of the standard may indeed add fdwalk( ), although no
> one in the meeting was willing to draft a proposal for fdwalk( ) at this time

and, later says after noting F_NEXT and O_CLOEXEC,

>Therefore, the rest of this proposal seeks to document the problem
>with closing arbitrary file descriptors, and a new bugid will be
>opened to propose standardizing some recent interfaces and interface
>extensions first appearing in Linux

Do you think latter override former?



>>> b) unsafe because there might be file descriptors used by libc itself.
>>
>> I agree this. Even though almost developer don't use libc message catalogue and
>> we can avoid such issue by using nextfd() + fcntl(O_CLOEXEC).
>
> No, that's exactly the point that we cannot.

I thknk we are talking different aspect. I'm talking practical issue.
say, ruby hit the exact same issue
because valgrind uses internal fds and they don't think their exec()
case don't need fd
inheritance. Even though it close libc internal fds, invoked new
executable may open them
again at process strtup code. Therefore, they are using O_CLOEXEC. In
the other hands,
you seems talking about it is corner case. If so, I agree. I was not
argue it. I only say, I
haven't seen real world application require it.

Personally, I'm only interesting real world issue.


>> Yeah, I don't think fdwalk() is problematic. It's an option if I
>> understand Alexey's mail
>> correctly. but I disagree almost all developers should fix a design
>> and rewrite their
>> applications. In theory, they can avoid glibc or they can rewrite all
>> of their code or
>> avoid linux. but there is one problem. unrealistic.
>>
>
> The problem -- as was brought up in the POSIX discussion -- is that you
> actually end up breaking *properly functioning programs*.

But the url only talk about a possibility of misuse.

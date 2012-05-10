Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab2EJBNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 21:13:31 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40312 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab2EJBNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 21:13:30 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxN9QoJ_NTzeU+tPa-gJvHBQ5Oa5O0Ko95-iaNh5XCUGw@mail.gmail.com>
References: <CAHo-OoxRj-sP1Tcy3oJ7DE3BOGSTnsWHZ5Q3hdmnK8A5jfjFcQ@mail.gmail.com>
 <CA+55aFzY+W3ECUnyvqU_Su8_2TFqYj-K7U40KZaoe61oDUGdxw@mail.gmail.com>
 <CAHo-OoxwSNFVCvdBxnMruKMebMW37NLX7eOKkLx=R7cSkhknGw@mail.gmail.com>
 <CA+55aFyrSNTh3B7L=Lq1L_Hz=0NEPC95TWmo2-W9odKi+80XJg@mail.gmail.com>
 <CAHo-OowjvXat8dZOpp50GO_KSTYBy_Wa96wvFUfTXmua3oBrUw@mail.gmail.com>
 <CA+55aFyXP8PRusYYrpAnFfV=eL69ktfQfiGxAH1B-Ds8HH+bJQ@mail.gmail.com>
 <CAHo-Ooyr=ugLDv6gSVTn_N0tb79BtgWGU87MrtVY9UF-ch9YCw@mail.gmail.com> <CA+55aFxN9QoJ_NTzeU+tPa-gJvHBQ5Oa5O0Ko95-iaNh5XCUGw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 9 May 2012 18:13:08 -0700
X-Google-Sender-Auth: lnpDoOCSU2tu0kwxxIna3qxX_NY
Message-ID: <CA+55aFxjq_zEVWVQ9dTm6gjozVZXTYbnciUiPdBsr7g3RSBWwg@mail.gmail.com>
Subject: Re: setuid and RLIMIT_NPROC and 3.1+
To: =?ISO-8859-2?Q?Maciej_=AFenczykowski?= <zenczykowski@gmail.com>
Cc: James Morris <jmorris@namei.org>, Neil Brown <neilb@suse.de>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh christ, I also cannot be bothered to continue arguing with you
since you seemingly randomly drop other people from the discussion.

So don't expect any more replies from me.

                    Linus

On Wed, May 9, 2012 at 6:10 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, May 9, 2012 at 5:47 PM, Maciej Żenczykowski
> <zenczykowski@gmail.com> wrote:
>>
>> If you return EAGAIN from setuid, because we've run into the hard
>> limit, and userspace doesn't check it, then the exec will still
>> succeed, and we'll end up running the exec'ed code as root.
>
> But how would that happen in practice, and why would we care?
>
> If the application is buggy, it won't check the setuid() error return,
> but if it does the exec, it will fail.
>
> Only a buggy *and*malicious* application that *first* does non-exec
> cases up until it hits the hard limit and *then* tries to do a buggy
> setuid() - without testing the error value - and exec() would care.
>
> But we don't care about applications that *try* to be actively buggy.
> That simply isn't the interesting case. The point of the whole "return
> error at execve()" was not to discourage the actively buggy usage
> case, but the *accidentally* buggy case. And there's no sane way the
> accidentally buggy case can trigger what you describe.
>
> So the whole point wasn't that it "fixes" buggy applications (they
> are, after all, buggy), but that it makes it less likely to have
> accidental problems. It's a "softer" edge to some bugs.
>
> That said, I don't really care that much about the original patch
> either. For all I care, we could revert it. I just simply don't
> understand the point of your objections.
>
>                          Linus

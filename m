Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab2GNFBK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 01:01:10 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64949 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab2GNFAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 01:00:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120714044438.GA7718@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
 <1341859315-17759-6-git-send-email-tj@kernel.org> <20120714035538.GB5638@dhcp-172-17-108-109.mtv.corp.google.com>
 <CA+55aFyeauqCqrWsx4U2TB2ENrugZXYj+4vw3Fd0kGaeWBP3RA@mail.gmail.com> <20120714044438.GA7718@dhcp-172-17-108-109.mtv.corp.google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jul 2012 22:00:10 -0700
X-Google-Sender-Auth: 7Ql3sfWOnEiltgGxNc0v2ixFBcc
Message-ID: <CA+55aFyozbYJh4vRLCCkk5j86XEasngvWkKmL4WpBjiCB5050g@mail.gmail.com>
Subject: Re: [PATCH 5/6] workqueue: introduce NR_WORKER_POOLS and for_each_worker_pool()
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, joshhunt00@gmail.com, axboe@kernel.dk,
        rni@google.com, vgoyal@redhat.com, vwadekar@nvidia.com,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, swhiteho@redhat.com, bpm@sgi.com,
        elder@kernel.org, xfs@oss.sgi.com, marcel@holtmann.org,
        gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, martin.petersen@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 9:44 PM, Tejun Heo <tj@kernel.org> wrote:
>
> nr_running is atomic_t (*nr_running)[2].  Ignoring the pointer to
> array part, it's just returning the address of N'th element of the
> array.  ARRAY + N == &ARRAY[N].

None of this matters one whit.

You did "&(x)[0]".

That's insane. It's crazy. It doesn't even matter what "x" is in
between, it's crazy regardless.

It's just a really confused way of saying "x" (*). Except it makes the
code look like an insane monkey on crack got a-hold of your keyboard
when you weren't looking.

And to make it worse, "x" itself was the result of doing "*&y". Which
was probably written by the insane monkey's older brother, Max, who
has been chewing Quaaludes for a few years, and as a result _his_
brain really isn't doing too well either. Even for a monkey. And now
you're letting *him* at your keyboard too?

So you had two separately (but similarly) insane ways of complicating
the code so that it was really obfuscated. When it really just
computed "y" to begin with, it just added all those "x=*&y" and
"&(x)[0]" games around it to make it look complicated.

            Linus

(*) Technically, "&(x)[0]" is actually a really confused way of saying
"(x+0)" while making sure that "x" was a valid pointer. It basically
guarantees that if "x" started out as an array, it has now been
demoted to a pointer - but since arrays will be demoted to pointers by
pretty much any subsequent operation except for "sizeof()" and a
couple of other special cases anyway, you can pretty much just say
that "&(x)[0]" is "(x+0)" is "x".

And "*&y" really is exactly the same as "y", except for again some
syntactic checking (ie it is basically an odd way to verify that "y"
is an lvalue, since you cannot do an address-of of a non-lvalue).

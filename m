Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab2KGPK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 10:10:29 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:36070 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab2KGPK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 10:10:28 -0500
MIME-Version: 1.0
In-Reply-To: <20121107093246.GD21960@thunk.org>
References: <20121107001609.9B7A9100047@wpzn3.hot.corp.google.com>
	<CAGXu5jJ779UvpZwO-fi7-m+i=OfqwgXh1PC4GNwjhfD9GD82wQ@mail.gmail.com>
	<20121107093246.GD21960@thunk.org>
Date: Wed, 7 Nov 2012 07:10:27 -0800
X-Google-Sender-Auth: m1Umpn-FY0W0J8MgZBa_Tkm3qlY
Message-ID: <CAGXu5jKY9SdZU7BibZf9kLx-MO3tVASPWE2hHZJXSPRkWfivKQ@mail.gmail.com>
Subject: Re: + binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
 added to -mm tree
From: Kees Cook <keescook@chromium.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Kees Cook <keescook@chromium.org>,
        akpm@linux-foundation.org, jeff.liu@oracle.com, aedilger@gmail.com,
        alan@linux.intel.com, gregkh@linuxfoundation.org, jakub@redhat.com,
        james.l.morris@oracle.com, john.sobecki@oracle.com,
        viro@zeniv.linux.org.uk, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 1:32 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Nov 06, 2012 at 05:11:17PM -0800, Kees Cook wrote:
>> Hrm, I don't like this. get_random_int() specifically says: "Get a
>> random word for internal kernel use only." The intent of AT_RANDOM is
>> for userspace pRNG seeding (though glibc currently uses it directly
>> for stack protector and pointer mangling), which is not "internal
>> kernel use only". :) Though I suppose this is already being used for
>> the randomize_stack_top(), but I think it'd still be better to use
>> higher quality bits.
>
> Well, in practice, right now, get_random_int() is only being used for
> different cases of ASLR of one variety or another (either by the
> kernel in exec or mmap, or in userspace).  So I'm not sure it really
> is a major issue.

Hrm, yes. I see that the network code uses random32, not
get_random_int(). How are these different? Is one demonstrably better?

> If we also change get_random_int() to use a more secure cryptographic
> random generator (i.e., maybe AES instead of MD5), would that be
> sufficient to address your concerns?  We're not using get_random_int()
> for anything that's timing sensitive, so that shouldn't be a problem.

I wonder if using AES would have a measurable impact on fork speeds?

> Or maybe we should just add an explicit CRNG set of routines (like the
> similar discussions to make an explicitly named PRNG set of routines),
> so callers can use whatever random number generator is appropriate for
> their performance and security needs.

If we do use get_random_int() here, I'd at least like to see its
comment changed to reflect its actual purpose (since it's not
"internal use only") as well as its expected unpredictability. (This
would help document the utility of get_random_bytes() vs
get_random_int() vs random32().)

-Kees

-- 
Kees Cook
Chrome OS Security

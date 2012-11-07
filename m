Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab2KGJdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:33:04 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:59764 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626Ab2KGJdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:33:02 -0500
Date: Wed, 7 Nov 2012 04:32:46 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Kees Cook <keescook@chromium.org>
Cc: akpm@linux-foundation.org, jeff.liu@oracle.com, aedilger@gmail.com,
        alan@linux.intel.com, arnn@arndb.de, drepper@redhat.com,
        gregkh@linuxfoundation.org, jakub@redhat.com,
        james.l.morris@oracle.com, john.sobecki@oracle.com,
        viro@zeniv.linux.org.uk, LKML <linux-kernel@vger.kernel.org>
Subject: Re: + binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
 added to -mm tree
Message-ID: <20121107093246.GD21960@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Kees Cook <keescook@chromium.org>, akpm@linux-foundation.org,
	jeff.liu@oracle.com, aedilger@gmail.com, alan@linux.intel.com,
	arnn@arndb.de, drepper@redhat.com, gregkh@linuxfoundation.org,
	jakub@redhat.com, james.l.morris@oracle.com,
	john.sobecki@oracle.com, viro@zeniv.linux.org.uk,
	LKML <linux-kernel@vger.kernel.org>
References: <20121107001609.9B7A9100047@wpzn3.hot.corp.google.com>
 <CAGXu5jJ779UvpZwO-fi7-m+i=OfqwgXh1PC4GNwjhfD9GD82wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ779UvpZwO-fi7-m+i=OfqwgXh1PC4GNwjhfD9GD82wQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 05:11:17PM -0800, Kees Cook wrote:
> Hrm, I don't like this. get_random_int() specifically says: "Get a
> random word for internal kernel use only." The intent of AT_RANDOM is
> for userspace pRNG seeding (though glibc currently uses it directly
> for stack protector and pointer mangling), which is not "internal
> kernel use only". :) Though I suppose this is already being used for
> the randomize_stack_top(), but I think it'd still be better to use
> higher quality bits.

Well, in practice, right now, get_random_int() is only being used for
different cases of ASLR of one variety or another (either by the
kernel in exec or mmap, or in userspace).  So I'm not sure it really
is a major issue.  

If we also change get_random_int() to use a more secure cryptographic
random generator (i.e., maybe AES instead of MD5), would that be
sufficient to address your concerns?  We're not using get_random_int()
for anything that's timing sensitive, so that shouldn't be a problem.

Or maybe we should just add an explicit CRNG set of routines (like the
similar discussions to make an explicitly named PRNG set of routines),
so callers can use whatever random number generator is appropriate for
their performance and security needs.

						- Ted

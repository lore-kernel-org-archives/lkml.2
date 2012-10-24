Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326Ab2JXLaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:30:00 -0400
Received: from ozlabs.org ([203.10.76.45]:57645 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758243Ab2JXL3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:29:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
        torvalds@linux-foundation.org,
        "Kasatkin\, Dmitry" <dmitry.kasatkin@intel.com>,
        "Mimi Zohar" <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH] MODSIGN: Move the magic string to the end of a module and eliminate the search
In-Reply-To: <17155.1350913326@warthog.procyon.org.uk>
References: <874nlnjowo.fsf@rustcorp.com.au> <20121020001928.24141.30477.stgit@warthog.procyon.org.uk> <17155.1350913326@warthog.procyon.org.uk>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 24 Oct 2012 11:43:57 +1030
Message-ID: <87liewoene.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:
> Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>> Meh, I really wanted to separate the module signature locating (my
>> problem) from the decoding and checking (your problem).
>
> You could split mod_verify_sig() at the:
>
> 	/* For the moment, only support RSA and X.509 identifiers */
>
> comment.  At that point we have verified the size fields of the
> module_signature struct and we have determined mod, modlen and sig.
>
> Assuming a detached signature is going to look the same as an attached
> signature, just without the magic number[1], then you can duplicate the first
> part of mod_verify_sig() with the size checks.
>
> [1] The signature may need to be kept small to make sure it will fit within an
>     xattr, just in case the host fs has limits.
>
>> If we're going to require such a header, we can simplify further (untested!).
>
> Do we want to require that a detached signature be exactly the same as an
> appended signature, structure, magic string and all?

AFAICT the IMA patches already have an xattr format they use for every
other file, they'll want the same thing here.

> I'm also slightly against copying the magic string to the stack if we can avoid
> it as the compiler can't recover the space before calling mod_verify_sig().
> Besides, there's no particular need to copy the magic string.

You're the one who made this new format up, I'm just trying to clean it.

If the module has to end in 'struct sig' then 'string', the put that in
the damn struct definition.  structs are a great, readable way for
programmers to know how something is laid out.  Use them.

I'll hand this one, it's just a cleanup.

>> BTW, I'm not convinced your use of bitfields here is portable; it may be
>> portable enough for Linux though.
>
> I consulted a gcc engineer and he suggested that it's arch dependent, so I
> should probably use u8.  Since the enums are basically int-sized types, the
> compiler might reorder them depending on endianness and might insert a byte of
> padding.
>
> It's just that I prefer the enums for documentary sake.

I prefer enums too, but it'd suck to fix this later.

Patch appreciated,
Rusty.

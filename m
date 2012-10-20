Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab2JTEOw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 00:14:52 -0400
Received: from ozlabs.org ([203.10.76.45]:59012 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab2JTEOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 00:14:50 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RFC: sign the modules at install time
In-Reply-To: <20121019142147.76f67505862afe5614167428@canb.auug.org.au>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com> <87txtso9xw.fsf@rustcorp.com.au> <CA+55aFxZdtD51AVKLtKK95ooh8VB8-5Tt8nHsxSUT67CBRrp2g@mail.gmail.com> <871ugwny1n.fsf@rustcorp.com.au> <CA+55aFwTz6xadNL37H6Qb8+rWNefn0cQ0URFPfD=Ea=J54xzGg@mail.gmail.com> <87fw5bp858.fsf@rustcorp.com.au> <20121019142147.76f67505862afe5614167428@canb.auug.org.au>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Sat, 20 Oct 2012 14:23:49 +1030
Message-ID: <87sj993ik2.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:
> Hi Rusty,
>
> On Fri, 19 Oct 2012 11:53:15 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
>>
>> Linus Torvalds <torvalds@linux-foundation.org> writes:
>> > On Wed, Oct 17, 2012 at 10:34 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> >>
>> >> Hacking the keyid and signer-name to be extracted every time by
>> >> sign-file takes my modules_install time from 18.6 seconds to 19.1.  We'd
>> >> get that back easily by making sign-file a perl script anyway; it calls
>> >> out to perl 3 times already.
>> >
>> > Ok, that tiny slowdown seems worth the cleanup, especially if we'd get
>> > it back from somebody re-writing it in perl.
>> >
>> > Want to sign off on the two patches, or put them in your git tree?
>> 
>> Smerged them together: no point moving the x509keyid script now.
>> I dropped the optional dst arg, since we don't use it.
>
> So, this still generates the keys during the normal build, right?  That
> would be a problem for build servers that have limited randomness
> available to them, I think.

Yes.  You can either continue to disable module signatures, or copy some
pre-made keys in the toplevel: signing_key.priv and signing_key.x509.

Cheers,
Rusty.

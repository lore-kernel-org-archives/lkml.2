Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab2JSC2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:28:23 -0400
Received: from ozlabs.org ([203.10.76.45]:56457 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab2JSC2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:28:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Josh Boyer <jwboyer@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RFC: sign the modules at install time
In-Reply-To: <CA+5PVA4fE7uaxNobBMtUs7QUWA2XfM_2oKtLhb7DFRisJLy+4Q@mail.gmail.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com> <87txtso9xw.fsf@rustcorp.com.au> <CA+55aFxZdtD51AVKLtKK95ooh8VB8-5Tt8nHsxSUT67CBRrp2g@mail.gmail.com> <871ugwny1n.fsf@rustcorp.com.au> <CA+55aFwTz6xadNL37H6Qb8+rWNefn0cQ0URFPfD=Ea=J54xzGg@mail.gmail.com> <CA+5PVA4fE7uaxNobBMtUs7QUWA2XfM_2oKtLhb7DFRisJLy+4Q@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 19 Oct 2012 11:46:04 +1030
Message-ID: <87ipa7p8h7.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer <jwboyer@gmail.com> writes:
> On Thu, Oct 18, 2012 at 2:46 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Wed, Oct 17, 2012 at 10:34 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>>
>>> Hacking the keyid and signer-name to be extracted every time by
>>> sign-file takes my modules_install time from 18.6 seconds to 19.1.  We'd
>>> get that back easily by making sign-file a perl script anyway; it calls
>>> out to perl 3 times already.
>>
>> Ok, that tiny slowdown seems worth the cleanup, especially if we'd get
>> it back from somebody re-writing it in perl.
>>
>> Want to sign off on the two patches, or put them in your git tree?
>
> I tested Rusty's version of the 'sign modules at module_install time'
> patch in a Fedora kernel build today.  It seems to work well enough,
> even if we wind up signing things twice.  A brief cleanup of my patch
> to add a modules_sign target on top of that is below.

I'm surprised.  Only the first signature (create on the unstripped
module) will be used by the kernel; this should fail to verify the
stripped module.  A quick and dirty check is:

grep -abo '~Module' /tmp/mod/lib/modules/3.7.0-rc1+/kernel/sound/pci/snd-intel8x0.ko
39828:~Module
40432:~Module

Perhaps eu-strip actually strips the appended signature?

> It might even be able to be moved entirely into scripts/Makefile.modinst
> but I haven't gotten that far yet.

I'll leave this for the moment.

Cheers,
Rusty.

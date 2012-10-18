Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab2JREmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 00:42:08 -0400
Received: from ozlabs.org ([203.10.76.45]:42918 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab2JREmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 00:42:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Cc: David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jwboyer@redhat.com, pjones@redhat.com
Subject: Re: RFC: sign the modules at install time
In-Reply-To: <CA+55aFzEH1jguw8NB90si2uxvyO63FuKPOc8wiEPRCYwruSzRg@mail.gmail.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com> <3179.1350512382@warthog.procyon.org.uk> <CA+55aFzEH1jguw8NB90si2uxvyO63FuKPOc8wiEPRCYwruSzRg@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 18 Oct 2012 15:01:08 +1030
Message-ID: <87a9vko0z7.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
> On Wed, Oct 17, 2012 at 3:19 PM, David Howells <dhowells@redhat.com> wrote:
>>
>> It's probably even better to just get rid of all the automatic module signing
>> stuff completely and leave the sign-file script for the builder to use
>> manually.  The module verification code will still be present.
>
> That's just disgusting crazy talk.
>
> Christ, David, get a grip on yourself. You seem to dismiss the "people
> want to build their own kernel" people entirely.
>
> One of the main sane use-cases for module signing is:
>
>  - CONFIG_CHECK_SIGNATURE=y
>  - randomly generated one-time key
>  - "make modules_install; make install"
>  - "make clean" to get rid of the keys.
>  - reboot.
>
> and now you have a custom kernel that has the convenience of modules,
> yet is basically as safe as a non-modular build. The above makes it
> much harder for any kind of root-kit module to be loaded, and
> basically entirely avoids one fundamental security scare of modules.

If you only want this, we could SHA all the built modules, put that in
the kernel, and verify the module being loaded matches one of them.

Sure, it means a bit of trickery to get the module sums into the
bzImage, but the rest is trivial.

Cheers,
Rusty.

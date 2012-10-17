Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab2JQWov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 18:44:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48026 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab2JQWou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 18:44:50 -0400
MIME-Version: 1.0
In-Reply-To: <3179.1350512382@warthog.procyon.org.uk>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
 <3179.1350512382@warthog.procyon.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 17 Oct 2012 15:44:28 -0700
X-Google-Sender-Auth: OqkuJ1DRcCDPqOVGOXUtSJLHPAQ
Message-ID: <CA+55aFzEH1jguw8NB90si2uxvyO63FuKPOc8wiEPRCYwruSzRg@mail.gmail.com>
Subject: Re: RFC: sign the modules at install time
To: David Howells <dhowells@redhat.com>
Cc: David Miller <davem@davemloft.net>, Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jwboyer@redhat.com, pjones@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 3:19 PM, David Howells <dhowells@redhat.com> wrote:
>
> It's probably even better to just get rid of all the automatic module signing
> stuff completely and leave the sign-file script for the builder to use
> manually.  The module verification code will still be present.

That's just disgusting crazy talk.

Christ, David, get a grip on yourself. You seem to dismiss the "people
want to build their own kernel" people entirely.

One of the main sane use-cases for module signing is:

 - CONFIG_CHECK_SIGNATURE=y
 - randomly generated one-time key
 - "make modules_install; make install"
 - "make clean" to get rid of the keys.
 - reboot.

and now you have a custom kernel that has the convenience of modules,
yet is basically as safe as a non-modular build. The above makes it
much harder for any kind of root-kit module to be loaded, and
basically entirely avoids one fundamental security scare of modules.

Everything else is garbage and should largely be ignored. Distro
people who want to use magic distro keys can do whatever the hell they
want with their modules, they'll have a separate packaging phase
anyway for their secret keys - and they'll have to do it separately
anyway just to keep their private key safe.

And the UEFI "we only boot kernels signed by microsoft keys" case is
just BS, and while it might be useful for some people, it's more
likely to be a pain.

In contrast, the case I outlined above is about true *security*, not
some "vendor control" bullshit. And THAT is the case that kernel
developers should encourage: using cryptography to secure individual
users, instead of controlling things for others.

Quite frankly, your "get rid of all the automatic module signing stuff
completely" answer makes me think that your agenda is fundamentally
flawed. Module signing is *not* about some magic redhat or microsoft
key, and anybody who thinks it *should* be about that should seriously
rethink their position.

In fact, if I believed this was about redhat or microsoft keys, I
would never have merged the code at all.

              Linus

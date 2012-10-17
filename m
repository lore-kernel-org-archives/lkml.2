Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab2JQXUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 19:20:53 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53500 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab2JQXUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 19:20:52 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFw0q-QMPJj2KZrawUZa9ikR85SiB2nUFmBKcWQtfeLbSA@mail.gmail.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
	<CA+5PVA7nio3D2sivVV6h7_gHEsehhMb5_Y=GTwsov3dEmkhtUQ@mail.gmail.com>
	<CA+55aFw0q-QMPJj2KZrawUZa9ikR85SiB2nUFmBKcWQtfeLbSA@mail.gmail.com>
Date: Wed, 17 Oct 2012 19:20:51 -0400
Message-ID: <CA+5PVA5TRAo7zu--_jd7yAqsSVHH9pdxkPh4v=rtfXTZVub0Zg@mail.gmail.com>
Subject: Re: RFC: sign the modules at install time
From: Josh Boyer <jwboyer@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 7:07 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Oct 17, 2012 at 3:26 PM, Josh Boyer <jwboyer@gmail.com> wrote:
>>
>> The downside is that it won't work for distros.  Or at least the distros
>> using RPM's debuginfo subpackage mechanism.
>
> Hmm. It *should* work for them too, because the debuginfo modules stay
> around in the object tree, and never get stripped there. None of this

Debuginfo is run on the installed tree ($RPM_BUILD_ROOT), not the
object tree.  It's how RPM works.  It kind of has to because it should
only create debuginfo files for files that are actually installed by
the RPM.

I know it's no different from how it _used_ to work with stripped
modules, but that's a problem that was solved a while ago.  The existing
build system works for both users and distros in that regard, and that
is my goal for modsigning too.

> Anyway, I seriously think that the kernel build should worry about
> *users*, not about the distro building their binaries. And I do think
> the current mess is unacceptable (following the insane
> "stripped->extra stripping->signed->potentially stripped *again* at
> install time" code was just insane). I may not have reacted as much as
> David to the actual build having slowed down, but having looked at the
> makefiles, there really is no excuse for that mess.

I'm not saying your patch is wrong.  I'm not even saying it isn't
better.  I'm simply saying it doesn't work as-is for distros.

What I'd like to do is come up with a solution that works for both
cases.  E.g. if we take your patch and apply it, but also create a
config option and a 'make modules_sign' target to sign them in the
installed tree and not at 'modules_install' time.  Or something along
those lines.

Distros want to do this too, and have been doing this for a while.  It
might be required for Secure Boot in some distro's eyes, but that is
really a side effect.  Distros _are_ users.  Or if you're not as starry
eyed as I am, they're at least a gateway for a large number of users.
I want those people to get the benefits of signed modules and I'd really
like to do it without the distros having to carry patches or do further
monkeying around after the buildsystem is done.  That's all.

josh

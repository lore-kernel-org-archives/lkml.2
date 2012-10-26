Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966385Ab2JZUMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 16:12:35 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64836 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965506Ab2JZUMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 16:12:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jL4qh5nXBJJQAr-42hZHk7bP0Gn468Sf3i8+W0eo1_LKA@mail.gmail.com>
References: <20121026185021.GA1960@www.outflux.net> <CA+55aFxSO9oGtNEBOAVXj+OQn0tye7rNBu8C5tsggsYdZarNrw@mail.gmail.com>
 <CAGXu5jL4qh5nXBJJQAr-42hZHk7bP0Gn468Sf3i8+W0eo1_LKA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Oct 2012 13:12:12 -0700
X-Google-Sender-Auth: 0nDdDc8hqo3sAModTe7oGizh_yQ
Message-ID: <CA+55aFzw_p-WJyBBGc5UFDU8yN698REH+Vc1fk=CDeq4JG8AFA@mail.gmail.com>
Subject: Re: [PATCH] VFS: add config options to enable link restrictions
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 12:46 PM, Kees Cook <keescook@chromium.org> wrote:
>
> I think there's value in being able to enable these protections at
> build-time so there's no need for a distro to have to ship extra
> files/lines, spend time setting it, etc.

The "value in not having to change the distro" is valid value. That
said, two lines to rc.local does that too.

But dammit, every single discussion I see, you use some *other*
argument for it, like "people don't have initrd" or whatever crazy
crap. That's what I was objecting to.

> Would a single config item be acceptable? What would be an agreeable
> way to enable this at build-time?

I dunno. Maybe a CONFIG_LOCKDOWN thing that sets a few of our other
default values as well. Or at least hide the config options from
normal users behind some extra security menu, so that people just
don't have to care this deeply. Because most people *don't* care.

I also don't see why it would be a build-time config option at all.
Why not just expose them as option using module_param_named(), and
then you can do it in the kernel command flags (and set it in your
grub.conf etc).

            Linus

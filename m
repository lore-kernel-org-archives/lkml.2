Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965506Ab2JZUXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 16:23:21 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58171 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966367Ab2JZUXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 16:23:17 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzw_p-WJyBBGc5UFDU8yN698REH+Vc1fk=CDeq4JG8AFA@mail.gmail.com>
References: <20121026185021.GA1960@www.outflux.net>
	<CA+55aFxSO9oGtNEBOAVXj+OQn0tye7rNBu8C5tsggsYdZarNrw@mail.gmail.com>
	<CAGXu5jL4qh5nXBJJQAr-42hZHk7bP0Gn468Sf3i8+W0eo1_LKA@mail.gmail.com>
	<CA+55aFzw_p-WJyBBGc5UFDU8yN698REH+Vc1fk=CDeq4JG8AFA@mail.gmail.com>
Date: Fri, 26 Oct 2012 13:23:16 -0700
X-Google-Sender-Auth: ke3cZ9EmE4iBtrZOj9cBQCU5RmA
Message-ID: <CAGXu5jKP5XxSkz48PsqbrpBZMU=wjsmq+HExZGKMOeHrB9PHrg@mail.gmail.com>
Subject: Re: [PATCH] VFS: add config options to enable link restrictions
From: Kees Cook <keescook@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 1:12 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Oct 26, 2012 at 12:46 PM, Kees Cook <keescook@chromium.org> wrote:
>> Would a single config item be acceptable? What would be an agreeable
>> way to enable this at build-time?
>
> I dunno. Maybe a CONFIG_LOCKDOWN thing that sets a few of our other
> default values as well. Or at least hide the config options from
> normal users behind some extra security menu, so that people just
> don't have to care this deeply. Because most people *don't* care.

My take is that while most people don't care, they also should have it
enabled. It really is only corner-cases that run into problems. All
the other situations are actual security vulnerabilities. So I'd
really like to make this as easy as possible to be "on by default" for
some extremely early definition of "by default".

> I also don't see why it would be a build-time config option at all.
> Why not just expose them as option using module_param_named(), and
> then you can do it in the kernel command flags (and set it in your
> grub.conf etc).

I'd like it to be the exception to turn it _off_, rather than the
exception to turn it on.

I'm happy to start collecting things under CONFIG_LOCKDOWN, but I
worry it'd just turn into the opposite of CONFIG_EXPERIMENTAL where if
there was some value in it that someone didn't want on, they'd leave
it off, etc. Most distros have infrastructure for maintaining their
desired configs, so I didn't think the granularity was very bad as I
sent it.

Every distro will ship with this enabled (except perhaps Damn
Vulnerable Linux), so why make it harder?

-Kees

-- 
Kees Cook
Chrome OS Security

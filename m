Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab1LGXgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 18:36:16 -0500
Received: from ozlabs.org ([203.10.76.45]:39034 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757497Ab1LGXgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 18:36:14 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, greg@kroah.com, joe@perches.com,
        bart.vanassche@gmail.com, linux-kernel@vger.kernel.org,
        Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 18/25] dynamic_debug: Introduce global fake module param $module.dyndbg
In-Reply-To: <CAJfuBxyJe4NbN7GDk4Si5A0mN2C6NFSPrbOsFt-pGs84DFZ1nA@mail.gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com> <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com> <1323198694-7186-1-git-send-email-jim.cromie@gmail.com> <1323198694-7186-19-git-send-email-jim.cromie@gmail.com> <8739cxjit8.fsf@rustcorp.com.au> <CAJfuBxyJe4NbN7GDk4Si5A0mN2C6NFSPrbOsFt-pGs84DFZ1nA@mail.gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 07 Dec 2011 21:29:53 +1030
Message-ID: <87iplsir4m.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Dec 2011 01:33:45 -0700, Jim Cromie <jim.cromie@gmail.com> wrote:
> On Tue, Dec 6, 2011 at 6:01 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > This worked out pretty neatly.  Thanks!
> 
> It did.  Almost like you planned it.

I do get lucky sometimes...

> >> -                   int (*unknown)(char *param, char *val));
> >> +                   int (*unknown)(char *param, char *val, const char *modname));
> >
> > Do you really want the modname here, or a struct module?  I wonder if we
> > should make this a standard opaque void *.  Of course, we'd have to
> > modify parse_args callers, but you're abusing "name" arg here a bit
> > anyway.
> >
> 
> I thought about the possible abuse, but then saw existing uses:
> 
> linux-2.6]$ grep parse_args init/main.c
> 	parse_args("early options", cmdline, NULL, 0, do_early_param);
> 	parse_args("Booting kernel", static_command_line, __start___param,
> 
> "Booting kernel" isnt quite a name either.
> 
> wrt using a struct module arg, Id prefer not.
> what I need is the name, so that the ddebug-queries being passed
> can leave out the module name and thus be shorter and less redundant

But from the module you can get the name.  It's just that having a
cb/void* pair is pretty standard practice.  Still, it's a line ball, and
I'm not unhappy enough to change it until we need it.

Thanks,
Rusty.


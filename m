Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab2LJVQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:16:36 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:37026 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab2LJVQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:16:33 -0500
MIME-Version: 1.0
In-Reply-To: <1355172274.17101.250.camel@gandalf.local.home>
References: <1355160900.17101.229.camel@gandalf.local.home>
	<1355165264.17101.233.camel@gandalf.local.home>
	<20121210190247.GA32119@kroah.com>
	<1355166920.17101.239.camel@gandalf.local.home>
	<CA+55aFzvTrrM_t_K3W5s32p610MS0PuTrUUhFKaB5tGPmsW73g@mail.gmail.com>
	<1355172274.17101.250.camel@gandalf.local.home>
Date: Mon, 10 Dec 2012 22:16:32 +0100
X-Google-Sender-Auth: yodhULCAsPy0bkyEem1Qy2pp8do
Message-ID: <CAMuHMdXcMY2uBNGvZS5rKGuzPsxUC=8YnJbJO8O0h-YJ+mu6TA@mail.gmail.com>
Subject: Re: Missing tags in my local stable git repo
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 9:44 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Otherwise I don't get the updates from stable when I do a remote fetch
> of my local copies. Would something like this work?
>
> [remote "origin"]
>         fetch = +refs/*:refs/*
>         mirror = true
>         url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> [remote "stable"]
>         url = git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
>         fetch = +refs/heads/*:refs/heads/*
>
> That is, if I have a single linus-stable.git repo that all my other
> repos use as an alternate and a remote, I could have this repo updated
> with:

That's actually what I have as my "master" repository.

My work repository references this as an alternate, and its .git subdirectory is
a symlink to space that is backed up (the alternates don't need backup as half
mirrors Linus' tree and the stable tree).

> git fetch
> git remote update stable

A single "git remote update" will fetch objects for both origin and the stable
remote.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab1BZWW6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 17:22:58 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:52838 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab1BZWW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 17:22:56 -0500
Date: Sat, 26 Feb 2011 23:22:55 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Waychison <mikew@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, klibc@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [klibc] [PATCH] build: Define __EXPORTED_HEADER__
Message-ID: <20110226222255.GB24028@merkur.ravnborg.org>
References: <1298506377-16796-1-git-send-email-mikew@google.com> <201102241519.44336.arnd@arndb.de> <AANLkTim3Zcgi8joipid=tGtLF70=pqa5ViRtbsiWru38@mail.gmail.com> <201102251140.46893.arnd@arndb.de> <AANLkTi=8S4=vEUNHR6zD8d1or6BS_o9k4nPg4he+Kik2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=8S4=vEUNHR6zD8d1or6BS_o9k4nPg4he+Kik2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > For instance, it should be easy to change the klibc build process from
> > requiring to link to the kernel source to automatically installing the
> > kernel headers into the klibc object directory.
> 
> I'm not against this idea, but is this something that works (and that
> people can actually do given the state of the klibc tree at this
> point)?
Yes - it worked last time I played around with it.
> 
> Maybe I don't understand what benefit is had by having a separate
> install_headers step that does not much more than copy headers from
> the kernel source tree into the klibc object tree as part of the
> vmlinux build.
The headers generated are the headers supposed to be used by user-space.
klibc and glibc is just two obvious candidates.


> I believe the original motivation of klibc was to maintain a minimal
> libc implementation that would mature to the point where we are
> capable of building userland binaries in the kernel source tree (so
> that some hairy legacy functionality currently implemented in
> kernel-space could be cleaned up and moved into early-userspace
> targets). I don't know why this effort has subsided, though I can
> imagine that lack of will and time were large factors.
> 
> What you are proposing seems to me like a step towards giving up on
> this noble goal :(
You seem to be confusing something here. Even if klibc is one day
included in the kernel source then we should continue to use
the headers generated using "make headers_install" for building klibc.

	Sam

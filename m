Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab0HEXkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 19:40:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756027Ab0HEXkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 19:40:41 -0400
MIME-Version: 1.0
In-Reply-To: <20100804125156.GA23464@sepie.suse.cz>
References: <20100804125156.GA23464@sepie.suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Aug 2010 16:33:03 -0700
Message-ID: <AANLkTi=hYsksUJUsrETjFouLDiKhwQHgD2oQ7XLyrOC-@mail.gmail.com>
Subject: Re: [GIT] kbuild: kconfig changes
To: Michal Marek <mmarek@suse.cz>
Cc: JBeulich@novell.com, aris@redhat.com, catalin.marinas@arm.com,
        jacmet@sunsite.dk, justinmattock@gmail.com, lizf@cn.fujitsu.com,
        sam@ravnborg.org, ulfalizer.lkml@gmail.com, zippel@linux-m68k.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On Wed, Aug 4, 2010 at 5:51 AM, Michal Marek <mmarek@suse.cz> wrote:
>
> this is the kconfig part of kbuild. We have four new *config targets:
> * oldnoconfig: set all new options to 'n'
> * listnewconfig: list all unset config options
> * alldefconfig: set all options to their defaults specified in Kconfig
>  files
> * savedefconfig: write a defconfig file with only the differences from
>  an alldefconfig (aka minimal defconfig)
>
> Kconfig also warns when a select statement selects a symbol with unmet
> dependencies (which typically results in a broken config). Li Zefan did
> quite some usability fixes to the visual config interfaces.

Hmm. This seems to make "make oldconfig" a _lot_ more verbose than it
used to be. In a very annoying way.

I'm used to this (v2.6.35 "make oldconfig" with no changes):

   [torvalds@i5 linux]$ make oldconfig
   scripts/kconfig/conf -o arch/x86/Kconfig
   #
   # configuration written to .config
   #
   [torvalds@i5 linux]$

but now it prints _everything_. The old "oldconfig" only printed
things out when there was something to be asked about.

This is a regression.

              Linus

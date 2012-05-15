Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab2EOHiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 03:38:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52295 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419Ab2EOHiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 03:38:50 -0400
Date: Tue, 15 May 2012 09:38:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Michal Marek <mmarek@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        =?ISO-8859-2?Q?Pawe=B3_Sikora?= <pluto@pld-linux.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: stale object files (was Re: Linux-3.4-rc7)
In-Reply-To: <4FB17876.5060604@suse.cz>
Message-ID: <alpine.LRH.2.00.1205150937130.11339@twin.jikos.cz>
References: <CA+55aFwB-3rsrVo1vur6drZMvhSWNHAJZfEYC=WXfpwwvLfxFQ@mail.gmail.com> <4FB17876.5060604@suse.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012, Michal Marek wrote:

> > Ok, added the appropriate kbuild people: Machal - skb_dev_set() no
> > longer exists, there are no users of it, so it looks like something
> > doesn't get rebuilt correctly.
> > 
> > Paweł, can you please also send us the config file you're using, then
> > we can recreate the exact setup you have.
> > 
> >                      Linus
> > 
> > On Sun, May 13, 2012 at 2:13 PM, Paweł Sikora <pluto@pld-linux.org> wrote:
> >>
> >> starting from current rc7 build tree...
> >>
> >> $ cp .config ../config
> >> $ make distclean
> >> $ git co v3.4-rc5
> >> $ cp ../config .config
> >> $ make oldconfig
> >> $ make -j8
> >> $ git co v3.4-rc7
> >> $ make oldconfig
> >> $ make -j8
> 
> This make results in
> 
> ERROR: "handle_edge_irq" [drivers/gpio/gpio-pch.ko] undefined!
> ERROR: "irq_to_desc" [drivers/gpio/gpio-pch.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> The second failure is simply GIGO.

Seems like my build fix for this from [1] hasn't been picked up by anyone. 
Is this going to be fixed in a different way (like disallowing gpio-pch to 
be built as module), or ... ?

Thanks.

[1] https://lkml.org/lkml/2012/5/13/21

-- 
Jiri Kosina
SUSE Labs


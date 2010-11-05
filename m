Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab0KEMCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 08:02:41 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:45325 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab0KEMCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 08:02:37 -0400
Date: Fri, 5 Nov 2010 13:02:05 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, Michal Marek <mmarek@suse.cz>
Cc: Arnaud Lacombe <lacombar@gmail.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, kyle@redhat.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: REGRESSION: Re: [GIT] kconfig rc fixes
Message-ID: <20101105130205.68a4d781@endymion.delvare>
In-Reply-To: <4CD300AC.3010708@redhat.com>
References: <20101009224041.GA901@sepie.suse.cz>
	<4CD1E232.30406@redhat.com>
	<AANLkTimyh-k8gYwuNi6nZFp3oviQ33+M3fDRzZ+sJN9i@mail.gmail.com>
	<4CD22627.2000607@redhat.com>
	<AANLkTi=Eb8k6gmeGqvC=Zbo2mj51oHcbCncZGt00u9Tx@mail.gmail.com>
	<4CD29493.5020101@redhat.com>
	<4CD300AC.3010708@redhat.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Nov 2010 14:51:24 -0400, Mauro Carvalho Chehab wrote:
> Em 04-11-2010 14:32, Arnaud Lacombe escreveu:
> > Hi,
> > 
> > On Thu, Nov 4, 2010 at 2:11 PM, Mauro Carvalho Chehab
> > <mchehab@redhat.com> wrote:
> >> [...]
> >> Yes, but this makes things worse: it will allow compiling drivers that Kernel
> >> will never use, as they won't work without an I2C adapter, and the I2C adapter
> >> is not compiled.
> >>
> >> Worse than that: if you go into all V4L bridge drivers, that implements the I2C
> >> adapters and disable them, the I2C ancillary adapters will still be compiled
> >> (as they won't return to 'n'), but they will never ever be used...
> >>
> >> So, no, this is not a solution.
> >>
> >> What we need is to prompt the menu only if the user wants to do some manual configuration.
> >> Otherwise, just use the selects done by the drivers that implement the I2C bus adapters,
> >> and have some code to use those selected I2C devices.
> >>
> > These is an easy solution: doing as
> > `Documentation/kbuild/kconfig-language.txt' say it should be done:
> > 
> > config MODULES
> >         bool "modules ?"
> >         default y
> > 
> > config AUTO
> >         bool "AUTO"
> > 
> > config IVTV
> >         tristate "IVTV"
> >         select WM42 if AUTO
> > 
> > menu "TV"
> >         depends on !AUTO
> > 
> > config WM42_USER
> >         tristate "WM42"
> >         select WM42
> > 
> > endmenu
> > 
> > config WM42
> >         tristate
> >         default n
> > 
> >  - Arnaud
> 
> This may work, but it means that every single I2C/frontend/tuner will require two
> entries for each driver. This means to create and manage around 100+ new symbols.
> The drivers/media Kconfig files are complex enough as-is, without adding those 100+
> new artificial symbols. We should work to make things simple and improve users experience,
> and not to create artificial complexity that will make Kconfig almost unreadable.
> 
> I still think that the easiest way to solve this is to add some logic that will
> hide the menu if a condition doesn't happen. Something like:
> 	menu FOO
> 		prompt if BAR
> 
> or
> 	menu FOO
> 		show if BAR

I totally second Mauro's concerns and proposal. My own proposal was
along the lines of:

	menu FOO
		hide if BAR

but obviously the idea is the same, so it doesn't matter which of the 3
proposals gets implemented. The basic idea is to have a weak form of
"depends" for menus, which hides the menu from the user but preserves
all the symbols defines under that menu.

Michal, is the above something you would be able to implement in
Kconfig?

Thanks,
-- 
Jean Delvare

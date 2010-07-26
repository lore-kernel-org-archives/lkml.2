Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab0GZH1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 03:27:13 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:45567 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab0GZH1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 03:27:12 -0400
Date: Mon, 26 Jul 2010 09:27:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tim Abbott <tabbott@ksplice.com>, Tim Bird <tim.bird@am.sony.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Michal Marek <mmarek@suse.cz>,
        Parisc List <linux-parisc@vger.kernel.org>
Subject: Re: Testing of function/data-sections on linux-2.6.35-rc4
Message-ID: <20100726072710.GB10061@merkur.ravnborg.org>
References: <201007181703.17022.vda.linux@googlemail.com> <20100723202448.GB27054@merkur.ravnborg.org> <201007260329.09913.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007260329.09913.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 03:29:09AM +0200, Denys Vlasenko wrote:
> On Friday 23 July 2010 22:24, Sam Ravnborg wrote:
> > > * fix for kernel linker stripts: linux-2.6.35-rc4-fs.fix-kernel-linker-scripts.patch
> > >   It makes _all_ linker scripts -ffunction/data-sections safe via:
> > >   -       *(.data)
> > >   +       *(.data .data.*)
> > >   
> > 
> > This patch touches both the regular kernel linker scripts and the
> > boot linker scripts.
> > I would strongly prefer a split so you touched the boot linker
> > scripts in a separate patch.
> 
> No problem.
> 
> > In addition the patch handles more sections than
> > documented: rodata, bss, text.
> 
> Yes, that was assumed.
> 
> > The patch introduce the following syntax for input sections:
> > 
> >     *(.bss .bss.*)
> >
> > Where the kernel linker script would have one input
> > section per line.
> > Can we stick to the "layout" used in the kernel linker scripts?
> 
> Sure.
> 
> 
> > The patch in addition in several places changes linker
> > scripts that already uses the two-lines layout to a single line approach.
> > These "fixes" should be omitted.
> 
> Reverted.
> 
> > Why do we need *(.bss .bss.*)?
> > Does -fdata-sections introduce special .bss sectiosn too?
> 
> Yes, it does.
> 
> Please take a look at attached updated patches.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Looks better now - thanks.

With proper changelogs both patches has my:

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam

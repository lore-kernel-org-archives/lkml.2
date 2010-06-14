Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab0FNXPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 19:15:06 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34185 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751201Ab0FNXPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 19:15:02 -0400
Subject: Re: [PATCH 1/5] vmlinux.lds.h: Include *(.text.*) in TEXT_TEXT
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Matt Fleming <matt@console-pimps.org>, linux-arch@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
       Denys Vlasenko <vda.linux@googlemail.com>, linux-parisc@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.1006141534490.1248@dr-wily.mit.edu>
References: <1276519112-11649-1-git-send-email-matt@console-pimps.org>
	 <alpine.DEB.1.10.1006141014360.1432@dr-wily.mit.edu>
	 <87y6ehxvby.fsf@linux-g6p1.site>
	 <alpine.DEB.1.10.1006141534490.1248@dr-wily.mit.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jun 2010 18:14:59 -0500
Message-ID: <1276557299.5374.847.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 18:21 -0400, Tim Abbott wrote:
> On Mon, 14 Jun 2010, Matt Fleming wrote:
> 
> > Do these special kernel sections include things like the parisc
> > .text.do_softirq, .text.sys_exit, etc? James raised a good objection to
> > the parisc patch of this series. I'm guessing most people saw it already
> > but I'll paste it here for reference,
> > 
> >     This would destroy all of the named parisc text ordering we do above the
> >     removed line because now you'd have swept up all the function sections
> >     before we get to them, won't it?
> > 
> >     The ordering is an execution speed up on 32 bit systems because our
> >     relative jump is so short.
> > 
> > Will you changes handle this OK?
> 
> I think I addressed this in my reply to James just now, but to be super 
> clear, this -ffunction-sections plan involves renaming .text.do_softirq to 
> .text..do_softirq (etc.) first.

OK, so that doesn't make a lot of sense to me; I suspect because you
don't understand what parisc is doing.  These aren't names of linux
special sections ... they're names of function sections.  For
efficiency, we take specific hot functions and place them together in
the linker script so the jumps between them are small enough to be coded
as relative on the 32 bit architecture.  It's really just a more
efficient way of laying out the binary.

James



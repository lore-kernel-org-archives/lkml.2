Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab1EXNe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:34:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:46433 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756433Ab1EXNez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:34:55 -0400
Date: Tue, 24 May 2011 06:33:53 -0700
From: Greg KH <gregkh@suse.de>
To: Florian Fainelli <ffainelli@freebox.fr>
Cc: lkml <linux-kernel@vger.kernel.org>, Maxime Bizon <mbizon@freebox.fr>,
        Tilman Schmidt <tilman@imap.cc>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] TTY: export NR_LDISC and N_* line discipline numbers to
 user-space
Message-ID: <20110524133353.GB19488@suse.de>
References: <201105241043.03347.ffainelli@freebox.fr>
 <20110524124044.GD31517@suse.de>
 <201105241517.23166.ffainelli@freebox.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105241517.23166.ffainelli@freebox.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 03:17:23PM +0200, Florian Fainelli wrote:
> Hello,
> 
> On Tuesday 24 May 2011 14:40:44 Greg KH wrote:
> > On Tue, May 24, 2011 at 10:43:03AM +0200, Florian Fainelli wrote:
> > > From: Florian Fainelli <ffainelli@freebox.fr>
> > > 
> > > Since commit (4564f9e5: consolidate line discipline number definitions)
> > > the patch moved all line discipline number from a per-architecture
> > > termios.h to a shared one: tty.h. However, prior to this consolidation
> > > work, the line discipline numbers were outside of an ifdef
> > > __KERNEL__/endif block so these numbers used to be exported to
> > > user-space.
> > > 
> > > Since such numbers are kernel ABI anyway, and tty.h is already included
> > > for user- space header processing, just move these relevant defines
> > > outside of the ifdef __KERNEL__/endif block in include/linux/tty.h.
> > 
> > Any reason you didn't copy _any_ of the people who signed off on that
> > patch, or the original author of that patch?
> 
> No particular reason but my mistake, fixed that.
> 
> > 
> > Anyway, this is been this way for four years, since the 2.6.21 kernel
> > release.  Since no one has noticed, or complained, since then, how much
> > a problem is this really?
> 
> This is a problem because you may have out of tree drivers using a line 
> discpline number, and you do not want your companion user-space application to 
> have to use a different line discpline number but the one the kernel should 
> provide.
> 
> > 
> > Meaning, why has it taken this long for anyone to notice?
> 
> - long standing user-space applications such as pppd got their N_PPP long ago, 
> and do not have to worry about N_PPP being renumbered so they can just define 
> it in pppd's sources it won't break
> 
> - I started implementing a line discipline driver only a couple of months ago 
> and then realized that such ABI should have been exported

Ok, then it really isn't that important of a change :)

I'll queue it up for the next major merge window after this one, thanks.

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab0KJS27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:28:59 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:33630 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab0KJS26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:28:58 -0500
Date: Wed, 10 Nov 2010 10:28:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Lionel Debroux <lionel_debroux@yahoo.fr>
Cc: Kees Cook <kees.cook@canonical.com>,
        David Daney <ddaney@caviumnetworks.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: [linux-next] automatic use of checkpatch.pl for security?
Message-Id: <20101110102819.9f020ba5.randy.dunlap@oracle.com>
In-Reply-To: <4CD9B3DD.8090603@yahoo.fr>
References: <20101109173357.GA5876@outflux.net>
	<4CD9887E.3040607@caviumnetworks.com>
	<20101109175921.GD5876@outflux.net>
	<4CD9B3DD.8090603@yahoo.fr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Nov 2010 21:49:33 +0100 Lionel Debroux wrote:

> Hi,
> 
> On 09.11.2010 18:59, Kees Cook wrote:
> > Hi David,
> > On Tue, Nov 09, 2010 at 09:44:30AM -0800, David Daney wrote:
> > > On 11/09/2010 09:33 AM, Kees Cook wrote:
> > > > In an effort to continue the constification work, it'd be nice to
> > > > not accidentally introduce regressions or add additional work.
> > > > Since checkpatch.pl already knows to warn about a lot of things
> > > > including const structures, it would be great to have all commits
> > > > going through linux-next (or something) have to pass at least a
> > > > subset of checkpatch.pl's checks.
> > > >
> > > > For example, Lionel Debroux pointed out to me that looking at the
> > > > last 1000 commits, there are a lot of warnings, including things
> > > > like:
> > > >
> > > > WARNING: struct dma_map_ops should normally be const
> > > > #499: FILE: arch/mips/mm/dma-default.c:301:
> > > > +static struct dma_map_ops mips_default_dma_map_ops = {
> > > >
> > > > Can we add some kind of automatic checking to actually give
> > > > checkpatch.pl some real teeth for at least some of its checks?
> > > >
> > >
> > > Ok, did you actually try to make it const as suggested?  If you
> > > had, you would have found that there are declarations throughout
> > > the code base that conflict with checkpatch.pl's suggestion.
> > >
> > > There are several things we could do:
> > >
> > > 1) Force people to clean up the entire kernel tree before making
> > > trivial changes that checkpatch.pl might complain about.
> > >
> > > 2) Change checkpatch.pl so that it doesn't complain about this.
> > >
> > > 3) Make reasonable changes and ignore the checkpatch.pl warning.
> > >
> > >
> > > In that specific case you cite, #3 was chosen.
> > 
> > Right, I don't want to suggest unreasonable changes; I want to try
> > and start a discussion about what might make a good addition to
> > help avoid obvious problems. (The chosen example was, perhaps, not
> > a good one.)
> My bad, sorry.
> backlight_ops and platform_suspend_ops, for which I sent patches to
> linux-janitors, may be better examples: several new static mutable
> instances of those structs have been added after
> 79404849e90a41ea2109bd0e2f7c7164b0c4ce73, which adds backlight_ops,
> platform_suspend_ops and others to the list of "should be const" structures.
> backlight_device_register() has been taking a "const struct
> backlight_ops *ops" argument since
> 9905a43b2d563e6f89e4c63c4278ada03f2ebb14, nearly 11 months ago.
> 
> > > If you gate admission to linux-next with some sort of automated
> > > check like this, I fear the wrath of the disgruntled masses may
> > > fall upon you.
> > But it seems like it might be nice to do at least something there?
> I think so, in order to help janitorial work.


linux-next of 2010.1109 has these const warnings from checkpatch:

drivers_tty_pty.c.chk:WARNING: struct file_operations should normally be const
drivers_tty_pty.c.chk-#706: FILE: drivers/tty/pty.c:703:
drivers_tty_pty.c.chk-+static struct file_operations ptmx_fops;
--
drivers_tty_tty_io.c.chk:WARNING: struct file_operations should normally be const
drivers_tty_tty_io.c.chk-#3187: FILE: drivers/tty/tty_io.c:3184:
drivers_tty_tty_io.c.chk-+void tty_default_fops(struct file_operations *fops)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207Ab2J2ODN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:03:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60713 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab2J2ODK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:03:10 -0400
Date: Mon, 29 Oct 2012 15:03:08 +0100
From: Michal Marek <mmarek@suse.cz>
To: Paul Thompson <set.mailinglist@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: IRQ subsystem menu
Message-ID: <20121029140308.GA19316@sepie.suse.cz>
References: <20121021074016.GA2604@squish.home.loc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121021074016.GA2604@squish.home.loc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding lkml and Thomas as IRQ subsystem maintainer to CC)

On Sun, Oct 21, 2012 at 03:40:16AM -0400, Paul Thompson wrote:
> 	Hi;
> 
> 	In menuconfig, General setup -> IRQ subsystem, there are two
> possible menu-items. One depends partly on IRQ_DOMAIN, and the other
> on MAY_HAVE_SPARSE_IRQ.
> 
> 	On the x86-64 arch, neither of these seems to be set, so the
> menu entry is blank if entered (displaying an odd ^@ if you try to
> navigate up or down. And sometimes some screen garbage on the sides.)
> 
> 	Previously (in the 3.2 kernel at least) this menu used to be
> populated by the "Support sparse IRQ numbering" menu-item, which
> at that time depended on HAVE_SPARSE_IRQ, and was forced to YES.
> 
> 	I do not know if the current behaviour is intended, but it
> is ugly and confusing to be confronted with a blank menu page.
> 
> 	Ideally, the "IRQ subsystem" menu would not even show up
> if it would contain no menu-items, but I do not know enough to
> formulate that constraint.
> 
> 	A simple alternative is a comment section to reasure babes in
> the wood of kernel configuration that something is not amiss. I include
> a sample patch.
> 
> Paul
> set.mailinglist@gmail.com

> --- linux-3.7-rc2/kernel/irq/Kconfig.orig	2012-10-20 15:11:32.000000000 -0400
> +++ linux-3.7-rc2/kernel/irq/Kconfig	2012-10-21 03:14:56.272952813 -0400
> @@ -4,6 +4,9 @@ config HAVE_GENERIC_HARDIRQS
>  
>  if HAVE_GENERIC_HARDIRQS
>  menu "IRQ subsystem"
> +
> +comment "Some configurations may have no available options here"
> +
>  #
>  # Interrupt subsystem related configuration options
>  #


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931Ab0GPSyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 14:54:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756269Ab0GPSyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 14:54:02 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1007161439240.10598@xanadu.home>
References: <20100713230352.6781.18644.stgit@angua>
	<1279296221.17878.66.camel@e102109-lin.cambridge.arm.com>
	<AANLkTinyFBTKYaryFANYheTuP-biJUws2x01NRNZPb4M@mail.gmail.com>
	<alpine.LFD.2.00.1007161406120.10598@xanadu.home>
	<20100716183028.GB26854@n2100.arm.linux.org.uk>
	<alpine.LFD.2.00.1007161439240.10598@xanadu.home>
Date: Fri, 16 Jul 2010 11:46:17 -0700
Message-ID: <AANLkTikqHnyFVJF0Pzwy2xtKeNSXYAPFdPkAkLiXK8Ls@mail.gmail.com>
Subject: Re: [RFC PATCH] Kconfig: Enable Kconfig fragments to be used for 
	defconfig
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 11:40 AM, Nicolas Pitre <nico@fluxnic.net> wrote:
>
> DOH.

Well, it's possible that the correct approach is a mixture.

Automatically do the trivial cases (recursive selects, dependencies
that are simple or of the form "x && y" etc), and warn about the cases
that aren't trivial (where "not trivial" may not necessarily be about
fundamentally ambiguous ones, but just "complex enough that I won't
even try").

Maybe a full "solver" is unnecessary, for example, but just a simple
"automatically enable the direct dependencies and scream when it's not
simple any more" would take care of 99% of the common cases, and then
warn when it needs some manual help.

So it's not a strict "one or the other" issue. The solution could be
"some of both".

                     Linus

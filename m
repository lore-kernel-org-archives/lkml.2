Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab0GPSa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 14:30:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52927 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758857Ab0GPSax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 14:30:53 -0400
Date: Fri, 16 Jul 2010 19:30:28 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Lindgren <tony@atomide.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [RFC PATCH] Kconfig: Enable Kconfig fragments to be used for
	defconfig
Message-ID: <20100716183028.GB26854@n2100.arm.linux.org.uk>
References: <20100713230352.6781.18644.stgit@angua> <1279296221.17878.66.camel@e102109-lin.cambridge.arm.com> <AANLkTinyFBTKYaryFANYheTuP-biJUws2x01NRNZPb4M@mail.gmail.com> <alpine.LFD.2.00.1007161406120.10598@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1007161406120.10598@xanadu.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 02:19:31PM -0400, Nicolas Pitre wrote:
> For example, if I want CONFIG_MTD_CMDLINE_PARTS=y, the system may be 
> smart enough to notice and automatically enable CONFIG_MTD and 
> CONFIG_MTD_PARTITIONS without having to carry those in the defconfig.

How do you sort out something like this:

config FOO
	bool "Foo"
	depends on (A && B) || C

Do you enable A and B, A, B and C or just C?

Bear in mind that A could be 'X86', 'M68K' or any other arch specific
symbol.

I prefer the warning method because it prompts you to investigate what's
changed and sort out the problem by ensuring that the appropriate symbols
are also selected.  The automatic selection of dependencies method carries
the risk that it'll do the wrong thing with the above scenario.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214Ab0GPUKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 16:10:16 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40901 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759158Ab0GPUKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 16:10:14 -0400
Subject: Re: [RFC PATCH] Kconfig: Enable Kconfig fragments to be used for
 defconfig
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicolas Pitre <nico@fluxnic.net>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kbuild@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <AANLkTikqHnyFVJF0Pzwy2xtKeNSXYAPFdPkAkLiXK8Ls@mail.gmail.com>
References: <20100713230352.6781.18644.stgit@angua>
	 <1279296221.17878.66.camel@e102109-lin.cambridge.arm.com>
	 <AANLkTinyFBTKYaryFANYheTuP-biJUws2x01NRNZPb4M@mail.gmail.com>
	 <alpine.LFD.2.00.1007161406120.10598@xanadu.home>
	 <20100716183028.GB26854@n2100.arm.linux.org.uk>
	 <alpine.LFD.2.00.1007161439240.10598@xanadu.home>
	 <AANLkTikqHnyFVJF0Pzwy2xtKeNSXYAPFdPkAkLiXK8Ls@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Fri, 16 Jul 2010 21:09:36 +0100
Message-ID: <1279310976.18579.8.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2010 20:09:37.0623 (UTC) FILETIME=[D1076670:01CB2522]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-16 at 19:46 +0100, Linus Torvalds wrote:
> On Fri, Jul 16, 2010 at 11:40 AM, Nicolas Pitre <nico@fluxnic.net> wrote:
> >
> > DOH.
> 
> Well, it's possible that the correct approach is a mixture.
> 
> Automatically do the trivial cases (recursive selects, dependencies
> that are simple or of the form "x && y" etc), and warn about the cases
> that aren't trivial (where "not trivial" may not necessarily be about
> fundamentally ambiguous ones, but just "complex enough that I won't
> even try").

There is still a risk with this approach when the Kconfig isn't entirely
correct. For example, on ARM we have (I pushed a patch already):

config CPU_32v6K
	depends on CPU_V6

config CPU_V7
	select CPU_32v6K

In this simple approach, we end up selecting CPU_V6 when we only need
CPU_V7. There other places like this in the kernel.

Of course, kbuild could still warn but if people rely on this feature to
select options automatically I suspect they would ignore the warnings.

-- 
Catalin


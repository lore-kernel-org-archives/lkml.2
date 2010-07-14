Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751049Ab0GNEEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 00:04:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758Ab0GNEEm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 00:04:42 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimC_vXCAOrfTSndZyk8lgkjTlILVSYVYeIg6cUt@mail.gmail.com>
References: <20100713114322.57c8b166.sfr@canb.auug.org.au>
	<AANLkTimC_vXCAOrfTSndZyk8lgkjTlILVSYVYeIg6cUt@mail.gmail.com>
Date: Tue, 13 Jul 2010 21:04:06 -0700
Message-ID: <AANLkTik-QCXFnjma3J28B9h27uajOcDhthTGz99zKgVi@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Enable building defconfigs from Kconfig files
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 7:26 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>
> I chose to use -D /dev/null (defconfig from an empty file) instead of
> -n (allnoconfig) so that default values in Kconfig would get
> respected.  For the benefit of everyone else, here's an excerpt from
> our IRC conversation this afternoon:
>
> 19:49 < gcl> sfr: [...] Your patch and my patch are
>             essentially doing exactly the same thing, except that I used '-d'
>             and you used '-n'.
> 19:50 < gcl> s/-d/-D/
> 19:55 < sfr> right
> 19:55 < sfr> Linus wanted us to use -n

Just a note: Linus doesn't really care.

IOW, I used -n not because of any fundamental belief that it is
correct, but just because ti happened to be how I happened to decide
to solve it. It's entirely possible that starting from the Kconfig
defaults (rather than "no") is the right way to go.

I think either approach is likely fine. The -D /dev/null approach
would presumably give smaller Kconfig.xyz files, assuming our defaults
are sane (an maybe that could be at least a partial validation of the
defaults we do have). While the -n approach is in some ways more
stable, in that the resulting Kconfig.xyz entires would presumably be
more stand-alone, and there wouldn't be any subtle interactions when
somebody changes a default value int he Kconfig file.

So I can see advantages to either model. And either model clearly
would want the improvements to "select" that are independent (ie warn
about unsatisfied 'depends on' constraints, and select recursively.
Maybe we already fixed the recursive select thing, I forget).

I also think we need to allow setting of actual values. I don't know
what the syntax would be. A "set" statement that overrides a default
in the Kconfig file, so that you can do

          set NODES_SHIFT 10

which would basically be equivalent to a "select" of a tristate
variable, but instead set the actual value? I dunno.

And quite frankly, maybe somebody comes up with a better model
entirely. I like the Kconfig.xyz model, in that it should be
human-readable/writable and shouldn't introduce any fundamentally new
concepts (except the fairly simple extensions to the Kconfig
language), but maybe there are better models.

Regardless, I don't have anything against either set of patches
(Grant's or Stephen's).

                       Linus

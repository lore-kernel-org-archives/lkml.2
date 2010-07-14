Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab0GNFsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 01:48:10 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37095 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab0GNFsH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 01:48:07 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTik-QCXFnjma3J28B9h27uajOcDhthTGz99zKgVi@mail.gmail.com>
References: <20100713114322.57c8b166.sfr@canb.auug.org.au> 
	<AANLkTimC_vXCAOrfTSndZyk8lgkjTlILVSYVYeIg6cUt@mail.gmail.com> 
	<AANLkTik-QCXFnjma3J28B9h27uajOcDhthTGz99zKgVi@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 13 Jul 2010 23:47:46 -0600
X-Google-Sender-Auth: xoa5LbjmwEjUWaJTV308PeFlMYU
Message-ID: <AANLkTimYDDviG2no6RVPZZj8rD2d2URMAPUCWuftiFiB@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Enable building defconfigs from Kconfig files
To: Linus Torvalds <torvalds@linux-foundation.org>
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

On Tue, Jul 13, 2010 at 10:04 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Jul 13, 2010 at 7:26 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>
>> I chose to use -D /dev/null (defconfig from an empty file) instead of
>> -n (allnoconfig) so that default values in Kconfig would get
>> respected.  For the benefit of everyone else, here's an excerpt from
>> our IRC conversation this afternoon:
>>
>> 19:49 < gcl> sfr: [...] Your patch and my patch are
>>             essentially doing exactly the same thing, except that I used '-d'
>>             and you used '-n'.
>> 19:50 < gcl> s/-d/-D/
>> 19:55 < sfr> right
>> 19:55 < sfr> Linus wanted us to use -n
>
> Just a note: Linus doesn't really care.
>
> IOW, I used -n not because of any fundamental belief that it is
> correct, but just because ti happened to be how I happened to decide
> to solve it. It's entirely possible that starting from the Kconfig
> defaults (rather than "no") is the right way to go.
>
> I think either approach is likely fine. The -D /dev/null approach
> would presumably give smaller Kconfig.xyz files, assuming our defaults
> are sane (an maybe that could be at least a partial validation of the
> defaults we do have). While the -n approach is in some ways more
> stable, in that the resulting Kconfig.xyz entires would presumably be
> more stand-alone, and there wouldn't be any subtle interactions when
> somebody changes a default value int he Kconfig file.

Okay, well I advocate for the -D /dev/null approach then.  I think
that validating our defaults, and looking for the subtle interactions
are exactly what we want to be doing when it comes to defconfigs.  The
fact that a defconfig does *not* want the default value is exactly
what the defconfigs should be capturing.

> So I can see advantages to either model. And either model clearly
> would want the improvements to "select" that are independent (ie warn
> about unsatisfied 'depends on' constraints, and select recursively.
> Maybe we already fixed the recursive select thing, I forget).
>
> I also think we need to allow setting of actual values. I don't know
> what the syntax would be. A "set" statement that overrides a default
> in the Kconfig file, so that you can do
>
>          set NODES_SHIFT 10
>
> which would basically be equivalent to a "select" of a tristate
> variable, but instead set the actual value? I dunno.

I'm partial to extending select statements myself because it fits
nicely into the existing grammer; but I can see value in having a set
statement too.  It would eliminate the temporary config options that
both my and Stephen's patch would add.

> And quite frankly, maybe somebody comes up with a better model
> entirely. I like the Kconfig.xyz model, in that it should be
> human-readable/writable and shouldn't introduce any fundamentally new
> concepts (except the fairly simple extensions to the Kconfig
> language), but maybe there are better models.

Perhaps, but I can't think of anything and this one is simple,
elegant, and easy to implement.

> Regardless, I don't have anything against either set of patches
> (Grant's or Stephen's).

I think we should run with this.  Since the patch has been merged to
warn on unmet Kconfig dependences, the only major hole left is being
able to do negative selects and to select specific values.  Stephen,
I'm happy to either keep working on this, or drop my patch in favor of
yours.  Whichever you prefer.  I'll try to find some time to look at
the Kconfig grammer.

The solver would also be useful and could further reduce the size of
the Kconfig fragments, but it isn't necessary so we don't need to wait
for it to get implemented to take this approach..

Cheers,
g.


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.

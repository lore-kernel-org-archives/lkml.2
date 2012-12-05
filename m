Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab2LEO3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 09:29:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42863 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab2LEO3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 09:29:38 -0500
Date: Wed, 5 Dec 2012 15:29:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andreas Mohr <andi@lisas.de>
Cc: linux-kernel@vger.kernel.org, Li Shaohua <shaohua.li@intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: Look Ma, da kernel is b0rken
Message-ID: <20121205142935.GA12119@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
	Li Shaohua <shaohua.li@intel.com>, linux-acpi@vger.kernel.org
References: <20121205070901.GA12123@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121205070901.GA12123@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 08:09:01AM +0100, Andreas Mohr wrote:
> Hi,
> 
> drivers/pnp/pnpacpi/core.c: In function 'ispnpidacpi':
> drivers/pnp/pnpacpi/core.c:65:2: warning: logical 'or' of collectively
> exhaustive tests is always true [-Wlogical-op]
> drivers/pnp/pnpacpi/core.c:66:2: warning: logical 'or' of collectively
> exhaustive tests is always true [-Wlogical-op]
> drivers/pnp/pnpacpi/core.c:67:2: warning: logical 'or' of collectively
> exhaustive tests is always true [-Wlogical-op]
> 
> 
> That's already the second less enticing -Wlogical-op issue
> which was discovered by accident during less than two days
> of my happy(?) activity of kernel suspend breakage bisection.
> 
> 
> Why oh why, as a rather *very* critical piece of software,
> can't the kernel use sufficiently aggressive warning levels *by default*??
> IMHO it's simply NOT ACCEPTABLE to have such sloppiness creep into
> the daily bandwagon of kernel development life
> (or should I say: being mandated to creep in?).
> 
> Result: whichever default warning level you set
> *will* end up as The New Normal,
> and all those warnings which then remain able to rear their ugly heads
> according to the chosen default level
> will be fixed by the community eventually,
> and *most others won't* (or at least not in time).
> 
> The amount of warnings spewn by make W=3 (or even W=2) is simply
> shocking IMNSHO.
> And there can always be an argument that most of such warnings
> are fixable. If not directly (e.g. because analysis of that warning type
> is partially unreliable), then by actively reworking code
> into something slightly different.

Can we all relax ourselves first?

Now, I admit that ispnpidacpi() is a rather clumsy way of testing
string sanity but whatever, it is there.

Then, we added W= exactly for inquisitive and adventurous people like
yourself to build kernel compilation units with, to *verify* the
*sanity* of the compiler's error messages (yes, gcc has been wrong a lot
in the past too) and fix them.

So why not write a patch that fixes this, *test* it correctly and then
submit it to the proper maintainer instead of ranting about it without
any constructive help and thus piss off everybody on the ML?

And yes, bugs happen and this is the reality of it - programmers are
people and they make mistakes too. So I think helping out fix bugs is a
much more constructive way of spending your time instead of pissing off
the only people who can actually help you with your problem.

HTH.

-- 
Regards/Gruss,
    Boris.

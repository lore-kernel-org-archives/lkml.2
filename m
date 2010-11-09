Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab0KIR70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:59:26 -0500
Received: from smtp.outflux.net ([198.145.64.163]:46085 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab0KIR7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:59:25 -0500
Date: Tue, 9 Nov 2010 09:59:21 -0800
From: Kees Cook <kees.cook@canonical.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: Re: [linux-next] automatic use of checkpatch.pl for security?
Message-ID: <20101109175921.GD5876@outflux.net>
References: <20101109173357.GA5876@outflux.net>
 <4CD9887E.3040607@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD9887E.3040607@caviumnetworks.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, Nov 09, 2010 at 09:44:30AM -0800, David Daney wrote:
> On 11/09/2010 09:33 AM, Kees Cook wrote:
> >In an effort to continue the constification work, it'd be nice to
> >not accidentally introduce regressions or add additional work. Since
> >checkpatch.pl already knows to warn about a lot of things including const
> >structures, it would be great to have all commits going through linux-next
> >(or something) have to pass at least a subset of checkpatch.pl's checks.
> >
> >For example, Lionel Debroux pointed out to me that looking at the last
> >1000 commits, there are a lot of warnings, including things like:
> >
> >WARNING: struct dma_map_ops should normally be const
> >#499: FILE: arch/mips/mm/dma-default.c:301:
> >+static struct dma_map_ops mips_default_dma_map_ops = {
> >
> >Can we add some kind of automatic checking to actually give checkpatch.pl
> >some real teeth for at least some of its checks?
> >
> 
> Ok, did you actually try to make it const as suggested?  If you had,
> you would have found that there are declarations throughout the code
> base that conflict with checkpatch.pl's suggestion.
> 
> There are several things we could do:
> 
> 1) Force people to clean up the entire kernel tree before making
> trivial changes that checkpatch.pl might complain about.
> 
> 2) Change checkpatch.pl so that it doesn't complain about this.
> 
> 3) Make reasonable changes and ignore the checkpatch.pl warning.
> 
> 
> In that specific case you cite, #3 was chosen.

Right, I don't want to suggest unreasonable changes; I want to try and
start a discussion about what might make a good addition to help avoid
obvious problems. (The chosen example was, perhaps, not a good one.)

> If you gate admission to linux-next with some sort of automated
> check like this, I fear the wrath of the disgruntled masses may fall
> upon you.

But it seems like it might be nice to do at least something there?

-Kees

-- 
Kees Cook
Ubuntu Security Team

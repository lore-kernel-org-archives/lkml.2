Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab0KIRoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:44:32 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5113 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab0KIRob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:44:31 -0500
Message-ID: <4CD9887E.3040607@caviumnetworks.com>
Date: Tue, 09 Nov 2010 09:44:30 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: Re: [linux-next] automatic use of checkpatch.pl for security?
References: <20101109173357.GA5876@outflux.net>
In-Reply-To: <20101109173357.GA5876@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Nov 2010 17:45:11.0889 (UTC) FILETIME=[DBC45410:01CB8035]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2010 09:33 AM, Kees Cook wrote:
> Hi,
>
> In an effort to continue the constification work, it'd be nice to
> not accidentally introduce regressions or add additional work. Since
> checkpatch.pl already knows to warn about a lot of things including const
> structures, it would be great to have all commits going through linux-next
> (or something) have to pass at least a subset of checkpatch.pl's checks.
>
> For example, Lionel Debroux pointed out to me that looking at the last
> 1000 commits, there are a lot of warnings, including things like:
>
> WARNING: struct dma_map_ops should normally be const
> #499: FILE: arch/mips/mm/dma-default.c:301:
> +static struct dma_map_ops mips_default_dma_map_ops = {
>
> Can we add some kind of automatic checking to actually give checkpatch.pl
> some real teeth for at least some of its checks?
>

Ok, did you actually try to make it const as suggested?  If you had, you 
would have found that there are declarations throughout the code base 
that conflict with checkpatch.pl's suggestion.

There are several things we could do:

1) Force people to clean up the entire kernel tree before making trivial 
changes that checkpatch.pl might complain about.

2) Change checkpatch.pl so that it doesn't complain about this.

3) Make reasonable changes and ignore the checkpatch.pl warning.


In that specific case you cite, #3 was chosen.

If you gate admission to linux-next with some sort of automated check 
like this, I fear the wrath of the disgruntled masses may fall upon you.

David Daney

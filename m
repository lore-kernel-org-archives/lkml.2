Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab1EPQOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:14:22 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:51413 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688Ab1EPQOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:14:21 -0400
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, davej@redhat.com, kees.cook@canonical.com,
        davem@davemloft.net, eranian@google.com, torvalds@linux-foundation.org,
        adobriyan@gmail.com, penberg@kernel.org
In-Reply-To: <20110516153527.GC21107@elte.hu>
References: <1305292059.1949.0.camel@dan> <1305293345.1949.22.camel@dan>
	 <20110516153527.GC21107@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 12:14:12 -0400
Message-ID: <1305562452.1818.10.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 17:35 +0200, Ingo Molnar wrote:

> Agreed, it would be a very useful feature.
> 
> I'd suggest to implement it along the lines of:
> 
>  - First check whether grsecurity or PAX has this implemented already via the
>    relocation facility - they are pretty good at being paranoid so i'd be 
>    surprised if they didnt think of this already! :-)
> 
>  - If not then have a look at CONFIG_RELOCATABLE and to relocate the kernel 
>    binary intentionally via a hardcoded parameter. Just see whether you can do 
>    it and whether it works as you expect it. Check /proc/kallsyms changing 
>    after your patch. Enjoy the kernel still working ;-)
> 
>  - Then promote it to a boot parameter - this way you'll be able to tell 
>    whether there's any hidden build-time assumptions about relocation position. 
>    (there really shouldnt be any given that kexec works just fine - but i'd 
>     suggest this step just in case.)
> 
>  - Then promote that hack to be a randomized parameter. Marvel at a different,
>    randomized /proc/kallsyms output at every bootup and enjoy the still working 
>    kernel!
> 
>  - Then look at all RIP outputs (thanks to your prior efforts they are now 
>    mostly concentrated in the vprints code!) and reverse apply the random 
>    offset before it's exported into user-space. wchan, etc. Marvel at the 
>    constant /proc/kallsyms output, fully knowing that the *real* addresses
>    are randomized.
> 
>  - Please do not forget to transfer perf RIPs and callchains and marvel at the
>    well working 'perf top' output.
> 
> At that point the feature will be highly useful already IMO. Remaining work 
> will be to think through and close down all remaining avenues of RIP leakage. 
> 
> At this point kptr_restrict will be a lot less relevant - the symbols will 
> expose offsets (so it's not totally unhelpful to attackers) but not the real 
> absolute addresses.
> 
> Unless i'm missing some particularly difficult roadblock, which is possible.
> 
> If you try this then please keep us posted at every step above, even if your 
> patches are not fully working and useful yet. Maybe some other 
> details/ideas/suggestions will arise at that point.
> 

Thanks for the detailed response.  I will attempt to go down this road,
and will keep people posted with my progress.

-Dan

> Thanks,
> 
> 	Ingo



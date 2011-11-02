Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918Ab1KBPTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:19:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:54085 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab1KBPTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:19:04 -0400
Date: Wed, 2 Nov 2011 11:18:44 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <rusty@rustcorp.com.au>, <mingo@elte.hu>, <akpm@linux-foundation.org>,
        <sfr@canb.auug.org.au>, <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] introduce export.h; reduce module.h usage
Message-ID: <20111102151843.GA25190@windriver.com>
References: <20111101004542.GA18671@windriver.com>
 <CA+55aFz7dRWdQy_39+sCMeuqkavg8gYYyH_4u-n66OFVYzAWTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFz7dRWdQy_39+sCMeuqkavg8gYYyH_4u-n66OFVYzAWTg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [GIT PULL] introduce export.h; reduce module.h usage] On 01/11/2011 (Tue 16:59) Linus Torvalds wrote:

> On Mon, Oct 31, 2011 at 5:45 PM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
> >
> > Please pull the below to get the module.h split content.  It has been
> > tested on v3.1-rc6, soaked in linux-next, and re-tested again lots more
> > today after rebasing it to allow most of the linux-next finds to be
> > blended in, where they could not be on the original v3.1-rc6 baseline.
> 
> Does it bisect cleanly?

I'd mentioned earlier[1] that I was keeping clean bisection as a goal,
but that was a while ago, and I probably should have reiterated that
in this pull request.

> 
> Quite frankly, for something fairly trivial like this where the upside
> is mainly "slightly faster compile" (and hey, perhaps cleaner source
> tree), the downsides needs to be minimized.  And just looking at the
> shortlog makes me go: this will be a bisection disaster - people will
> look for bugs, bisect will go into this series, and things won't
> compile.
> 
> But maybe it's ordered so that the actual module.h split comes last,
> exactly so that it would be safe and bisectable? I just don't know,
> and I'd like to know before I pull..

Yes, the order was explicitly set out to maintain that.  Which is why
the dates of the changes are not necessarily in strict increasing
chronological order.  The set is ordered like this:

   1) move content from module.h to export.h/moduleparam.h

   2) many one line changes to fix implicit header dependencies

   3) fix linux/include/* so that module.h isn't implicitly everywhere

As Stephen said, the two commits that do #1 are inert.  The changes in
#2 just ensure files that use header X call out header X, and finally
the changes in #3 are then safe to make because of the work done in #2.

Just to double check that I'd not somehow drifted away from maintaining
the bisectability, I've just ran 50 x86_64 defconfig builds; for
checkouts of the 1st 25 commits and the last 25 commits (the latter
covers all of the changes in #3 above).

If you'd like something else; specific tests or to have this rebased
onto whatever is in master closer to the end of the week then just ask.

Thanks,
Paul.

[1] https://lkml.org/lkml/2011/7/28/140

> 
>                     Linus

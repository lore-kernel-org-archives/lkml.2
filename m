Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab1CHQth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 11:49:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889Ab1CHQte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 11:49:34 -0500
Date: Tue, 8 Mar 2011 11:48:49 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Mustafa Mesanovic <mume@linux.vnet.ibm.com>
Cc: Neil Brown <neilb@suse.de>, akpm@linux-foundation.org, dm-devel@redhat.com,
        cotte@de.ibm.com, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org, ehrhardt@linux.vnet.ibm.com,
        "Alasdair G. Kergon" <agk@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v3] dm stripe: implement merge method
Message-ID: <20110308164849.GA5692@redhat.com>
References: <201012271219.56476.mume@linux.vnet.ibm.com>
 <20101227225459.5a5150ab@notabene.brown>
 <201012271323.13406.mume@linux.vnet.ibm.com>
 <4D74AEF9.7050108@linux.vnet.ibm.com>
 <20110308022158.GA663@redhat.com>
 <4D76051E.5060303@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D76051E.5060303@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08 2011 at  5:29am -0500,
Mustafa Mesanovic <mume@linux.vnet.ibm.com> wrote:

> On 03/08/2011 03:21 AM, Mike Snitzer wrote:
>
> >Here is a revised version of your patch that uses the relatively new
> >stripe_map_sector(), removes an unnecessary cast, and a few other
> >cleanups.
> >
> >This v3 should work as well as your v2 but should be suitable for
> >upstream inclusion -- authorship of the change is still attributed to
> >you as I only updated the code slightly.  I'd appreciate it if you could
> >verify your config still performs as expected.
>
> Mike,
> 
> your changes are working well and performing even a bit better.

Good to know.

> Are there any further comments from others, or can consider putting it
> upstream.

I chatted with Alasdair and one concern he had was: does the existence
of stripe_merge() ever hurt due to the fact that stripe_map_sector() is
performed twice (once for .merge and again for .map)?  May be that a
really small chuck_size proves to be more problematic but using a small
chunk_size generally isn't productive to begin with.

In any case, it clearly helps your workload.

Could you explain your config in more detail?
- what is your chunk_size?
- how many stripes (how many mpath devices)?
- what is the performance, of your test workload, of a single underlying
  mpath device?

And, in particular, what is your test workload?
- What is the nature of your IO (are you using a particular tool)?
- Are you using AIO?
- How many threads?
- Are you driving deep queue depths? Etc.

I have various configs that I'll be testing to help verify the benefit.
The only other change Alasdair request is that the target version should
be bumped to 1.4 (rather than 1.3.2).

Given that I can put some time to this now: we should be able to sort
all this out for upstream inclusion in 2.6.39.

Thanks,
Mike

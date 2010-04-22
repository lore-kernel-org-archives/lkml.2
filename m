Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab0DVHGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 03:06:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50883 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab0DVHGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 03:06:22 -0400
Date: Thu, 22 Apr 2010 09:06:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Neil Brown <neilb@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: tip: origin tree build failure (x86, 32-bit, allyesconfig)
Message-ID: <20100422070610.GA18884@elte.hu>
References: <19350.53522.385933.467438@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19350.53522.385933.467438@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Neil Brown <neilb@suse.de> wrote:

> are available in the git repository at:
> 
>   git://neil.brown.name/md/ for-linus

( Note, i'm re-using this old MD pull request thread to report a bug in a pull 
  request you sent to Linus in the past two days. I havent found the pull 
  request nor the patch on lkml. )

All 32-bit x86 builds (x86, allyesconfig) that enable RAID are failing with 
this build failure:

 drivers/built-in.o: In function `raid5_compute_sector':
 raid5.c:(.text+0x2e42ac): undefined reference to `__umoddi3'
 raid5.c:(.text+0x2e42d8): undefined reference to `__umoddi3'
 raid5.c:(.text+0x2e42ff): undefined reference to `__umoddi3'
 raid5.c:(.text+0x2e4327): undefined reference to `__umoddi3'
 raid5.c:(.text+0x2e4385): undefined reference to `__umoddi3'
 drivers/built-in.o:raid5.c:(.text+0x2e43bc): more undefined references to `__umoddi3' follow

Caused by this commit:

  35f2a59: md/raid5: allow for more than 2^31 chunks.

I've reverted the commit from -tip for now.

Thanks,

	Ingo

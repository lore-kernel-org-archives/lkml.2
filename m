Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab1E0GI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 02:08:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47981 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab1E0GI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 02:08:57 -0400
Date: Fri, 27 May 2011 08:08:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        benh@kernel.crashing.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, hughd@google.com,
        akpm@linux-foundation.org, dave@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH] mm: don't access vm_flags as 'int'
Message-ID: <20110527060826.GA9260@elte.hu>
References: <4DDE2873.7060409@jp.fujitsu.com>
 <BANLkTi=znC18PAbpDfeVO+=Pat_EeXddjw@mail.gmail.com>
 <BANLkTikgXhmgzQYfSWKDoxVyNuCzSM7Qxw@mail.gmail.com>
 <BANLkTin3vHzUu-p654jvkG4R1Td261b3Aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin3vHzUu-p654jvkG4R1Td261b3Aw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, May 26, 2011 at 11:50 AM, richard -rw- weinberger
> <richard.weinberger@gmail.com> wrote:
> >
> > This breaks kernel builds with CONFIG_HUGETLBFS=n. :-(
> 
> Grr. I did the "allyesconfig" build to find any problems, but that
> obviously also sets HUGETLBFS.
> 
> But "allnoconfig" does find this.

Yeah, my experience is that [all[yes|no|mod]|def]config covers about 
95% of the build bugs and the remaining 5% are rarely showstopper 
problems (they generally don't show up in configs that people use).

Given how fast allnoconfig and defconfig builds i've got allnoconfig 
and defconfig scripted to always execute together with allyesconfig.

So if you go the trouble to build allyesconfig manually, it costs 
almost no time to tack on the allnoconfig and defconfig as well (and 
stick this all into a script), while it increases the efficiency of 
the build test remarkably.

Thanks,

	Ingo

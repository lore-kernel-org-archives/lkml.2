Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029Ab2JYBPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 21:15:17 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:65411 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807Ab2JYBPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 21:15:14 -0400
Date: Wed, 24 Oct 2012 18:15:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
cc: Sasha Levin <levinsasha928@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        bhutchings@solarflare.com,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch for-3.7] mm, mempolicy: fix printing stack contents in
 numa_maps
In-Reply-To: <CAHGf_=p7kFau=pMYLkGffA=ak1Jhhm7NzaPg6mSWQYQK3erQuA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1210241814100.28233@chino.kir.corp.google.com>
References: <20121008150949.GA15130@redhat.com> <CAHGf_=pr1AYeWZhaC2MKN-XjiWB7=hs92V0sH-zVw3i00X-e=A@mail.gmail.com> <alpine.DEB.2.00.1210152055150.5400@chino.kir.corp.google.com> <CAHGf_=rLjQbtWQLDcbsaq5=zcZgjdveaOVdGtBgBwZFt78py4Q@mail.gmail.com>
 <alpine.DEB.2.00.1210152306320.9480@chino.kir.corp.google.com> <CAHGf_=pemT6rcbu=dBVSJE7GuGWwVFP+Wn-mwkcsZ_gBGfaOsg@mail.gmail.com> <alpine.DEB.2.00.1210161657220.14014@chino.kir.corp.google.com> <alpine.DEB.2.00.1210161714110.17278@chino.kir.corp.google.com>
 <20121017040515.GA13505@redhat.com> <alpine.DEB.2.00.1210162222100.26279@chino.kir.corp.google.com> <CA+1xoqe74R6DX8Yx2dsp1MkaWkC1u6yAEd8eWEdiwi88pYdPaw@mail.gmail.com> <alpine.DEB.2.00.1210241633290.22819@chino.kir.corp.google.com>
 <CA+1xoqd6MEFP-eWdnWOrcz2EmE6tpd7UhgJyS8HjQ8qrGaMMMw@mail.gmail.com> <alpine.DEB.2.00.1210241659260.22819@chino.kir.corp.google.com> <CAHGf_=p7kFau=pMYLkGffA=ak1Jhhm7NzaPg6mSWQYQK3erQuA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012, KOSAKI Motohiro wrote:

> Hrm. I haven't noticed there is mpol_misplaced() in linux-next. Peter,
> I guess you commited it, right? If so, may I review your mempolicy
> changes? Now mempolicy has a lot of horrible buggy code and I hope to
> maintain carefully. Which tree should i see?
> 

Check out sched/numa from 
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git

$ git diff v3.7-rc2.. mm/mempolicy.c | diffstat
 mempolicy.c |  444 +++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 277 insertions(+), 167 deletions(-)

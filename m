Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab0FCEsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 00:48:15 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35399 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab0FCEsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 00:48:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] oom: remove PF_EXITING check completely
Cc: kosaki.motohiro@jp.fujitsu.com, Oleg Nesterov <oleg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <alpine.DEB.2.00.1006021359430.32666@chino.kir.corp.google.com>
References: <20100602155455.GB9622@redhat.com> <alpine.DEB.2.00.1006021359430.32666@chino.kir.corp.google.com>
Message-Id: <20100603120814.7242.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Jun 2010 13:48:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2 Jun 2010, Oleg Nesterov wrote:
> 
> > > Today, I've thought to make some bandaid patches for this issue. but
> > > yes, I've reached the same conclusion.
> > >
> > > If we think multithread and core dump situation, all fixes are just
> > > bandaid. We can't remove deadlock chance completely.
> > >
> > > The deadlock is certenaly worst result, then, minor PF_EXITING optimization
> > > doesn't have so much worth.
> > 
> > Agreed! I was always wondering if it really helps in practice.
> > 
> 
> Nack, this certainly does help in practice, it prevents needlessly killing 
> additional tasks when one is exiting and may free memory.  It's much 
> better to defer killing something temporarily if an eligible task (i.e. 
> one that has a high probability of memory allocations on current's nodes 
> or contributing to its memcg) is exiting.
> 
> We depend on this check specifically for our use of cpusets, so please 
> don't remove it.

Your claim violate our development process. Oleg pointed this check
doesn't only work well, but also can makes deadlock. So, We certinally
need anything fix. then, I'll remove this check completely at 2.6.35
timeframe.

But this doesn't mean we refuse you make better patch at all. I expect
we can merge very soon if you make such patch.



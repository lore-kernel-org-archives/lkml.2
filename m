Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695Ab1AEIkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 03:40:33 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59349 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab1AEIkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 03:40:31 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Avi Kivity <avi@redhat.com>
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <4D242D60.9060301@redhat.com>
References: <20110105110837.B62A.A69D9226@jp.fujitsu.com> <4D242D60.9060301@redhat.com>
Message-Id: <20110105173823.B658.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  5 Jan 2011 17:40:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 01/05/2011 04:39 AM, KOSAKI Motohiro wrote:
> > >  On 01/04/2011 08:14 AM, KOSAKI Motohiro wrote:
> > >  >  Also, If pthread_cond_signal() call sys_yield_to imlicitly, we can
> > >  >  avoid almost Nehalem (and other P2P cache arch) lock unfairness
> > >  >  problem. (probaby creating pthread_condattr_setautoyield_np or similar
> > >  >  knob is good one)
> > >
> > >  Often, the thread calling pthread_cond_signal() wants to continue
> > >  executing, not yield.
> >
> > Then, it doesn't work.
> >
> > After calling pthread_cond_signal(), T1 which cond_signal caller and T2
> > which waked start to GIL grab race. But usually T1 is always win because
> > lock variable is in T1's cpu cache. Why kernel and userland have so much
> > different result? One of a reason is glibc doesn't have any ticket lock scheme.
> >
> > If you are interesting GIL mess and issue, please feel free to ask more.
> 
> I suggest looking into an explicit round-robin scheme, where each thread 
> adds itself to a queue and an unlock wakes up the first waiter.

I'm sure you haven't try your scheme. but I did. It's slow.




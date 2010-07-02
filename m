Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab0GBGSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 02:18:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46367 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab0GBGSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 02:18:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: A possible sys_wait* bug
Cc: kosaki.motohiro@jp.fujitsu.com, Salman Qazi <sqazi@google.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20100701140836.GA8379@redhat.com>
References: <20100701093621.DA24.A69D9226@jp.fujitsu.com> <20100701140836.GA8379@redhat.com>
Message-Id: <20100702150844.DA44.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  2 Jul 2010 15:18:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 07/01, KOSAKI Motohiro wrote:
> >
> > > Basically, it is possibly for readers to continuously hold
> > > tasklist_lock
> 
> Yes, this is the known problem.
> 
> Perhaps do_wait() is not the worst example. sys_kill(-1),
> sys_ioprio_set() scan the global list.

Ah, I see.
Yup, Roland also pointed out this is NOT biggest risk, there are much
other way. My thinking coverage was too narrow. sorry.


> > > I think the most direct approach to the problem is to have the
> > > readers-writer locks be writer biased (i.e. as soon as a writer
> > > contends, we do not permit any new readers).
> 
> I thought about this too, but this is deadlockable. At least,
> read_lock(tasklist) should nest, and it should work in irq context.
> 
> We need the more fine-grained locking, but it is not clear to me what
> should be done in the long term. Afaics, this is very nontrivial.

Thank you for kindful explanation.



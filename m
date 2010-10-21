Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab0JUJIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 05:08:25 -0400
Received: from fep16.mx.upcmail.net ([62.179.121.36]:37699 "EHLO
	fep16.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab0JUJIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 05:08:24 -0400
X-SourceIP: 80.56.199.130
Subject: Re: [RFC tg_shares_up improvements - v1 01/12] sched: rewrite
 tg_shares_up
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: bharata@linux.vnet.ibm.com
Cc: pjt@google.com, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>
In-Reply-To: <20101021080844.GB3581@in.ibm.com>
References: <20101016044349.830426011@google.com>
	 <20101016045118.529238208@google.com>  <20101021080844.GB3581@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 11:08:16 +0200
Message-ID: <1287652096.3488.63.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=zlRBWuFCZaNL9+WHNm1pWLowY5Lx061w2zJBJiDkNAU= c=1 sm=0 a=yl-ibK2XthoA:10 a=IkcTkHD0fZMA:10 a=pCFOoG7QmOvPXuKgLGQA:9 a=CdVy9cgCwRWjwDRcoTdcvFxRXuwA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 13:38 +0530, Bharata B Rao wrote:
> > +     se->on_rq = 0;
> 
> Since setting and un-setting of se->on_rq is completely handled within
> sched_fair.c, we can remove the redundant setting and un-setting of
> se->on_rq from sched.c:[en]dequeue_task. Even w/o this patch, they were
> redundant I suppose. 

sadly not, sched_rt.c also uses them. It really shouldn't live in
sched_entity but in a common set.

I've long wanted to rework all that into something like:

 struct sched_entity {
	/* common fields */
	union {
		struct sched_fair_entity fair;
		struct sched_rt_entity   rt;
	};
 };

But that never quite happened.


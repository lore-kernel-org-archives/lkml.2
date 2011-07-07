Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab1GGRJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 13:09:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:41745 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab1GGRJW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 13:09:22 -0400
Subject: Re: [patch 00/17] CFS Bandwidth Control v7.1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@openvz.org>, Hu Tao <hutao@cn.fujitsu.com>
In-Reply-To: <m2iprexcc8.fsf@firstfloor.org>
References: <20110707053036.173186930@google.com>
	 <20110707112302.GB8227@elte.hu> <1310049528.3282.583.camel@twins>
	 <m2iprexcc8.fsf@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 07 Jul 2011 19:08:57 +0200
Message-ID: <1310058537.3282.585.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-07 at 09:52 -0700, Andi Kleen wrote:
> Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
> >
> > +static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
> > +               unsigned long delta_exec)
> > +{
> > +       if (!cfs_rq->runtime_enabled)
> > +               return;
> > +
> > +       cfs_rq->runtime_remaining -= delta_exec;
> > +       if (cfs_rq->runtime_remaining > 0)
> > +               return;
> > +
> > +       assign_cfs_rq_runtime(cfs_rq);
> > +}
> >
> > generate a call, only to then take the first branch out, marking that
> 
> You would need a *LOT* of calls to make up for 9%.
> 
> Maybe it's something else? Some profiling first before optimization
> is probably a good idea.

This is the 1.5% case where the feature is compiled in but not used.

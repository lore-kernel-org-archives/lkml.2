Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab1COQlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 12:41:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:54492 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037Ab1COQlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 12:41:44 -0400
Subject: Re: [PATCH] perf: Fix tear-down of inherited group events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <alpine.DEB.2.00.1103151206140.9668@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1103111745070.15818@cl320.eecs.utk.edu>
	 <alpine.DEB.2.00.1103141824190.13179@cl320.eecs.utk.edu>
	 <20110314223224.GD9388@ghostprotocols.net>
	 <alpine.DEB.2.00.1103142026350.16076@cl320.eecs.utk.edu>
	 <alpine.DEB.2.00.1103142224150.20209@cl320.eecs.utk.edu>
	 <1300196470.2203.61.camel@twins>
	 <alpine.DEB.2.00.1103151206140.9668@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 15 Mar 2011 17:41:23 +0100
Message-ID: <1300207283.2203.213.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 12:09 -0400, Vince Weaver wrote:
> On Tue, 15 Mar 2011, Peter Zijlstra wrote:
> 
> > Subject: perf: Fix tear-down of inherited group events
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Tue Mar 15 14:37:10 CET 2011
> > 
> > When destroying inherited events, we need to destroy groups too,
> > otherwise the event iteration in perf_event_exit_task_context() will
> > miss group siblings and we leak events with all the consequences.
> 
> Thanks for the fix!  I can verify that when applied against current 
> linus-git kernel that my original test case no longer leaks memory.
> 
> I've also run the full PAPI regression tests, plus the BLAS/PAPI benchmark 
> code that originally showed the problem and everything checks out fine.
> 
> It's a shame this fix didn't make it in before 2.6.38.

It sure is, sadly there's still only 24h in a day, less if you consider
this .jp earthquake speeding up our planets spin :-)

> Tested-by: Vince Weaver <vweaver1@eecs.utk.edu>

Thanks Vince!

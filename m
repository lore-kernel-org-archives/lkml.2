Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126Ab1COQJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 12:09:44 -0400
Received: from aspirin.dii.utk.edu ([160.36.0.81]:43599 "EHLO
	aspirin.dii.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233Ab1COQJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 12:09:43 -0400
Date: Tue, 15 Mar 2011 12:09:18 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Arnaldo Carvalho de Melo <acme@redhat.com>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf: Fix tear-down of inherited group events
In-Reply-To: <1300196470.2203.61.camel@twins>
Message-ID: <alpine.DEB.2.00.1103151206140.9668@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1103111745070.15818@cl320.eecs.utk.edu>  <alpine.DEB.2.00.1103141824190.13179@cl320.eecs.utk.edu>  <20110314223224.GD9388@ghostprotocols.net>  <alpine.DEB.2.00.1103142026350.16076@cl320.eecs.utk.edu> 
 <alpine.DEB.2.00.1103142224150.20209@cl320.eecs.utk.edu> <1300196470.2203.61.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011, Peter Zijlstra wrote:

> Subject: perf: Fix tear-down of inherited group events
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue Mar 15 14:37:10 CET 2011
> 
> When destroying inherited events, we need to destroy groups too,
> otherwise the event iteration in perf_event_exit_task_context() will
> miss group siblings and we leak events with all the consequences.

Thanks for the fix!  I can verify that when applied against current 
linus-git kernel that my original test case no longer leaks memory.

I've also run the full PAPI regression tests, plus the BLAS/PAPI benchmark 
code that originally showed the problem and everything checks out fine.

It's a shame this fix didn't make it in before 2.6.38.

Tested-by: Vince Weaver <vweaver1@eecs.utk.edu>

Vince
vweaver1@eecs.utk.edu

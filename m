Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab2ERQEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:04:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36482 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757788Ab2ERQET convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:04:19 -0400
Message-ID: <1337357041.573.86.camel@twins>
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        pjt@google.com, bharata.rao@gmail.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, aarcange@redhat.com, danms@us.ibm.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Date: Fri, 18 May 2012 18:04:01 +0200
In-Reply-To: <alpine.DEB.2.00.1205181057400.21093@router.home>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org>
	 <4FB66756.2060302@redhat.com> <1337355341.573.68.camel@twins>
	 <1337355610.573.70.camel@twins>
	 <alpine.DEB.2.00.1205181047030.21093@router.home>
	 <1337356192.573.75.camel@twins>
	 <alpine.DEB.2.00.1205181057400.21093@router.home>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 11:00 -0500, Christoph Lameter wrote:

> Having the page local is a win if there are a sufficient number of
> accesses to amortize the effort to move the page. Given the expensive
> nature of page migration there would need to be a large number of accesses
> to a page to justify the effort.

Right, but this is true of any migration scheme and not specific to MoF.

> > How does it matter how you migrate?
> 
> Migrate on fault incurs two types of costs:
> 
> 1. Unmapping. This results in additional faults to reestablish the ptes.
> 
> 2. Actual lazy migrate. More faults. Now the page needs to be copied to
>    the new node and the actual migration work is done. 

Nah, only the 1 fault is extra. Regular migration already needs to unmap
and copy and reinstate, so the only extra work is the fault to trigger
it.





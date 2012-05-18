Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab2ERPeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:34:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:59244 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab2ERPeB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:34:01 -0400
Message-ID: <1337355223.573.66.camel@twins>
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        pjt@google.com, bharata.rao@gmail.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, aarcange@redhat.com, danms@us.ibm.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Date: Fri, 18 May 2012 17:33:43 +0200
In-Reply-To: <alpine.DEB.2.00.1205181022470.21093@router.home>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org>
	 <4FB66756.2060302@redhat.com>
	 <alpine.DEB.2.00.1205181022470.21093@router.home>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 10:25 -0500, Christoph Lameter wrote:
> On Fri, 18 May 2012, Rik van Riel wrote:
> 
> > I like your code for handling smaller processes in NUMA
> > systems, but we do need to have a serious discussion on
> > how to handle processes that do not fit in one node.
> 
> The home node seems to be associated with a thread and not a process. So
> we would be able to have multiple home nodes per process.

Its set the same for every thread in a process, unless you use the new
system calls to carve it up in pieces.

> The whole NUMA policy thing is already quite complex and this will
> increase that complexity somewhat. Wish we could simplify things somehow.

Most of that is due to existing interfaces, I'm afraid we cannot
simplify without reducing those :/

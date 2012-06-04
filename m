Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2FDUdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 16:33:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:34699 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab2FDUdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 16:33:40 -0400
Message-ID: <1338842001.28282.135.camel@twins>
Subject: Re: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 04 Jun 2012 22:33:21 +0200
In-Reply-To: <alpine.LFD.2.02.1206042203590.3086@ionos>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
	 <alpine.LFD.2.02.1206042203590.3086@ionos>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 22:11 +0200, Thomas Gleixner wrote:

> I understand what you are trying to do, though I completely disagree
> with the solution.
> 
> The main problem of the current hotplug code is that it is an all or
> nothing approach. You have to tear down the whole thing completely
> instead of just taking it out of the usable set of cpus.
> 
> I'm working on a proper state machine driven online/offline sequence,
> where you can put the cpu into an intermediate state which avoids
> bringing it down completely. This is enough to get the full
> powersaving benefits w/o having to go through all the synchronization
> states of a full online/offline. That will shorten the onlining time
> of an previously offlined cpu to almost nothing.
> 
> I really want to avoid adding more bandaids to the hotplug code before
> we have sorted out the existing horror.

Its far worse.. you shouldn't _ever_ care about hotplug latency unless
you've got absolutely braindead hardware. We all now ARM has been
particularly creative here, but is Intel now trying to trump ARM at
stupid?

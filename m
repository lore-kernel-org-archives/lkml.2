Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761124Ab2FDWwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 18:52:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:43431 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990Ab2FDWwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 18:52:37 -0400
Date: Tue, 5 Jun 2012 00:52:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Luck, Tony" <tony.luck@intel.com>
cc: "Yu, Fenghua" <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: RE: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192F7F17@ORSMSX104.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.02.1206050049410.3086@ionos>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com> <alpine.LFD.2.02.1206042203590.3086@ionos> <3908561D78D1C84285E8C5FCA982C28F192F7F17@ORSMSX104.amr.corp.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2012, Luck, Tony wrote:

> > I'm working on a proper state machine driven online/offline sequence,
> > where you can put the cpu into an intermediate state which avoids
> > bringing it down completely. This is enough to get the full
> > powersaving benefits w/o having to go through all the synchronization
> > states of a full online/offline. That will shorten the onlining time
> > of an previously offlined cpu to almost nothing.
> 
> Will this also be a step towards Fenghua's goal of being able to
> take cpu#0 away. I.e. will your state machine be fully symmetric
> and allow for cpu#0 to enter this intermediate mostly-offline state?

The state machine does not care about the cpu number.

The only reverence to the initial boot cpu is that it can enter the
state machine at the "running" level instead of going through all
instances. That's unavoidable AFAICT.

Thanks,

	tglx

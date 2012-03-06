Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab2CFJOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 04:14:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50812 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878Ab2CFJOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 04:14:20 -0500
Date: Tue, 6 Mar 2012 10:14:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
Message-ID: <20120306091410.GD27238@elte.hu>
References: <1329764866.2293.376.camhel@twins>
 <20120305152443.GE26559@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305152443.GE26559@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> * Peter Zijlstra <peterz@infradead.org> [2012-02-20 20:07:46]:
> 
> > On Mon, 2012-02-20 at 19:14 +0100, Mike Galbraith wrote:

> > > Enabling SD_BALANCE_WAKE used to be decidedly too 
> > > expensive to consider. Maybe that has changed, but I doubt 
> > > it.
> > 
> > Right, I through I remembered somet such, you could see it 
> > on wakeup heavy things like pipe-bench and that java msg 
> > passing thing, right?
> 
> I did some experiments with volanomark and it does turn out to 
> be sensitive to SD_BALANCE_WAKE, while the other wake-heavy 
> benchmark that I am dealing with (Trade) benefits from it.

Does volanomark still do yield(), thereby invoking a random 
shuffle of thread scheduling and pretty much voluntarily 
ejecting itself from most scheduler performance considerations?

If it uses a real locking primitive such as futexes then its 
performance matters more.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab2FLP3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:29:54 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34461 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2FLP3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:29:53 -0400
Message-ID: <1339515061.4999.102.camel@lappy>
Subject: Re: rcu,sched: spinlock recursion on 3.5-rc2
From: Sasha Levin <levinsasha928@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Date: Tue, 12 Jun 2012 17:31:01 +0200
In-Reply-To: <1339514114.31548.78.camel@twins>
References: <1339500907.4999.99.camel@lappy>
	 <alpine.LFD.2.02.1206121535180.3086@ionos>
	 <20120612144705.GB2423@linux.vnet.ibm.com>
	 <alpine.LFD.2.02.1206121701350.3086@ionos>
	 <1339514114.31548.78.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 17:15 +0200, Peter Zijlstra wrote:
> On Tue, 2012-06-12 at 17:07 +0200, Thomas Gleixner wrote:
> > Hmm, not sure. The deadlock was not triggered in switch_to. It was
> > just at the beginning of __schedule()
> > 
> > 
> How can you tell? switch_to() is a macro not a function, it won't ever
> show up on a stack-trace.. but I think you meant context_switch() but
> that typically gets inlined, similar problem.

addr2line -i confirmed it was pointing to switch_to(), if it matters.

btw, wouldn't it be nice if there were a short script that would take an
oops and convert all those kernel addresses into file+line numbers based
on a given vmlinux? It would make our lives so much easier.


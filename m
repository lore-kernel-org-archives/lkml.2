Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab2GJKvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 06:51:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:38469 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab2GJKvq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 06:51:46 -0400
Message-ID: <1341917490.3462.119.camel@twins>
Subject: Re: [PATCH 14/16] sched: make __update_entity_runnable_avg() fast
From: Peter Zijlstra <peterz@infradead.org>
To: Benjamin Segall <bsegall@google.com>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Tue, 10 Jul 2012 12:51:30 +0200
In-Reply-To: <xm26fw90zo16.fsf@sword-of-the-dawn.mtv.corp.google.com>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
	 <20120628022415.30496.53532.stgit@kitami.mtv.corp.google.com>
	 <1341416463.19870.6.camel@laptop> <1341422408.19870.12.camel@laptop>
	 <xm26fw90zo16.fsf@sword-of-the-dawn.mtv.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 13:18 -0700, Benjamin Segall wrote:
> Correct, the sum is 1..n. The maximum was chosen as 516/46742 because
> that is the point when the approximation of loop + fixed point math
> being used reaches a maximum, even if the ideal y^n series would cap out
> slightly differently.

Can you run a simple kid like me through the math here.. it seems
strange that fixed point math would give a higher order term than the
regular case. And by such a wide margin as well, (516-320)/32 ~ 6, so
that's 1/64-th of the 320-th term.



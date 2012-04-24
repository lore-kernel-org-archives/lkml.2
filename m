Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab2DXRPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:15:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44345 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab2DXRPW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:15:22 -0400
Message-ID: <1335287700.28150.211.camel@twins>
Subject: Re: [PATCH bisected regression] sched: rebuild sched domains at
 suspend/resume
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Date: Tue, 24 Apr 2012 19:15:00 +0200
In-Reply-To: <4F9555C5.6040601@linux.vnet.ibm.com>
References: <20120306204357.13169.90791.stgit@zurg>
	 <1331067743.11248.333.camel@twins>
	 <CA+55aFxPiW=T8iNy=Fb_fuO2DYV9+sQL-mr8=Uc7cWymTyVt6A@mail.gmail.com>
	 <1331084302.11248.338.camel@twins>
	 <CA+55aFx6NXjLpAz_Bu1wvaxFB-2zrYGkfBeN_8rM5q7MkYuNEQ@mail.gmail.com>
	 <4F5D00AE.8000602@openvz.org> <4F9555C5.6040601@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 18:44 +0530, Srivatsa S. Bhat wrote:
> 
> Basically, our assumption that we are good to go (even with stale sched
> domains) as long as the dying cpu was not in the cpu_active_mask, was wrong. 

Argh, that means cpu_active_mask is pointless.. so we should either fix
that or remove that thing entirely.

Anyway, tglx is reworking all that hotplug stuff as we speak, I think
its best to wait for that dust to settle before we go make the mess even
bigger.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab1ADRQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 12:16:23 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59431 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab1ADRQW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 12:16:22 -0500
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <20110104151345.3BC2.A69D9226@jp.fujitsu.com>
References: <20110103162637.29f23c40@annuminas.surriel.com>
	 <20110103162918.577a9620@annuminas.surriel.com>
	 <20110104151345.3BC2.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 Jan 2011 18:16:39 +0100
Message-ID: <1294161399.2016.175.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 15:14 +0900, KOSAKI Motohiro wrote:
> > From: Mike Galbraith <efault@gmx.de>
> > 
> > Add a yield_to function to the scheduler code, allowing us to
> > give enough of our timeslice to another thread to allow it to
> > run and release whatever resource we need it to release.
> > 
> > We may want to use this to provide a sys_yield_to system call
> > one day.
> 
> At least I want. Ruby has GIL(giant interpreter lock). And giant lock
> naturally enforce an app to implement cooperative multithreading model.
> Therefore it has similar problem with your one. Python solved this issue
> by slowing lock mechanism (two pthread-cond wakeup each GIL releasing), 
> but I don't want it.
> 
> Also, If pthread_cond_signal() call sys_yield_to imlicitly, we can
> avoid almost Nehalem (and other P2P cache arch) lock unfairness 
> problem. (probaby creating pthread_condattr_setautoyield_np or similar
> knob is good one)

NAK NAK NAK, yield_to is utter crap, and the only reason kvm 'needs' it
is because its wants to be utter crap (run unmodified guests).

There is plenty of sane serialization primitives for userspace, fix your
locking mess instead of pushing crap.

The only reason I'm maybe half-way considering this is because its a
pure in-kernel interface which we can 'fix' once unmodified guests
aren't important anymore.



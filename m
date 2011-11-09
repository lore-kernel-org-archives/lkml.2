Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1KIOCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 09:02:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54974 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1KIOCk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 09:02:40 -0500
Subject: Re: [PATCH RFC tip/core/rcu 05/28] lockdep: Update documentation
 for lock-class leak detection
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org
Date: Wed, 09 Nov 2011 15:02:08 +0100
In-Reply-To: <20111103194226.GG2287@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
	 <1320265849-5744-5-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20111103025716.GA2042@leaf> <20111103194226.GG2287@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320847328.19727.2.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 12:42 -0700, Paul E. McKenney wrote:
> > If so, could we simply arrange to have lockdep scream when it encounters
> > an uninitialized spinlock?
> 
> I reworded to distinguish between compile-time initialization (which will
> cause lockdep to have a separate class per instance) and run-time
> initialization (which will cause lockdep to have one class total).

Right, runtime init will key off of the call-site, compile-time init
will key off of the static data address.

> Making lockdep scream in this case might be useful, but if I understand
> correctly, that would give false positives for compile-time initialized
> global locks. 

Yeah, that's going to bring a lot of pain with it, in particular all the
early stuff like the init task etc. are all statically initialized.

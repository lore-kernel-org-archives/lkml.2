Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053Ab2GBKca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:32:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55434 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932938Ab2GBKc2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:32:28 -0400
Message-ID: <1341225139.23484.4.camel@twins>
Subject: Re: rcu: BUG: spinlock recursion on CPU#3, trinity-child19/5970
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 02 Jul 2012 12:32:19 +0200
In-Reply-To: <1341006040.26928.4.camel@lappy>
References: <1340964584.2936.40.camel@lappy>
	 <20120629172320.GA2416@linux.vnet.ibm.com> <1341006040.26928.4.camel@lappy>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-29 at 23:40 +0200, Sasha Levin wrote:
> 
> The bad news are that what you saw was a lockdep enabled run
> (CONFIG_PROVE_RCU is enabled, and lockdep was enabled). There were no
> lockdep warnings at any point while reproducing it. 

rcu_switch_from() -> rcu_preempt_note_context_switch() is called _after_
the lockdep context switch annotation. Therefore lockdep things the prev
task isn't holding any locks anymore.



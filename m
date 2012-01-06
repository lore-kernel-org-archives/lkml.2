Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030309Ab2AFLBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 06:01:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34933 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875Ab2AFLBS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 06:01:18 -0500
Message-ID: <1325847671.2442.7.camel@twins>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
From: Peter Zijlstra <peterz@infradead.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Date: Fri, 06 Jan 2012 12:01:11 +0100
In-Reply-To: <20120106192256.AB15.E1E9C6FF@jp.fujitsu.com>
References: <20111226171151.GA4472@redhat.com>
	 <20111227154828.5120.E1E9C6FF@jp.fujitsu.com>
	 <20120106192256.AB15.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-06 at 19:22 +0900, Yasunori Goto wrote:
> I just confirmed booting up on my box, and I would like to get rough agreement
> about this way to solve this issue at first. 

I really don't like it. It makes the ttwu path more complex and more
expensive. ttwu is one of the hottest and more complex paths in the
scheduler, it needs neither more overhead nor more complexity.

I'd really much rather put another raw_spin_unlocked_wait() in do_exit()
before we set TASK_DEAD. It probably needs an smp memory barrier too.

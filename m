Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab2AXKLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 05:11:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34574 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab2AXKLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 05:11:39 -0500
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special
 condition
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>, Yasunori Goto <y-goto@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
In-Reply-To: <20120118094219.GE5842@elte.hu>
References: <20120116205140.6120.E1E9C6FF@jp.fujitsu.com>
	 <1326721082.2442.234.camel@twins>
	 <20120117174031.3118.E1E9C6FF@jp.fujitsu.com>
	 <20120117090605.GD7612@elte.hu> <20120117151242.GA13290@redhat.com>
	 <20120118094219.GE5842@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Jan 2012 11:11:25 +0100
Message-ID: <1327399885.2614.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-18 at 10:42 +0100, Ingo Molnar wrote:
> Well, but does the -rt kernel suffer from the same race? 

Yes it does

> It can 
> generate delays at the exact same place, and can generate much 
> longer delays than an SMI, if a high-prio RT task comes along.
> 
No it can't, since do_exit() plays silly games with preempt_disable().


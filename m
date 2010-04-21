Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0DUMYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 08:24:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60529 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab0DUMYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 08:24:34 -0400
Subject: Re: [PATCH v3] lockdep: Make MAX_STACK_TRACE_ENTRIES configurable.
From: Peter Zijlstra <peterz@infradead.org>
To: John Kacur <jkacur@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <alpine.LFD.2.00.1004211407510.4506@localhost.localdomain>
References: <alpine.LFD.2.00.1004161329030.11320@localhost.localdomain>
	 <alpine.LFD.2.00.1004161727000.11320@localhost.localdomain>
	 <alpine.LFD.2.00.1004191841230.6259@localhost>
	 <20100420140941.d085007d.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1004211309560.6646@localhost>
	 <1271849823.1776.87.camel@laptop>
	 <alpine.LFD.2.00.1004211407510.4506@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 14:24:31 +0200
Message-ID: <1271852671.1776.101.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 14:12 +0200, John Kacur wrote:
> 
>  lock-classes:                         1330 [max: 8191]
>  direct dependencies:                 12754 [max: 16384]
>  indirect dependencies:               33245
>  all direct dependencies:             49074
>  dependency chains:                   19641 [max: 32768]

Right, so each dependency also gets a stack trace, see
add_lock_to_list().

>  dependency chain hlocks:             73246 [max: 163840]
>  in-hardirq chains:                      25
>  in-softirq chains:                       0
>  in-process chains:                   19616
>  stack-trace entries:                262144 [max: 262144]
> 
> 
> I'm looking at more details in /proc/lockdep and friends to see if
> I can find any more details, or something that looks amiss.
> 
It might be useful to add a counter that simply counts all save_trace()
invocations, and maybe split them out according to new_bit in
mark_lock().


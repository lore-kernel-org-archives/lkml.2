Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab0KXIPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:15:23 -0500
Received: from canuck.infradead.org ([134.117.69.58]:43527 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab0KXIPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:15:21 -0500
Subject: Re: [thiscpuops upgrade 10/10] Lockless (and preemptless)
 fastpaths for slub
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <20101123235201.758191189@linux.com>
References: <20101123235139.908255844@linux.com>
	 <20101123235201.758191189@linux.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Nov 2010 09:15:12 +0100
Message-ID: <1290586512.2072.423.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 17:51 -0600, Christoph Lameter wrote:
> So there is no need even to disable preemption which will make the allocations
> scale well in a RT environment. 

The RT thing isn't particularly about scaling per-se, its mostly about
working at all.

This thing still relies on disabling IRQs in the slow path, which means
its still going to be a lot of work to make it work on -rt.

It also heavily relies on bit-spinlocks, which again is going to need
changes for -rt.

But yes, the lockless fast path is nice, I'll try and get around to
reading it.

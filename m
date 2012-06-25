Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab2FYTdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 15:33:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37584 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab2FYTdi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 15:33:38 -0400
Message-ID: <1340652807.21991.19.camel@twins>
Subject: Re: [BUG] sched: clock wrap bug in 2.6.35-stable kills scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Lange <thomas@corelatus.se>
Cc: mingo@redhat.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Mon, 25 Jun 2012 21:33:27 +0200
In-Reply-To: <4FE8B2D1.3070600@corelatus.se>
References: <4FE74F1B.6070803@corelatus.se>
		 <1340617541.2507.50.camel@laptop> <1340620706.2507.51.camel@laptop>
	 <4FE8B2D1.3070600@corelatus.se>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-25 at 20:49 +0200, Thomas Lange wrote:
> Commit fe44d62 removed the if-clause that caused the problem. Most likely, this
> solved the problem.

Ah, probably. IIRC we also fixed the short wrap of those arm clocks
since.

> > If anything, I think something like the below ought to cure things.
> 
> I agree. Either we make sure that sched_clock() never wraps or if it wraps,
> that it wraps shortly after boot to catch problems early.

Right, sched_clock() should only ever wrap on the full u64.

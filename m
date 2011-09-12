Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab1ILSxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 14:53:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38285 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab1ILSxw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 14:53:52 -0400
Subject: Re: [PATCH 8/5] llist: Remove cpu_relax() usage in cmpxchg loops
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 12 Sep 2011 20:53:28 +0200
In-Reply-To: <20110912163842.GO7761@one.firstfloor.org>
References: <1315461646-1379-1-git-send-email-ying.huang@intel.com>
	 <1315836358.26517.43.camel@twins>
	 <20110912142305.GN7761@one.firstfloor.org> <20110912144706.GA21716@Krystal>
	 <20110912163842.GO7761@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1315853608.575.1.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-12 at 18:38 +0200, Andi Kleen wrote:
> > so basically, in typical locking primitives (spinlock), it looks like
> > lower power consumption is preferred over getting the raw maximal
> 
> It's not only power, its:
> - Allow the other siblings make more progress on SMT
> - Do some backoff to stress the interconnect less (this is important on >2S):
> A tight loop which constantly writes is a extremly stressfull pattern.
> - Save some power by allowing the CPU to do more clock gating

If you're hitting a cmpxchg hard enough for any of those to make a
difference you're doing it wrong.

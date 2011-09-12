Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab1ILQit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 12:38:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40244 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1ILQis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 12:38:48 -0400
Date: Mon, 12 Sep 2011 18:38:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/5] llist: Remove cpu_relax() usage in cmpxchg loops
Message-ID: <20110912163842.GO7761@one.firstfloor.org>
References: <1315461646-1379-1-git-send-email-ying.huang@intel.com> <1315836358.26517.43.camel@twins> <20110912142305.GN7761@one.firstfloor.org> <20110912144706.GA21716@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110912144706.GA21716@Krystal>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> so basically, in typical locking primitives (spinlock), it looks like
> lower power consumption is preferred over getting the raw maximal

It's not only power, its:
- Allow the other siblings make more progress on SMT
- Do some backoff to stress the interconnect less (this is important on >2S):
A tight loop which constantly writes is a extremly stressfull pattern.
- Save some power by allowing the CPU to do more clock gating

-Andi

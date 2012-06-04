Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab2FDLxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:53:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48548 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab2FDLxe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:53:34 -0400
Message-ID: <1338810796.28282.32.camel@twins>
Subject: Re: [PATCH] sched: balance_cpu to consider other cpus in its group
 as target of (pinned) task migration
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Date: Mon, 04 Jun 2012 13:53:16 +0200
In-Reply-To: <1338801907.7356.163.camel@marge.simpson.net>
References: <4FCC4E3B.4090209@linux.vnet.ibm.com>
	 <1338801907.7356.163.camel@marge.simpson.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 11:25 +0200, Mike Galbraith wrote:
> Isn't this poking the wrong spot?

Yes and no, the use-case is definitely so-so.. However, even if a FIFO
task were to only consume 95% of time, we might still want to balance
things differently, and I don't think we do the sane thing there either.

But fully agreed, if you run FIFO at 100% you get to keep the pieces.

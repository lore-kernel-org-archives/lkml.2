Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab2EVJBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 05:01:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:51335 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab2EVJBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 05:01:17 -0400
Message-ID: <1337677268.9698.6.camel@twins>
Subject: Re: [PATCH 0/2] RFC: readd fair sleepers for server systems
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Date: Tue, 22 May 2012 11:01:08 +0200
In-Reply-To: <1337615137-55111-1-git-send-email-schwidefsky@de.ibm.com>
References: <1337615137-55111-1-git-send-email-schwidefsky@de.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-21 at 17:45 +0200, Martin Schwidefsky wrote:
> our performance team found a performance degradation with a recent
> distribution update in regard to fair sleepers (or the lack of fair
> sleepers). On s390 we used to run with fair sleepers disabled.

This change was made a very long time ago.. tell your people to mind
what upstream does if they want us to mind them.

Also, reports like this make me want to make /debug/sched_features a
patch in tip/out-of-tree so that its never available outside
development.

> We see the performance degradation with our network benchmark and fair
> sleepers enabled, the largest hit is on virtual connections:
> 
> VM guest Hipersockets 
>    Throughput degrades up to 18% 
>    CPU load/cost increase up to 17%
> VM stream 
>    Throughput degrades up to 15% 
>    CPU load/cost increase up to 22%
> LPAR Hipersockets
>    Throughput degrades up to 27% 
>    CPU load/cost increase up to 20%

Why is this, is this some weird interaction with your hypervisor?

> In short, we want the fair sleepers tunable back. I understand that on
> x86 we want to avoid the cost of a branch on the hot path in place_entity,
> therefore add a compile time config option for the fair sleeper control.

I'm very much not liking this... this makes s390 schedule completely
different from all the other architectures.

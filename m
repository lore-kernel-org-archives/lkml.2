Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab2EIUjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:39:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:44105 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347Ab2EIUj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:39:29 -0400
Message-ID: <1336595963.2527.69.camel@twins>
Subject: Re: [tip:sched/core] sched/fair: Let minimally loaded cpu balance
 the group
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Date: Wed, 09 May 2012 22:39:23 +0200
In-Reply-To: <tip-v8zlrmgmkne3bkcy9dej1fvm@git.kernel.org>
References: <tip-v8zlrmgmkne3bkcy9dej1fvm@git.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 07:26 -0700, tip-bot for Peter Zijlstra wrote:
> sched/fair: Let minimally loaded cpu balance the group
> 
> Currently we let the leftmost (or first idle) cpu ascend the
> sched_domain tree and perform load-balancing. The result is that the
> busiest cpu in the group might be performing this function and pull
> more load to itself. The next load balance pass will then try to
> equalize this again.
> 
> Change this to pick the least loaded cpu to perform higher domain
> balancing. 

OK, so while this all sounds great its horrible broken.. there's no
guarantee the selected cpu actually gets to balance the domain for it
might never reach as high in its own balance pass since by then it might
not be the least loaded anymore.

Will have to poke at this more tomorrow, but from what my tired brain
makes of it there's nothing but a straight revert (and probably similar
for the next patch).



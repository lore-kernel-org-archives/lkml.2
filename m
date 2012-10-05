Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab2JELMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 07:12:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932255Ab2JELMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 07:12:20 -0400
Date: Fri, 5 Oct 2012 13:11:40 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <pzijlstr@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hillf Danton <dhillf@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Dan Smith <danms@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 29/33] autonuma: page_autonuma
Message-ID: <20121005111140.GE6793@redhat.com>
References: <20121004165008.GF25675@redhat.com>
 <0000013a2cff3c3d-76e00716-2869-4dc8-8717-82f0136018d0-000000@email.amazonses.com>
 <20121004183819.GM25675@redhat.com>
 <0000013a2d30ebf2-1a2bb821-92a0-464b-9db0-f960b2fd074d-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013a2d30ebf2-1a2bb821-92a0-464b-9db0-f960b2fd074d-000000@email.amazonses.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Thu, Oct 04, 2012 at 07:11:51PM +0000, Christoph Lameter wrote:
> I did not say anything like that. Still not convinced that autonuma is
> worth doing and that it is beneficial given the complexity it adds to the
> kernel. Just wanted to point out that there is a case to be made for
> adding another word to the page struct.

You've seen the benchmarks, no other solution that exists today solves
all those cases and never showed a regression compared to
upstream. Running that much faster is very beneficial in my
view.

Expecting the admin of a 2 socket system to use hard bindings manually
is unrealistic, even for a 4 socket is unrealistic.

If you've 512 node system well then you can afford to setup everything
manually and boot with noautonuma, no argument about that.

About the complexity, well there's no simple solution to an hard
problem. The proof comes from the schednuma crowd that is currently
copying the AutoNUMA scheduler cpu-follow-memory design at full force
as we speak.

Thanks,
Andrea

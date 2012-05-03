Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab2ECIfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 04:35:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:35861 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab2ECIfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 04:35:43 -0400
Message-ID: <1336034127.13683.197.camel@twins>
Subject: Re: [RFC] sched: make callers check lock contention for
 cond_resched_lock()
From: Peter Zijlstra <peterz@infradead.org>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        yoshikawa.takuya@oss.ntt.co.jp
Date: Thu, 03 May 2012 10:35:27 +0200
In-Reply-To: <20120503171244.2debdd80931ccf35f387c5fe@gmail.com>
References: <20120503171244.2debdd80931ccf35f387c5fe@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 17:12 +0900, Takuya Yoshikawa wrote:
> 
> Although we can do that using spin_is_contended() and cond_resched(),
> changing cond_resched_lock() to satisfy such a need is another option.
> 
Yeah, not a pretty patch. Changing all cond_resched_lock() sites just to
change one and in such an ugly way too.

So what's the impact of making spin_needbreak() work for !PREEMPT?

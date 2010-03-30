Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab0C3Sez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 14:34:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34139 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab0C3Sey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 14:34:54 -0400
Subject: Re: [PATCH] increase PREEMPT_BITS to 12 to avoid overflow when
 starting KVM
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, aarcange@redhat.com,
       akpm@linux-foundation.org, Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, tglx <tglx@linutronix.de>
In-Reply-To: <4BB23D64.70502@redhat.com>
References: <20100330133634.2f1bf3d6@cuia.bos.redhat.com>
	 <1269971802.5258.524.camel@laptop>  <4BB23D64.70502@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 20:34:49 +0200
Message-ID: <1269974089.5258.565.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-30 at 14:05 -0400, Rik van Riel wrote:
> > Also, you'll need to convince mingo and tglx too.. taking that many
> > spinlocks is utter suckage..
> 
> No argument there.  I can't think of an alternative to mm_take_all_locks
> though.  Andrea? 

Well there's altneratives enough, back when this got introduces quite a
few got mentioned too, but they all make the !mm_take_all_locks() lock
side slower so Andrea didn't like them.

I think one of them got mentioned in yesterday's thread as well.

Another alternative is making all those spinlocks mutexes, that will get
rid of that massive !preempt section too.


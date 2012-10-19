Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab2JSOi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:38:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:50108 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab2JSOiy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:38:54 -0400
Message-ID: <1350657519.2768.27.camel@twins>
Subject: Re: [tip:numa/core] sched/numa/mm: Improve migration
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, mgorman@suse.de, tglx@linutronix.de
Date: Fri, 19 Oct 2012 16:38:39 +0200
In-Reply-To: <20121019135122.GI31863@cmpxchg.org>
References: <tip-yv9vbiz2s455zxq1ffzx3fye@git.kernel.org>
	 <20121019135122.GI31863@cmpxchg.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-19 at 09:51 -0400, Johannes Weiner wrote:
> Right now, unlike the traditional migration path, this breaks COW for
> every migration, but maybe you don't care about shared pages in the
> first place.  And fixing that should be nothing more than grabbing the
> anon_vma lock and using rmap to switch more than one pmd over, right?
> 

This patch was very much about getting _something_ rather than caring
(too much) about all the weird corner cases.

And yes, your suggestion sounds about right.

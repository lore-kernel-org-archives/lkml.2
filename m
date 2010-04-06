Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab0DFM5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 08:57:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50957 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab0DFM5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 08:57:40 -0400
Subject: Re: Random scheduler/unaligned accesses crashes with perf lock
 events on sparc 64
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
       paulus@samba.org
In-Reply-To: <1270558450.6369.30.camel@marge.simson.net>
References: <20100405065701.GC5127@nowhere>
	 <20100405.122233.188421941.davem@davemloft.net>
	 <20100405194055.GA5265@nowhere>
	 <20100406.025049.267615796.davem@davemloft.net>
	 <20100406113830.GF5147@nowhere>  <1270554716.1595.134.camel@laptop>
	 <1270558450.6369.30.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 14:57:35 +0200
Message-ID: <1270558655.1595.265.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 14:54 +0200, Mike Galbraith wrote:
> > ARGH.. yes
> > 
> > Also, I guess that should live in perf_output_lock/unlock() not in
> > perf_event_task_output().
> > 
> > Egads, how to fix that
> 
> Damn, so deadlock fix isn't a fix.  No idea. 

well it is,. but it breaks sparc..

I'm currently compile testing a bunch to fix all that up by doing what
davem suggested: local_irq_save_nmi()/local_irq_restore_nmi().




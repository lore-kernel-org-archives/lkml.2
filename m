Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab2AaNCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:02:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50646 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab2AaNCK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:02:10 -0500
Message-ID: <1328014916.2446.217.camel@twins>
Subject: Re: x86: clean up smpboot.c's use of udelay+schedule
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, arjanvandeven@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 31 Jan 2012 14:01:56 +0100
In-Reply-To: <20120131125331.GE4408@elte.hu>
References: <20120130205304.0e10b05e@infradead.org>
	 <20120131124341.GC4408@elte.hu> <1328014076.2446.210.camel@twins>
	 <20120131125331.GE4408@elte.hu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-31 at 13:53 +0100, Ingo Molnar wrote:
> Wanna give a short TODO list to anyone wanting to work on that?

I paged out most details again, but it goes something like:

 - read and understand the current generic code

 - and all architecture code, at which point you'll probably boggle
   at all the similarities that are all subtly different (there's
   about 3 actually different ways in the arch code).

 - pick one, preferably one that keeps additional state and doesn't
   fully rely on the online bits and pull it into generic code and
   provide a small vector of arch specific functions.

 - convert all archs over.


Also related:

 - figure out why cpu_down needs kstopmachine, I'm not sure it does..
   we should be able to tear down a cpu using synchronize_sched() and a
   single stop_one_cpu(). (someday when there's time I might actually
   try to implement this).

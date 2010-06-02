Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab0FBBah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 21:30:37 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48010 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081Ab0FBBaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 21:30:35 -0400
Date: Tue, 1 Jun 2010 18:38:39 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Albert Cahalan <acahalan@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, randy.dunlap@oracle.com,
       linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v21 011/100] eclone (11/11): Document sys_eclone
Message-ID: <20100602013839.GB17579@us.ibm.com>
References: <AANLkTimDfbJkAuoK1-asvk8Ub9C9QBkK5RkzLR3ilJUY@mail.gmail.com> <20100601193230.GA17579@us.ibm.com> <AANLkTinxCKl7RVe62UhIpNe5EriCufkgaih2D2mLLmC4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinxCKl7RVe62UhIpNe5EriCufkgaih2D2mLLmC4@mail.gmail.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| Come on, seriously, you know it's ia64 and hppa that
| have issues. Maybe the nommu ports also have issues.
| 
| The only portable way to specify the stack is base and offset,
| with flags or magic values for "share" and "kernel managed".

Ah, ok, we have not yet ported to IA64 and I see now where the #ifdef
comes in.

But are you saying that we should force x86 and other architectures to
specify base and offset for eclone() even though they currently specify
just the stack pointer to clone() ?

That would remove the ifdef, but could be a big change to applications
on x86 and other architectures.

| 
| > | There is no reason to have field usage vary by architecture. The
| >
| > The field usage does not vary by architecture. Some architectures
| > don't use some fields and those fields must be 0.
| 
| It looks like you contradict yourself. Please explain how
| those two sentences are compatible.
| 
| > | original clone syscall was not designed with ia64 and hppa
| > | in mind, and has been causing trouble ever since. Let's not
| > | perpetuate the problem.
| >
| > and lot of folks contributed to this new API to try and make sure
| > it is portable and meets the forseeable requirements.
| 
| Right, and some folks were ignored.

I don't think your comment was ignored. The ->child_stack_size field was
added specifically for IA64 and my understanding was that ->clone_flags_high
could be used to specify the "kernel managed" or "shared" mode you mention
above.

| >
| > I don't understand how "making up some numbers (pids) that will work"
| > is more portable/cleaner than the proposed eclone().
| 
| It isolates the cross-platform problems to an obscure tool
| instead of polluting the kernel interface that everybody uses.

Sure, there was talk about using an approach like /proc/<pid>/next_pid
where you write your target pid into the file and the next time you
fork() you get that target pid. But it was considered racy and ugly.

Sukadev

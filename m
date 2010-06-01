Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab0FATYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 15:24:33 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49487 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab0FATYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 15:24:32 -0400
Date: Tue, 1 Jun 2010 12:32:30 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Albert Cahalan <acahalan@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, randy.dunlap@oracle.com,
       linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v21 011/100] eclone (11/11): Document sys_eclone
Message-ID: <20100601193230.GA17579@us.ibm.com>
References: <AANLkTimDfbJkAuoK1-asvk8Ub9C9QBkK5RkzLR3ilJUY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimDfbJkAuoK1-asvk8Ub9C9QBkK5RkzLR3ilJUY@mail.gmail.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Albert Cahalan [acahalan@gmail.com] wrote:
| Sukadev Bhattiprolu writes:
| 
| > Randy Dunlap [randy.dunlap at oracle.com] wrote:
| >>> base of the region allocated for stack. These architectures
| >>> must pass in the size of the stack-region in ->child_stack_size.
| >>
| >>                               stack region
| >>
| >> Seems unfortunate that different architectures use
| >> the fields differently.
| >
| > Yes and no. The field still has a single purpose, just that
| > some architectures may not need it. We enforce that if unused
| > on an architecture, the field must be 0. It looked like
| > the easiest way to keep the API common across architectures.
| 
| Yuck. You're forcing userspace to have #ifdef messes or,
| more likely, just not work on all architectures.

There is going to be #ifdef code in the library interface to eclone().
But applications should not need any #ifdefs. Please see the test cases
for eclone in

	git://git.sr71.net/~hallyn/cr_tests.git

There is no #ifdef and the tests work on x86, x86_64, ppc, s390.

These use the libeclone.a built from following git-tree, which has the
arch-dependent user space code.

	git://git.ncl.cs.columbia.edu/pub/git/user-cr.git

Is that the #ifdef mess you are talking about ? I don't see that as a
consequence of the API. So maybe you can elaborate.

| There is no reason to have field usage vary by architecture. The

The field usage does not vary by architecture. Some architectures
don't use some fields and those fields must be 0. A simple 

	memset(&clone_args, 0, sizeof(clone_args))

before initializing fields is all that is required.

| original clone syscall was not designed with ia64 and hppa
| in mind, and has been causing trouble ever since. Let's not
| perpetuate the problem.

and lot of folks contributed to this new API to try and make sure
it is portable and meets the forseeable requirements.

| 
| Given code like this:   stack_base = malloc(stack_size);
| stack_base and stack_size are what the kernel needs.
| 
| I suspect that you chose the defective method for some reason
| related to restarting processes that were created with the
| older system calls. I can't say most of us even care, but in
| that broken-already case your process restarter can make up
| some numbers that will work. (for i386, the base could be the
| lowest address in the vma in which %esp lies, or even address 0)

I don't understand how "making up some numbers (pids) that will work"
is more portable/cleaner than the proposed eclone(). 

Sukadev

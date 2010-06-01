Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab0FAT7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 15:59:52 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50800 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab0FAT7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 15:59:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IkjtALD8tHKSorQOLuvubZmwdUTZCVEgZzaqlz4fpXuvMgSsBMVyybPgRiPUJ1MvtU
         fJcymXQonF2E04BNc8EemtobPEv6FpbLY+OpgfT6HTThPCj/hTYuxqVFBr0BJFstXU1S
         kBcPvAPt+7HEhBABua0nkV04ZWWCWSEkL0YKs=
MIME-Version: 1.0
In-Reply-To: <20100601193230.GA17579@us.ibm.com>
References: <AANLkTimDfbJkAuoK1-asvk8Ub9C9QBkK5RkzLR3ilJUY@mail.gmail.com>
	<20100601193230.GA17579@us.ibm.com>
Date: Tue, 1 Jun 2010 15:59:49 -0400
Message-ID: <AANLkTinxCKl7RVe62UhIpNe5EriCufkgaih2D2mLLmC4@mail.gmail.com>
Subject: Re: [PATCH v21 011/100] eclone (11/11): Document sys_eclone
From: Albert Cahalan <acahalan@gmail.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, randy.dunlap@oracle.com,
       linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 3:32 PM, Sukadev Bhattiprolu
<sukadev@linux.vnet.ibm.com> wrote:
> Albert Cahalan [acahalan@gmail.com] wrote:
> | Sukadev Bhattiprolu writes:
> | > Randy Dunlap [randy.dunlap at oracle.com] wrote:

> | >>> base of the region allocated for stack. These architectures
> | >>> must pass in the size of the stack-region in ->child_stack_size.
> | >>
> | >>                               stack region
> | >>
> | >> Seems unfortunate that different architectures use
> | >> the fields differently.
> | >
> | > Yes and no. The field still has a single purpose, just that
> | > some architectures may not need it. We enforce that if unused
> | > on an architecture, the field must be 0. It looked like
> | > the easiest way to keep the API common across architectures.
> |
> | Yuck. You're forcing userspace to have #ifdef messes or,
> | more likely, just not work on all architectures.
>
> There is going to be #ifdef code in the library interface to eclone().
> But applications should not need any #ifdefs. Please see the test cases
> for eclone in
>
>        git://git.sr71.net/~hallyn/cr_tests.git
>
> There is no #ifdef and the tests work on x86, x86_64, ppc, s390.

Come on, seriously, you know it's ia64 and hppa that
have issues. Maybe the nommu ports also have issues.

The only portable way to specify the stack is base and offset,
with flags or magic values for "share" and "kernel managed".

> | There is no reason to have field usage vary by architecture. The
>
> The field usage does not vary by architecture. Some architectures
> don't use some fields and those fields must be 0.

It looks like you contradict yourself. Please explain how
those two sentences are compatible.

> | original clone syscall was not designed with ia64 and hppa
> | in mind, and has been causing trouble ever since. Let's not
> | perpetuate the problem.
>
> and lot of folks contributed to this new API to try and make sure
> it is portable and meets the forseeable requirements.

Right, and some folks were ignored.

> | Given code like this:   stack_base = malloc(stack_size);
> | stack_base and stack_size are what the kernel needs.
> |
> | I suspect that you chose the defective method for some reason
> | related to restarting processes that were created with the
> | older system calls. I can't say most of us even care, but in
> | that broken-already case your process restarter can make up
> | some numbers that will work. (for i386, the base could be the
> | lowest address in the vma in which %esp lies, or even address 0)
>
> I don't understand how "making up some numbers (pids) that will work"
> is more portable/cleaner than the proposed eclone().

It isolates the cross-platform problems to an obscure tool
instead of polluting the kernel interface that everybody uses.

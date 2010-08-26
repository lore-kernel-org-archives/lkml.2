Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab0HZEXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 00:23:40 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:14236 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751116Ab0HZEXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 00:23:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADKGdUx5Ld90/2dsb2JhbACgQHK8WoU3BIRt
Date: Thu, 26 Aug 2010 14:23:35 +1000
From: Nick Piggin <npiggin@kernel.dk>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lglock: make lg_lock_global() actually lock globally
Message-ID: <20100826042335.GB4781@amd>
References: <20100825132815.108d8217@bike.lwn.net>
 <AANLkTimbiEMM+uyYtU41qdCuK7uRavtPYdQyx4d_g3xw@mail.gmail.com>
 <20100825141644.715258cc@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100825141644.715258cc@bike.lwn.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 02:16:44PM -0600, Jonathan Corbet wrote:
> On Wed, 25 Aug 2010 13:00:59 -0700
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > Grrr. Same disease as Nick and others. Why do you repeat the subject
> > line in the body? Don't do that. We don't want the summary line twice
> > in the commit message, and we don't want it twice in the email.
> > 
> > We simply don't want it twice. Full stop.
> 
> Sorry, I just pasted in the "git format-patch" output.  Will never ever
> ever do it again I promise cross my heart.
> 
> > > lg_lock_global() currently only acquires spinlocks for online CPUs, but
> > > it's meant to lock all possible CPUs.  At Nick's suggestion, change
> > > for_each_online_cpu() to for_each_possible_cpu() to get the expected
> > > behavior.  
> > 
> > Can you say what this actually matters for? Don't we do stop-machine
> > for CPU hotplug anyway? And if we don't, shouldn't we? Exactly because
> > otherwise "for_each_online_cpu()" is always racy (and that has nothing
> > to do with the lglock).
> 
> As I understand it from Nick (after I asked him why the two lock
> primitives were identical): the files_lock scalability work puts a
> per-CPU list of open files into each superblock.  A CPU can be offlined
> while there are open files in "its" lists, and nothing is done to shift
> those files to a still-online CPU's list.  So there will still be
> cross-CPU accesses to those lists as those files are closed; that means
> we need to be sure to acquire locks associated with offline CPUs if we
> want to avoid races.
> 
> lg_global_lock_online() is used (only) in the brlock implementation,
> instead.  In this case, there's no leftover data if a CPU goes
> offline, so no need to take locks associated with offline CPUs.

Yep, thanks Jon, I owe a bit more documentation in that file, coming up.



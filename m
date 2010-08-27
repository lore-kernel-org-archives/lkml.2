Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab0H0FvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 01:51:12 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:12401 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753094Ab0H0FvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 01:51:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMrsdkx5Ld90/2dsb2JhbACgU3K8aIU3BA
Date: Fri, 27 Aug 2010 15:51:05 +1000
From: Nick Piggin <npiggin@kernel.dk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lglock: make lg_lock_global() actually lock globally
Message-ID: <20100827055105.GA3857@amd>
References: <20100825132815.108d8217@bike.lwn.net>
 <AANLkTimbiEMM+uyYtU41qdCuK7uRavtPYdQyx4d_g3xw@mail.gmail.com>
 <4C762BF9.5010305@kernel.org>
 <20100826094613.GA6411@amd>
 <4C7638B7.9060306@kernel.org>
 <1282817329.1975.486.camel@laptop>
 <20100826113858.GA6856@amd>
 <1282823139.1975.689.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282823139.1975.689.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 01:45:39PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-08-26 at 21:38 +1000, Nick Piggin wrote:
> > I think for CPU plug, stop_machine is reasonable (especially
> > considering it is required in unload, which means any frequent
> > amount of cpu plug activity already will require stop_machine to
> > run anyway). 
> 
> How is it required? 

Well, as is implemented.

 
> Its currently implemented as such, and its sure a lot easier to do that
> way, but I could imagine that unplugging a CPU could be done without it.
 
I would much prefer the rules to be simpler and easier for all
other kernel code, and keep complexity and overheads in cpu
plug/unplug.

I don't see what is so nice about stop_machine()less cpu plug/unplug
or module unload. Module load definitely is nice because you can
have a lot of modules and on demand loading from non-privileged
operations.


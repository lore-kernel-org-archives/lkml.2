Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab2KURUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 12:20:53 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:54627 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2KURUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 12:20:52 -0500
Date: Wed, 21 Nov 2012 18:20:46 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 00/27] Latest numa/core release, v16
Message-ID: <20121121172046.GA28975@gmail.com>
References: <20121119162909.GL8218@suse.de>
 <alpine.DEB.2.00.1211191644340.24618@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1211191703270.24618@chino.kir.corp.google.com>
 <20121120060014.GA14065@gmail.com>
 <alpine.DEB.2.00.1211192213420.5498@chino.kir.corp.google.com>
 <20121120074445.GA14539@gmail.com>
 <alpine.DEB.2.00.1211200001420.16449@chino.kir.corp.google.com>
 <20121120090637.GA14873@gmail.com>
 <CA+55aFyR9FsGYWSKkgsnZB7JhheDMjEQgbzb0gsqawSTpetPvA@mail.gmail.com>
 <20121121171047.GA28875@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121121171047.GA28875@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> This is an entirely valid line of inquiry IMO.

Btw., what I did was to simply look at David's profile on the 
regressing system and I compared it to the profile I got on a 
pretty similar (but unfortunately not identical and not 
regressing) system. I saw 3 differences:

 - the numa emulation faults
 - the higher TLB miss cost
 - numa/core's failure to handle 4K pages properly

And addressed those, in the hope of one of them making a
difference.

There's a fourth line of inquiry I'm pursuing as well: the node 
assymetry that David and Paul mentioned could have a performance 
effect as well - resulting from non-ideal placement under 
numa/core.

That is not easy to cure - I have written a patch to take the 
node assymetry into consideration, I'm still testing it with 
David's topology simulated on a testbox:

   numa=fake=4:10,20,20,30,20,10,20,20,20,20,10,20,30,20,20,10

Will send the patch out later.

Thanks,

	Ingo

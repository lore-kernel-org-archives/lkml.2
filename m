Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab1CICre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 21:47:34 -0500
Received: from mout.perfora.net ([74.208.4.195]:65533 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab1CICrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 21:47:33 -0500
Date: Tue, 8 Mar 2011 21:47:08 -0500
From: Stephen Wilson <wilsons@start.ca>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Ingo Molnar <mingo@elte.hu>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] enable writing to /proc/pid/mem
Message-ID: <20110309024708.GA4941@fibrous.localdomain>
References: <1299631343-4499-1-git-send-email-wilsons@start.ca> <20110309013017.GY22723@ZenIV.linux.org.uk> <20110309021524.GA4838@fibrous.localdomain> <20110309023303.GZ22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309023303.GZ22723@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Provags-ID: V02:K0:etkbr6FHb74DVhKjUnB19Uf5sv0hBI5tvIX72HKm4Ml
 E/cO8ebRIGW7GZ5P5Ko5EJmESap+rJ4rQYgZoNTWGMvmgYXXlP
 yu+Fdt03mXMr0wvY3+kIhCa4qEFrFCZM+JRH8e5fr3af2OjgPJ
 1HiwSkaPucqTWYCeVGCzSTyc/FXM8GfgusC2uSz4fbizHwzjVd
 bdcxPAmnPUTgUo9PnYPqXKwzG615EwTRGIon95EDVg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 02:33:04AM +0000, Al Viro wrote:
> On Tue, Mar 08, 2011 at 09:15:25PM -0500, Stephen Wilson wrote:
> 
> > I think we could also remove the intermediate copy in both mem_read() and
> > mem_write() as well, but I think such optimizations could be left for
> > follow on patches.
> 
> How?  We do copy_.._user() in there; it can trigger page faults and
> that's not something you want while holding mmap_sem on some mm.

Ah, OK.   I did not think thru that subtlety.  Was merely mentioning
"things we might do afterwords" as opposed to a genuine proposal.

> Looks like a deadlock country...  So we can't do that from inside
> access_process_vm() or its analogs, which means buffering in caller.

Thanks for the feed back -- I am certainly (relatively speaking) new to
the code so your insights are most valuable.

Thanks again!


-- 
steve


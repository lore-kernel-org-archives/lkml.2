Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab0DUJD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 05:03:58 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:49157 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab0DUJD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 05:03:57 -0400
Date: Wed, 21 Apr 2010 11:03:27 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       gregkh@novell.com, Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: [RFC PATCH 0/3] Avoid the use of congestion_wait under zone pressure
Message-ID: <20100421090327.GD5336@cmpxchg.org>
References: <20100322235053.GD9590@csn.ul.ie> <4BA940E7.2030308@redhat.com> <20100324145028.GD2024@csn.ul.ie> <4BCC4B0C.8000602@linux.vnet.ibm.com> <20100419214412.GB5336@cmpxchg.org> <4BCD55DA.2020000@linux.vnet.ibm.com> <20100420153202.GC5336@cmpxchg.org> <4BCDE2F0.3010009@redhat.com> <4BCE7DD1.70900@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCE7DD1.70900@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 06:23:45AM +0200, Christian Ehrhardt wrote:
> Rik van Riel wrote:
> >You do not want the backup to kick the working set
> >out of memory, because when the user returns in the
> >morning the desktop should come back quickly after
> >the screensaver is unlocked.
> 
> IMHO it is fine to prevent that nightly backup job from not being 
> finished when the user arrives at morning because we didn't give him 
> some more cache - and e.g. a 30 sec transition from/to both optimized 
> states is fine.

For batched work maybe :-)

> What we could do is combine all our thoughts we had so far:
> a) Rik could create an experimental patch that excludes the in flight pages
> b) Johannes could create one for his suggestion to "always scan active 
> file pages but only deactivate them when the ratio is off and otherwise 
> strip buffers of clean pages"

Please drop that idea, that 'Buffers:' is a red herring.  It's just pages
that do not back files but block devices.  Stripping buffer_heads won't
achieve anything, we need to get rid of the pages.  Sorry, I should have
slept and thought before writing that suggestion.

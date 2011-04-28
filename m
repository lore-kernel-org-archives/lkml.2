Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050Ab1D1NcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 09:32:09 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47308 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754725Ab1D1NcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 09:32:06 -0400
Date: Thu, 28 Apr 2011 15:31:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/13] Swap-over-NBD without deadlocking
Message-ID: <20110428133154.GA8572@ucw.cz>
References: <1303803414-5937-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303803414-5937-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> For testing swap-over-NBD, a machine was booted with 2G of RAM with a
> swapfile backed by NBD. 16*NUM_CPU processes were started that create
> anonymous memory mappings and read them linearly in a loop. The total
> size of the mappings were 4*PHYSICAL_MEMORY to use swap heavily under
> memory pressure. Without the patches, the machine locks up within
> minutes and runs to completion with them applied.
> 
> Comments?

Nice!

It  is easy to see why swapping needs these fixes, but... dirty memory
writeout is used for memory clearing, too. Are same changes neccessary
to make that safe?

(Perhaps raise 'max dirty %' for testing?)
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

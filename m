Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423608Ab2LFOsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 09:48:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33519 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423590Ab2LFOsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 09:48:23 -0500
Date: Thu, 6 Dec 2012 15:48:21 +0100
From: Jan Kara <jack@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mgorman@suse.de,
        linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Oops in 3.7-rc8 isolate_free_pages_block()
Message-ID: <20121206144821.GC18547@quack.suse.cz>
References: <20121206091744.GA1397@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121206091744.GA1397@polaris.bitmath.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 06-12-12 10:17:44, Henrik Rydberg wrote:
> Hi Linus,
> 
> This is the third time I encounter this oops in 3.7, but the first
> time I managed to get a decent screenshot:
> 
> http://bitmath.org/test/oops-3.7-rc8.jpg
> 
> It seems to have to do with page migration. I run with transparent
> hugepages configured, just for the fun of it.
> 
> I am happy to test any suggestions.
  Adding linux-mm and Mel as an author of compaction in particular to CC...
It seems that while traversing struct page structures, we entered into a new
huge page (note that RBX is 0xffffea0001c00000 - just the beginning of
a huge page) and oopsed on PageBuddy test (_mapcount is at offset 0x18 in
struct page). It might be useful if you provide disassembly of
isolate_freepages_block() function in your kernel so that we can guess more
from other register contents...

								Honza

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

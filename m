Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab2KMXlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:41:07 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33372 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab2KMXlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:41:05 -0500
Date: Tue, 13 Nov 2012 15:41:02 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andy Lutomirski <luto@amacapital.net>
cc: Marc Duponcheel <marc@offline.be>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [3.6 regression?] THP + migration/compaction livelock (I
 think)
In-Reply-To: <CALCETrU=7+pk_rMKKuzgW1gafWfv6v7eQtVw3p8JryaTkyVQYQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1211131530020.17623@chino.kir.corp.google.com>
References: <CALCETrVgbx-8Ex1Q6YgEYv-Oxjoa1oprpsQE-Ww6iuwf7jFeGg@mail.gmail.com> <alpine.DEB.2.00.1211131507370.17623@chino.kir.corp.google.com> <CALCETrU=7+pk_rMKKuzgW1gafWfv6v7eQtVw3p8JryaTkyVQYQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012, Andy Lutomirski wrote:

> It just happened again.
> 
> $ grep -E "compact_|thp_" /proc/vmstat
> compact_blocks_moved 8332448774
> compact_pages_moved 21831286
> compact_pagemigrate_failed 211260
> compact_stall 13484
> compact_fail 6717
> compact_success 6755
> thp_fault_alloc 150665
> thp_fault_fallback 4270
> thp_collapse_alloc 19771
> thp_collapse_alloc_failed 2188
> thp_split 19600
> 

Two of the patches from the list provided at
http://marc.info/?l=linux-mm&m=135179005510688 are already in your 3.6.3 
kernel:

	mm: compaction: abort compaction loop if lock is contended or run too long
	mm: compaction: acquire the zone->lock as late as possible

and all have not made it to the 3.6 stable kernel yet, so would it be 
possible to try with 3.7-rc5 to see if it fixes the issue?  If so, it will 
indicate that the entire series is a candidate to backport to 3.6.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab2JKWIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 18:08:20 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44734 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab2JKWIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 18:08:17 -0400
Message-ID: <5077434D.7080008@suse.cz>
Date: Fri, 12 Oct 2012 00:08:13 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0a2
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Jiri Slaby <jirislaby@gmail.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: kswapd0: excessive CPU usage
References: <507688CC.9000104@suse.cz> <106695.1349963080@turing-police.cc.vt.edu> <5076E700.2030909@suse.cz> <118079.1349978211@turing-police.cc.vt.edu>            <50770905.5070904@suse.cz> <119175.1349979570@turing-police.cc.vt.edu>
In-Reply-To: <119175.1349979570@turing-police.cc.vt.edu>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2012 08:19 PM, Valdis.Kletnieks@vt.edu wrote:
> # zgrep COMPAC /proc/config.gz
> CONFIG_COMPACTION=y
> 
> Hope that tells you something useful.

It just supports my another theory. This seems to fix it for me:
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1830,8 +1830,8 @@ static inline bool should_continue_reclaim(struct
lruvec *lruvec,
         */
        pages_for_compaction = (2UL << sc->order);

-       pages_for_compaction = scale_for_compaction(pages_for_compaction,
-                                                   lruvec, sc);
+/*     pages_for_compaction = scale_for_compaction(pages_for_compaction,
+                                                   lruvec, sc);*/
        inactive_lru_pages = get_lru_size(lruvec, LRU_INACTIVE_FILE);
        if (nr_swap_pages > 0)
                inactive_lru_pages += get_lru_size(lruvec,
LRU_INACTIVE_ANON);

And for you?

(It's an effective revert of "mm: vmscan: scale number of pages
reclaimed by reclaim/compaction based on failures".)

regards,
-- 
js
suse labs

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab1HYFky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 01:40:54 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34872 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1HYFkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 01:40:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 25 Aug 2011 14:33:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org, konrad.wilk@oracle.com,
        JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, chris.mason@oracle.com, sjenning@linux.vnet.ibm.com,
        jackdachef@gmail.com, cyclonusj@gmail.com
Subject: Re: Subject: [PATCH V7 1/4] mm: frontswap: swap data structure
 changes
Message-Id: <20110825143312.a6fe93d5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110823145755.GA23174@ca-server1.us.oracle.com>
References: <20110823145755.GA23174@ca-server1.us.oracle.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011 07:57:55 -0700
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> From: Dan Magenheimer <dan.magenheimer@oracle.com>
> Subject: [PATCH V7 1/4] mm: frontswap: swap data structure changes
> 
> This first patch of four in the frontswap series makes available core
> swap data structures (swap_lock, swap_list and swap_info) that are
> needed by frontswap.c but we don't need to expose them to the dozens
> of files that include swap.h so we create a new swapfile.h just to
> extern-ify these.
> 
> Also add frontswap-related elements to swap_info_struct.  Frontswap_map
> points to vzalloc'ed one-bit-per-swap-page metadata that indicates
> whether the swap page is in frontswap or in the device and frontswap_pages
> counts how many pages are in frontswap.
> 
> [v7: rebase to 3.0-rc3]
> [v7: JBeulich@novell.com: add new swap struct elements only if config'd]
> [v6: rebase to 3.0-rc1]
> [v5: no change from v4]
> [v4: rebase to 2.6.39]
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> Reviewed-by: Konrad Wilk <konrad.wilk@oracle.com>
> Acked-by: Jan Beulich <JBeulich@novell.com>
> Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Chris Mason <chris.mason@oracle.com>
> Cc: Rik Riel <riel@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Hmm....could you modify mm/swapfile.c and remove 'static' in the same patch ?



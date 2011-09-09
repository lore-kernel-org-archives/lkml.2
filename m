Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab1IICPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 22:15:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43527 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab1IICPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 22:15:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 9 Sep 2011 11:14:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, jeremy@goop.org, hughd@google.com,
        ngupta@vflare.org, Konrad Wilk <konrad.wilk@oracle.com>,
        JBeulich@novell.com, Kurt Hackel <kurt.hackel@oracle.com>,
        npiggin@kernel.dk, riel@redhat.com, hannes@cmpxchg.org, matthew@wil.cx,
        Chris Mason <chris.mason@oracle.com>, sjenning@linux.vnet.ibm.com,
        jackdachef@gmail.com, cyclonusj@gmail.com, levinsasha928@gmail.com
Subject: Re: [PATCH V8 3/4] mm: frontswap: add swap hooks and extend
 try_to_unuse
Message-Id: <20110909111445.4821d326.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <52b5aee3-f424-42ae-830f-d1cf64fa49ef@default>
References: <20110829164929.GA27216@ca-server1.us.oracle.com
 20110907162703.7f8116b9.akpm@linux-foundation.org>
	<52b5aee3-f424-42ae-830f-d1cf64fa49ef@default>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Sep 2011 08:50:11 -0700 (PDT)
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> > From: Andrew Morton [mailto:akpm@linux-foundation.org]
> > Sent: Wednesday, September 07, 2011 5:27 PM
> > To: Dan Magenheimer
> > Subject: Re: [PATCH V8 3/4] mm: frontswap: add swap hooks and extend try_to_unuse
> > 
> > On Mon, 29 Aug 2011 09:49:29 -0700
> > Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> > 
> > > -static int try_to_unuse(unsigned int type)
> > > +int try_to_unuse(unsigned int type, bool frontswap,
> > 
> > Are patches 2 and 3 in the wrong order?
> 
> No, they've applied in that order and built after each patch
> properly for well over a year.  At a minimum, frontswap.h must
> be created before patch 3of4, though I suppose the introduction
> of frontswap.c could be after patch 3of4... Note that frontswap.c
> (which calls try_to_unuse()) is non-functional (and isn't even built)
> until after patch 4of4 is applied.
> 
> There is enough interdependency between the four parts
> that perhaps it should all be a single commit.  I split
> it up for reviewer's convenience but apparently different
> reviewers use different review processes than I anticipated. :-}
> 

IIRC, I said 'please move this change of line to patch 1'.

Thanks,
-Kame

This was my 1st reply.

> > From: Dan Magenheimer <dan.magenheimer@oracle.com>
> > Subject: [PATCH V7 1/4] mm: frontswap: swap data structure changes
> > 
> > This first patch of four in the frontswap series makes available core
> > swap data structures (swap_lock, swap_list and swap_info) that are
> > needed by frontswap.c but we don't need to expose them to the dozens
> > of files that include swap.h so we create a new swapfile.h just to
> > extern-ify these.
> > 
> > Also add frontswap-related elements to swap_info_struct.  Frontswap_map
> > points to vzalloc'ed one-bit-per-swap-page metadata that indicates
> > whether the swap page is in frontswap or in the device and frontswap_pages
> > counts how many pages are in frontswap.
> > 
> > [v7: rebase to 3.0-rc3]
> > [v7: JBeulich@novell.com: add new swap struct elements only if config'd]
> > [v6: rebase to 3.0-rc1]
> > [v5: no change from v4]
> > [v4: rebase to 2.6.39]
> > Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> > Reviewed-by: Konrad Wilk <konrad.wilk@oracle.com>
> > Acked-by: Jan Beulich <JBeulich@novell.com>
> > Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> > Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> > Cc: Hugh Dickins <hughd@google.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Nitin Gupta <ngupta@vflare.org>
> > Cc: Matthew Wilcox <matthew@wil.cx>
> > Cc: Chris Mason <chris.mason@oracle.com>
> > Cc: Rik Riel <riel@redhat.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> 
> Hmm....could you modify mm/swapfile.c and remove 'static' in the same patch ?
> 


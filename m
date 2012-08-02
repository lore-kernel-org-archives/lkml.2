Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406Ab2HBHTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 03:19:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44985 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab2HBHTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 03:19:37 -0400
Date: Thu, 2 Aug 2012 09:19:34 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Larry Woodman <lwoodman@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, Linux-MM <linux-mm@kvack.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Ken Chen <kenchen@google.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -alternative] mm: hugetlbfs: Close race during teardown
 of hugetlbfs shared page tables V2 (resend)
Message-ID: <20120802071934.GA7557@dhcp22.suse.cz>
References: <50120FA8.20409@redhat.com>
 <20120727102356.GD612@suse.de>
 <5016DC5F.7030604@redhat.com>
 <20120731124650.GO612@suse.de>
 <50181AA1.0@redhat.com>
 <20120731200650.GB19524@tiehlicka.suse.cz>
 <50189857.4000501@redhat.com>
 <20120801082036.GC4436@tiehlicka.suse.cz>
 <20120801123209.GK4436@tiehlicka.suse.cz>
 <501945F9.2030402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501945F9.2030402@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Larry,

On Wed 01-08-12 11:06:33, Larry Woodman wrote:
> On 08/01/2012 08:32 AM, Michal Hocko wrote:
> >
> >I am really lame :/. The previous patch is wrong as well for goto out
> >branch. The updated patch as follows:
> This patch worked fine Michal!  

Thanks for the good news!

> You and Mel can duke it out over who's is best. :)

The answer is clear here ;) Mel did the hard work of identifying the
culprit so kudos go to him.
I just tried to solve the issue more inside x86 arch code. The pmd
allocation outside of sharing code seemed strange to me for quite some
time I just underestimated its consequences completely.

Both approaches have some pros. Mel's patch is more resistant to other
not-yet-discovered races and it also makes the arch independent code
more robust because relying on the pmd trick is not ideal.
On the other hand, mine is more coupled with the sharing code so it
makes the code easier to follow and also makes the sharing more
effective because racing processes see pmd populated when checking for
shareable mappings.

So I am more inclined to mine but I don't want to push it because both
are good and make sense. What other people think?

> 
> Larry
> 

-- 
Michal Hocko
SUSE Labs

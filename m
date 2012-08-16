Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab2HPRZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 13:25:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38795 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333Ab2HPRZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 13:25:30 -0400
Date: Thu, 16 Aug 2012 19:25:27 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Will Deacon <will.deacon@arm.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: hugetlb: flush dcache before returning zeroed huge
 page to userspace
Message-ID: <20120816172527.GA12578@dhcp22.suse.cz>
References: <alpine.LSU.2.00.1207091622470.2261@eggly.anvils>
 <20120710094513.GB9108@mudshark.cambridge.arm.com>
 <20120710104234.GI9108@mudshark.cambridge.arm.com>
 <20120711174802.GG13498@mudshark.cambridge.arm.com>
 <20120712111659.GF21013@tiehlicka.suse.cz>
 <20120712112645.GG2816@mudshark.cambridge.arm.com>
 <20120712115708.GG21013@tiehlicka.suse.cz>
 <20120807160337.GC16877@mudshark.cambridge.arm.com>
 <20120808162607.GA7885@dhcp22.suse.cz>
 <20120816160954.GA4330@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816160954.GA4330@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 16-08-12 17:09:54, Will Deacon wrote:
> On Wed, Aug 08, 2012 at 05:26:07PM +0100, Michal Hocko wrote:
> > I guess the cleanest way is to hook into dequeue_huge_page_node and add
> > something like arch_clear_hugepage_flags.
> 
> I hooked into enqueue_huge_page instead, but how about something like this?:

Do you have any specific reason for that? enqueue_huge_page is called on
pages which potentially never get used so isn't that wasting a bit?
Not that it would be wrong I was just thinking why shouldn't we do it
when the page is actualy going to be used for sure.
-- 
Michal Hocko
SUSE Labs

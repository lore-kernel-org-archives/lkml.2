Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109Ab2HPSTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:19:48 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59783 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932153Ab2HPSTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:19:45 -0400
Date: Thu, 16 Aug 2012 19:19:31 +0100
From: Will Deacon <will.deacon@arm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: hugetlb: flush dcache before returning zeroed huge
 page to userspace
Message-ID: <20120816181931.GA19401@mudshark.cambridge.arm.com>
References: <20120711174802.GG13498@mudshark.cambridge.arm.com>
 <20120712111659.GF21013@tiehlicka.suse.cz>
 <20120712112645.GG2816@mudshark.cambridge.arm.com>
 <20120712115708.GG21013@tiehlicka.suse.cz>
 <20120807160337.GC16877@mudshark.cambridge.arm.com>
 <20120808162607.GA7885@dhcp22.suse.cz>
 <20120816160954.GA4330@mudshark.cambridge.arm.com>
 <20120816172527.GA12578@dhcp22.suse.cz>
 <20120816173459.GB7203@mudshark.cambridge.arm.com>
 <20120816180614.GB12578@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816180614.GB12578@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 07:06:14PM +0100, Michal Hocko wrote:
> On Thu 16-08-12 18:34:59, Will Deacon wrote:
> > I just did it that way to match the flag clearing for normal pages. I can
> > move it into dequeue if you think it's worthwhile but in the worst case it
> > just adds a clear_bit call, so I doubt it's measurable.
> 
> I do not have a strong opinion on that but the flags come in cleared when
> they are freshly allocated (gather_surplus_pages) so then it would be
> more appropriate in free_huge_page when enqueue_huge_page is called.

Makes sense, I'll move the call into free_huge_page.

Cheers,

Will

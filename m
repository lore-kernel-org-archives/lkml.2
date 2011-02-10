Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab1BJPCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 10:02:12 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:53670 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab1BJPCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 10:02:11 -0500
Subject: Re: [PATCH 5/5] have smaps show transparent huge pages
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>
In-Reply-To: <20110210112032.GG17873@csn.ul.ie>
References: <20110209195406.B9F23C9F@kernel>
	 <20110209195413.6D3CB37F@kernel>  <20110210112032.GG17873@csn.ul.ie>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Thu, 10 Feb 2011 07:01:55 -0800
Message-ID: <1297350115.6737.14208.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-10 at 11:20 +0000, Mel Gorman wrote:
> > @@ -394,6 +395,7 @@ static int smaps_pte_range(pmd_t *pmd, u
> >                       spin_lock(&walk->mm->page_table_lock);
> >               } else {
> >                       smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_SIZE, walk);
> > +                     mss->anonymous_thp += HPAGE_SIZE;
> 
> I should have thought of this for the previous patch but should this be
> HPAGE_PMD_SIZE instead of HPAGE_SIZE? Right now, they are the same value
> but they are not the same thing.

Probably.  There's also a nice BUG() in HPAGE_PMD_SIZE if the THP config
option is off, which is an added bonus.

-- Dave


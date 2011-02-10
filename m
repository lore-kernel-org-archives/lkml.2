Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab1BJSUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:20:39 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50164 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab1BJSUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:20:38 -0500
Subject: Re: [PATCH 5/5] have smaps show transparent huge pages
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael J Wolf <mjwolf@us.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>
In-Reply-To: <20110210180924.GB3347@random.random>
References: <20110209195406.B9F23C9F@kernel>
	 <20110209195413.6D3CB37F@kernel> <20110210112032.GG17873@csn.ul.ie>
	 <1297350115.6737.14208.camel@nimitz> <20110210150942.GL17873@csn.ul.ie>
	 <20110210180924.GB3347@random.random>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Thu, 10 Feb 2011 10:20:32 -0800
Message-ID: <1297362032.6737.14622.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-10 at 19:09 +0100, Andrea Arcangeli wrote:
> Maybe it'd be cleaner if we didn't need to cast the pmd to pte_t but I
> guess this makes things simpler. 

Yeah, I'm not a huge fan of doing that, either.  But, I'm not sure what
the alternatives are.  We could basically copy smaps_pte_entry() to
smaps_pmd_entry(), and then try to make pmd variants of all of the pte
functions and macros we call in there.

I know there's a least a bit of precedent in the hugetlbfs code for
doing things like this, but it's not a _great_ excuse. :)

-- Dave


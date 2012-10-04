Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab2JDUTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 16:19:21 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58785 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab2JDUTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 16:19:20 -0400
Date: Thu, 4 Oct 2012 16:19:08 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] mm: memcontrol: handle potential crash when rmap
 races with task exit
Message-ID: <20121004201908.GA2625@cmpxchg.org>
References: <1349374157-20604-1-git-send-email-hannes@cmpxchg.org>
 <1349374157-20604-2-git-send-email-hannes@cmpxchg.org>
 <20121004184958.GG27536@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004184958.GG27536@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 08:49:58PM +0200, Michal Hocko wrote:
> On Thu 04-10-12 14:09:16, Johannes Weiner wrote:
> > page_referenced() counts only references of mm's that are associated
> > with the memcg hierarchy that is being reclaimed.  However, if it
> > races with the owner of the mm exiting, mm->owner may be NULL.  Don't
> > crash, just ignore the reference.
> 
> This seems to be fixed by Hugh's patch 3a981f48 "memcg: fix use_hierarchy
> css_is_ancestor oops regression" which seems to be merged already.

And look who acked the patch.  I'll show myself out...

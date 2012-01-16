Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab2APMmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 07:42:49 -0500
Received: from static.213.204.9.176.clients.your-server.de ([176.9.204.213]:40800
	"EHLO shutemov.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab2APMms convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 07:42:48 -0500
Date: Mon, 16 Jan 2012 14:43:08 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcg: update the correct soft limit tree during
 migration
Message-ID: <20120116124308.GA25981@shutemov.name>
References: <1326469291-5642-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1326469291-5642-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 04:41:31PM +0100, Johannes Weiner wrote:
> end_migration() passes the old page instead of the new page to commit
> the charge.  This page descriptor is not used for committing itself,
> though, since we also pass the (correct) page_cgroup descriptor.  But
> it's used to find the soft limit tree through the page's zone, so the
> soft limit tree of the old page's zone is updated instead of that of
> the new page's, which might get slightly out of date until the next
> charge reaches the ratelimit point.
> 
> This glitch has been present since '5564e88 memcg: condense
> page_cgroup-to-page lookup points'.
> 
> Reported-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Kirill A. Shutemov <kirill@shutemov.name>


-- 
 Kirill A. Shutemov

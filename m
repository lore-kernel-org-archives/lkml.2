Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab1FMOzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 10:55:04 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50444 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab1FMOy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 10:54:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FRWprrYheDXoYwIOPbaZtI1SczSsTto0w4DawarpojjOY9oxRnJpQt0G7sQMXEGWQr
         1F3VP5Z0ZbWy+Gj7jRGNlM23csKB3Do4tje1bNdpE9Iei8EiWjKOOTbxrlZEm+rMM7l1
         kix9NYC8rYLdwqmJFEgQk6tUe6WK7JKCapSmI=
Date: Mon, 13 Jun 2011 23:54:43 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v3 03/10] Add additional isolation mode
Message-ID: <20110613145443.GB1414@barrios-desktop>
References: <cover.1307455422.git.minchan.kim@gmail.com>
 <b72a86ed33c693aeccac0dba3fba8c13145106ab.1307455422.git.minchan.kim@gmail.com>
 <20110612144521.GB24323@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110612144521.GB24323@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 12, 2011 at 04:45:21PM +0200, Michal Hocko wrote:
> On Tue 07-06-11 23:38:16, Minchan Kim wrote:
> > There are some places to isolate lru page and I believe
> > users of isolate_lru_page will be growing.
> > The purpose of them is each different so part of isolated pages
> > should put back to LRU, again.
> > 
> > The problem is when we put back the page into LRU,
> > we lose LRU ordering and the page is inserted at head of LRU list.
> > It makes unnecessary LRU churning so that vm can evict working set pages
> > rather than idle pages.
> 
> I guess that, although this is true, it doesn't fit in with this patch
> very much because this patch doesn't fix this problem. It is a
> preparation for for further work. I would expect this description with
> the core patch that actlually handles this issue.

Okay.

> 
> > 
> > This patch adds new modes when we isolate page in LRU so we don't isolate pages
> > if we can't handle it. It could reduce LRU churning.
> > 
> > This patch doesn't change old behavior. It's just used by next patches.
> 
> It doesn't because there is not user of those flags but maybe it would
> be better to have those to see why it actually can reduce LRU
> isolations.

Yes. Mel already pointed it out.
I will merge patches in next version.
And I have a idea to reduce lru_lock Mel mentiond
So maybe I will include it in next version, too.
But, now I have no time to revise it :(

-- 
Kind regards,
Minchan Kim

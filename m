Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab1FIJbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:31:48 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33795
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751147Ab1FIJbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:31:46 -0400
Date: Thu, 9 Jun 2011 05:31:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] mm: memcg naturalization -rc2
Message-ID: <20110609093129.GA17072@infradead.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
 <BANLkTikgqSsg5+49295h7kdZ=sQpZLs4kw@mail.gmail.com>
 <20110602073335.GA20630@cmpxchg.org>
 <BANLkTikztP6RoyBgMqUHgrzJFLZrHMCs=Q@mail.gmail.com>
 <20110602100007.GB20725@cmpxchg.org>
 <BANLkTi=xvunhqpXFJ=wJFkCuu+7Czh4nZw@mail.gmail.com>
 <4DF01EC2.8010105@redhat.com>
 <20110609084300.GD11603@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609084300.GD11603@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 10:43:00AM +0200, Johannes Weiner wrote:
> I think it's much more natural to do it that way, but it's not a
> requirement as such.  We could just keep the extra soft limit reclaim
> invocation in kswapd that looks for the biggest offender and the
> hierarchy below it, then does a direct call to do_shrink_zone() to
> bypass the generic hierarchy walk.
> 
> It's not very nice to have that kind of code duplication, but it's
> possible to leave it like that for now.

Unless there is a really good reason please kill it.  It just means more
codepathes that eat away tons of stack in the reclaim path, and we
already have far too much of those, and more code that needs fixing for
all the reclaim issues we have.  Nevermind that the cgroups code
generally gets a lot less testing, so the QA overhead is also much
worse.

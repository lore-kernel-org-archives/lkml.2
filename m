Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab3ACXqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 18:46:01 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:52949 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776Ab3ACXp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 18:45:59 -0500
Date: Thu, 3 Jan 2013 23:45:58 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ppoll() stuck on POLLIN while TCP peer is sending
Message-ID: <20130103234558.GA1689@dcvr.yhbt.net>
References: <20121228014503.GA5017@dcvr.yhbt.net>
 <20130102200848.GA4500@dcvr.yhbt.net>
 <20130102204712.GA17806@dcvr.yhbt.net>
 <1357220469.21409.24574.camel@edumazet-glaptop>
 <20130103183251.GA10113@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130103183251.GA10113@dcvr.yhbt.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Wong <normalperson@yhbt.net> wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > With the following patch, I cant reproduce the 'apparent stuck'
> 
> Right, the output is just an approximation and the logic there
> was bogus.
> 
> Thanks for looking at this.

I'm still able to reproduce the issue under v3.8-rc2 with your patch
for toosleepy.

(As expected when blocked,) TCP send() will eventually return
ETIMEOUT when I forget to check (and toosleepy will abort from it)

I think this requires frequent dirtying/cycling of pages to reproduce.
(from copying large files around) to interact with compaction.
I'll see if I can reproduce the issue with read-only FS activity.

With 3.7.1 and compaction/THP disabled, I was able to run ~21 hours
and copy a few TB around without anything getting stuck.

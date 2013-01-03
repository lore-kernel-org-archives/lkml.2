Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab3ACScy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 13:32:54 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:51294 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab3ACScw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 13:32:52 -0500
Date: Thu, 3 Jan 2013 18:32:51 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ppoll() stuck on POLLIN while TCP peer is sending
Message-ID: <20130103183251.GA10113@dcvr.yhbt.net>
References: <20121228014503.GA5017@dcvr.yhbt.net>
 <20130102200848.GA4500@dcvr.yhbt.net>
 <20130102204712.GA17806@dcvr.yhbt.net>
 <1357220469.21409.24574.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357220469.21409.24574.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Wed, 2013-01-02 at 20:47 +0000, Eric Wong wrote:
> > Eric Wong <normalperson@yhbt.net> wrote:
> > > [1] my full setup is very strange.
> > > 
> > >     Other than the FUSE component I forgot to mention, little depends on
> > >     the kernel.  With all this, the standalone toosleepy can get stuck.
> > >     I'll try to reproduce it with less...
> > 
> > I just confirmed my toosleepy processes will get stuck while just
> > doing "rsync -a" between local disks.  So this does not depend on
> > sendfile or FUSE to reproduce.
> > --
> 
> How do you tell your 'toosleepy' is stuck ?

My original post showed it stuck with strace (in ppoll + send).
I only strace after seeing it's not using any CPU in top.

http://mid.gmane.org/20121228014503.GA5017@dcvr.yhbt.net
(lsof also confirmed the ppoll/send sockets were peers)

> If reading its output, you should change its logic, there is no
> guarantee the recv() will deliver exactly 16384 bytes each round.
> 
> With the following patch, I cant reproduce the 'apparent stuck'

Right, the output is just an approximation and the logic there
was bogus.

Thanks for looking at this.

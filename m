Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097Ab0GVI7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 04:59:39 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:27422 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759069Ab0GVI7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 04:59:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAG+lR0x5Lc6U/2dsb2JhbACfdXLAZIU2BA
Date: Thu, 22 Jul 2010 18:59:32 +1000
From: Nick Piggin <npiggin@suse.de>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>, Kristo Tero Tapani <tero.kristo@nokia.com>,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 11/11] writeback: prevent unnecessary bdi threads
 wakeups
Message-ID: <20100722085932.GA1254@amd>
References: <1279704706-1267-1-git-send-email-dedekind1@gmail.com>
 <1279704706-1267-12-git-send-email-dedekind1@gmail.com>
 <20100722031922.GA3446@amd>
 <1279781304.3044.12.camel@localhost>
 <20100722080511.GA9377@amd>
 <1279785739.3044.33.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279785739.3044.33.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 11:02:19AM +0300, Artem Bityutskiy wrote:
> On Thu, 2010-07-22 at 18:05 +1000, Nick Piggin wrote:
> > I can see what you mean, but I think the designs in core code should
> > be made as efficient as possible _unless_ there is some complication
> > in doing otherwise (not the other way around).
> > 
> > This is producing 2 unrequired context switches, so I really would
> > like to see it done properly. Setting up a timer is really pretty
> > simple (or if you would care to implement a delayed process wakeup
> > API, I think that would be useful -- I'm surprised there isn't one
> > already).
> 
> OK, NP, I'll work on this.

Thanks.

 
> The only problem I see is that it will involve more maintainers and
> trees (I guess Ingo?), and make it even more difficult for me to reach
> upstream :-) But let's try and see!

I wouldn't worry about that. It's so simple that if you end up coding
the helper function to do a timer delayed wakeup, just send it to Jens
in your series, cc Ingo on it if you'd like.


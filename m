Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab1FLLdY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 07:33:24 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:49329 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751692Ab1FLLdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 07:33:22 -0400
Date: Sun, 12 Jun 2011 13:33:19 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Make GFP_DMA allocations w/o ZONE_DMA emit a warning
	instead of failing
Message-ID: <20110612113319.GB13048@atrey.karlin.mff.cuni.cz>
References: <1306922672-9012-1-git-send-email-dbaryshkov@gmail.com> <BANLkTinBkdVd90g3-uiQP41z1S1sXUdRmQ@mail.gmail.com> <20110602214655.GA2916@localhost.ucw.cz> <201106121307.20631.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106121307.20631.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > > > Please be more polite to other people. After a197b59ae6 all allocations
> > > > with GFP_DMA set on nodes without ZONE_DMA fail nearly silently (only
> > > > one warning during bootup is emited, no matter how many things fail).
> > > > This is a very crude change on behaviour. To be more civil, instead of
> > > > failing emit noisy warnings each time smbd. tries to allocate a GFP_DMA
> > > > memory on non-ZONE_DMA node.
> > > >
> > > > This change should be reverted after one or two major releases, but
> > > > we should be more accurate rather than hoping for the best.
> > > 
> > > Instaed of, shouldn't we revert a197b59ae6? Some arch don't have
> > > DMA_ZONE at all.
> > > and a197b59ae6 only care x86 embedded case. If we accept your patch, I
> > > can imagine
> > > other people will claim warn foold is a bug. ;)
> > 
> > I believe we should revert. It broke zaurus boot for metan...
> 
> Is it still a problem, or has it been fixed in the meantime?
> 

This was revered in 3.0-rc2.

-- 
metan

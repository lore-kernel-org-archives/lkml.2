Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab0JTCfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 22:35:44 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40000 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab0JTCfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 22:35:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [resend][PATCH 2/2] mm, mem-hotplug: update pcp->stat_threshold when memory hotplug occur
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20101019192229.bae83d9d.akpm@linux-foundation.org>
References: <20101020110132.1815.A69D9226@jp.fujitsu.com> <20101019192229.bae83d9d.akpm@linux-foundation.org>
Message-Id: <20101020113500.181B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 20 Oct 2010 11:35:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 20 Oct 2010 11:07:33 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > > > @@ -5013,6 +5014,8 @@ int __meminit init_per_zone_wmark_min(void)
> > > > >  		min_free_kbytes = 128;
> > > > >  	if (min_free_kbytes > 65536)
> > > > >  		min_free_kbytes = 65536;
> > > > > +
> > > > > +	refresh_zone_stat_thresholds();
> > > > >  	setup_per_zone_wmarks();
> > > > >  	setup_per_zone_lowmem_reserve();
> > > > >  	setup_per_zone_inactive_ratio();
> > > > 
> > > > setup_per_zone_wmarks() could change the min and low watermarks for a zone 
> > > > when refresh_zone_stat_thresholds() would have used the old value.
> > > 
> > > Indeed.
> > > 
> > > I could make the obvious fix, but then what I'd have wouldn't be
> > > sufficiently tested.
> > 
> > Can we review this?
> 
> It's unclear what you mean?
> 
> The patches otherwise look OK to me, but it's pretty easy to make
> mistakes in this area.

Ah, I misunderstood. I thought you have perfectly different approach patch.
I'll respin.

Thanks.




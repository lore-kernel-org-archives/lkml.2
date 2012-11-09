Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab2KIJGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 04:06:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab2KIJGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 04:06:39 -0500
Date: Fri, 9 Nov 2012 09:06:35 +0000
From: Mel Gorman <mgorman@suse.de>
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, Jiri Slaby <jslaby@suse.cz>,
        Valdis.Kletnieks@vt.edu, Jiri Slaby <jirislaby@gmail.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: kswapd0: excessive CPU usage
Message-ID: <20121109090635.GG8218@suse.de>
References: <5077434D.7080008@suse.cz>
 <50780F26.7070007@suse.cz>
 <20121012135726.GY29125@suse.de>
 <507BDD45.1070705@suse.cz>
 <20121015110937.GE29125@suse.de>
 <5093A3F4.8090108@redhat.com>
 <5093A631.5020209@suse.cz>
 <509422C3.1000803@suse.cz>
 <509C84ED.8090605@linux.vnet.ibm.com>
 <509CB9D1.6060704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <509CB9D1.6060704@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 09:07:45AM +0100, Zdenek Kabelac wrote:
> >fe2c2a106663130a5ab45cb0e3414b52df2fff0c is the first bad commit
> >commit fe2c2a106663130a5ab45cb0e3414b52df2fff0c
> >Author: Rik van Riel <riel@redhat.com>
> >Date:   Wed Mar 21 16:33:51 2012 -0700
> >
> >     vmscan: reclaim at order 0 when compaction is enabled
> >...
> >
> >This is plausible since the issue seems to be in the kswapd + compaction
> >realm.  I've yet to figure out exactly what about this commit results in
> >kswapd spinning.
> >
> >I would be interested if someone can confirm this finding.
> >
> >--
> >Seth
> >
> 
> 
> On my system 3.7-rc4 the problem seems to be effectively solved by
> revert patch: https://lkml.org/lkml/2012/11/5/308
> 

Ok, while there is still a question on whether it's enough I think it's
sensible to at least start with the obvious one.

Thanks very much.

-- 
Mel Gorman
SUSE Labs

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab2J2JAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 05:00:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758163Ab2J2JAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 05:00:08 -0400
Date: Mon, 29 Oct 2012 09:59:59 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add some drop_caches documentation and info messsge
In-Reply-To: <20121024181752.de011615.akpm@linux-foundation.org>
Message-ID: <alpine.LRH.2.00.1210290958450.10392@twin.jikos.cz>
References: <20121012125708.GJ10110@dhcp22.suse.cz> <20121024210600.GA17037@liondog.tnic> <20121024141303.0797d6a1.akpm@linux-foundation.org> <1787395.7AzIesGUbB@vostro.rjw.lan> <20121024181752.de011615.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012, Andrew Morton wrote:

> > > > I have drop_caches in my suspend-to-disk script so that the hibernation
> > > > image is kept at minimum and suspend times are as small as possible.
> > > 
> > > hm, that sounds smart.
> > > 
> > > > Would that be a valid use-case?
> > > 
> > > I'd say so, unless we change the kernel to do that internally.  We do
> > > have the hibernation-specific shrink_all_memory() in the vmscan code. 
> > > We didn't see fit to document _why_ that exists, but IIRC it's there to
> > > create enough free memory for hibernation to be able to successfully
> > > complete, but no more.
> > 
> > That's correct.
> 
> Well, my point was: how about the idea of reclaiming clean pagecache
> (and inodes, dentries, etc) before hibernation so we read/write less
> disk data?

You might or might not want to do that. Dropping caches around suspend 
makes the hibernation process itself faster, but the realtime response of 
the applications afterwards is worse, as everything touched by user has to 
be paged in again.

-- 
Jiri Kosina
SUSE Labs


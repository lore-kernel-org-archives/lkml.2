Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab1CBFXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 00:23:24 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49199 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1CBFXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 00:23:24 -0500
Date: Tue, 1 Mar 2011 23:23:20 -0600
From: Shaun Ruffell <sruffell@sruffell.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russ Meyerriecks <rmeyerriecks@digium.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] mm/dmapool.c: Do not create/destroy sysfs file while
	holding pools_lock
Message-ID: <20110302052320.GB7463@kilby.digium.internal>
References: <20110228224124.GA31769@blackmagic.digium.internal> <20110301170117.258e06e2.akpm@linux-foundation.org> <m1wrki3zrq.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wrki3zrq.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 08:35:53PM -0800, Eric W. Biederman wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> > One way of fixing this would be to create another singleton lock:
> >
> >
> > 	{
> > 		static DEFINE_MUTEX(pools_sysfs_lock);
> > 		static bool pools_sysfs_done;
> >
> > 		mutex_lock(&pools_sysfs_lock);
> > 		if (pools_sysfs_done == false) {
> > 			create_sysfs_stuff();
> > 			pools_sysfs_done = true;
> > 		}
> > 		mutex_unlock(&pools_sysfs_lock);
> > 	}
> >
> > That's not terribly pretty.
> 
> Or possibly use module_init style magic.  Where use module
> initialization and remove to trigger creation and deletion of the sysfs.
> 

I'm not following how module initialization can help here. Are you suggesting
that all devices get a 'pools' attribute regardless of whether any dma pools
are actually created?

Shaun

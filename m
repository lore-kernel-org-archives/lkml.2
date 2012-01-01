Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab2AALpq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 06:45:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab2AALpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 06:45:25 -0500
Date: Sun, 1 Jan 2012 13:47:27 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v6 09/11] virtio: net: Add freeze, restore handlers to
 support S4
Message-ID: <20120101114727.GC25350@redhat.com>
References: <cover.1324553223.git.amit.shah@redhat.com>
 <f84fa9fdc9f5629e711cbb89a2e7efbb289d72fa.1324553223.git.amit.shah@redhat.com>
 <20111229161523.GB2300@redhat.com>
 <20111230085205.GG4576@amit.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111230085205.GG4576@amit.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 30, 2011 at 03:08:19PM +0530, Amit Shah wrote:
> > 
> > > +	if (!try_fill_recv(vi, GFP_KERNEL))
> > > +		schedule_delayed_work(&vi->refill, 0);
> > 
> > This needs to be switched to non reentrant wq too?
> 
> Subsequent invocations could create problems?  Note that this will be
> the first item to be queued in the workqueue for the refill work.
> 
> 		Amit

See recent patches on net-next.
We switched other calls to a non reentrant wq so I think same
reasoning applies there.

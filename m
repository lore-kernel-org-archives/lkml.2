Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab1BOMm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 07:42:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab1BOMm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 07:42:56 -0500
Date: Tue, 15 Feb 2011 13:42:55 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio: use __GFP_NOWARN for try_fill_recv in
 virtnet_poll
Message-ID: <20110215124255.GF8341@tiehlicka.suse.cz>
References: <20110215093527.GB8341@tiehlicka.suse.cz>
 <201102152041.29179.rusty@rustcorp.com.au>
 <20110215102549.GD8341@tiehlicka.suse.cz>
 <201102152139.03451.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102152139.03451.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 15-02-11 21:39:03, Rusty Russell wrote:
> On Tue, 15 Feb 2011 08:55:50 pm Michal Hocko wrote:
> > On Tue 15-02-11 20:41:29, Rusty Russell wrote:
> > > On Tue, 15 Feb 2011 08:05:27 pm Michal Hocko wrote:
> > > > Hi,
> > > > we have started seeing a lot of allocator messages complaining about
> > > > failed allocations from virtnet_poll in soft IRQ. Could you consider the
> > > > following patch, please?
> > > 
> > > Do we really want to silence this?  Isn't warning about it kind of the
> > > point?  Your network is probably sucking if this happens...
> > 
> > What can user do about it? Is the low level memory allocator message
> > very much usefull for him?  Maybe we can add a printk_once in the fail
> > path with some more useful and virtio specific message.
> 
> That's an argument against ever printing any message.

Well, honestly, I do not see much point for this message but it is there
for ages so it maybe it is valueable for somebody...

> 
> What we need to know is why does this happen with virtio_net and not other
> cards?  

The machine just happened to be short on memory due to a strong memory
pressure.

> If it happens to them too, and they silently fall back, all good.
> 
> I want to make sure we're not papering over a real problem...
> 
> Thanks,
> Rusty.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

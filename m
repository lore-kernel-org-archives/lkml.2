Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab0IXM5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 08:57:22 -0400
Received: from spaceboyz.net ([87.106.131.203]:37030 "EHLO spaceboyz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab0IXM5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 08:57:21 -0400
Date: Fri, 24 Sep 2010 14:57:04 +0200
From: David Lamparter <equinox@diac24.net>
To: jamal <hadi@cyberus.ca>
Cc: David Lamparter <equinox@diac24.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 7/8] net: Allow setting the network namespace by fd
Message-ID: <20100924125704.GA1551619@jupiter.n2.diac24.net>
References: <m1ocborgq7.fsf@fess.ebiederm.org>
 <m1hbhgq1v1.fsf@fess.ebiederm.org>
 <1285240926.5036.7.camel@bigi>
 <20100923145856.GB1160234@jupiter.n2.diac24.net>
 <1285329084.13976.661.camel@bigi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285329084.13976.661.camel@bigi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 07:51:24AM -0400, jamal wrote:
> > migrating route table entries makes no sense because
> > a) they refer to devices and configuration that does not exist in the
> >    target namespace; they only make sense within their netns context
> > b) they are purely virtual and you get the same result from deleting and
> >    recreating them.
> > 
> > Network devices are special because they may have something attached to
> > them, be it hardware or some daemon.
> 
> Routes functionally reside on top of netdevices, point to nexthop
> neighbors across these netdevices etc. Underlying assumption is you take
> care of that dependency when migrating.
> We are talking about FIB entries here not the route cache; moving a few
> pointers within the kernel is a hell lot faster than recreating a subset
> of BGP entries from user space. 

No. While you sure could associate routes with devices, they don't
*functionally* reside on top of network devices. They reside on top of
the entire IP configuration, and in case of BGP they even reside on top
of your set of peerings and their data.

Even if you could "move" routes together with a network device, the
result would be utter nonsense. The routes depend on your BGP view, and
if your set of interfaces (and peers) changes, your routes will change.
Your bgpd will, either way, need to set up new peerings and redo best
path evaluations.

(On an unrelated note, how often are you planning to move stuff between
namespaces? I don't expect to be moving stuff except on configuration
events...)


-David


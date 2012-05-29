Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab2E2CIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 22:08:21 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:10620 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751885Ab2E2CIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 22:08:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak0JAKIuxE95LJr7/2dsb2JhbABEtDMEgSSBCIIXAQEFOhwjEAgDDgouFCUDIROICrgjFIpvT4QCYAOVFokfhlOCcg
Date: Tue, 29 May 2012 12:08:15 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tejun Heo <tj@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
        Kent Overstreet <koverstreet@google.com>,
        Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, yehuda@hq.newdream.net,
        vgoyal@redhat.com, bharrosh@panasas.com, sage@newdream.net,
        drbd-dev@lists.linbit.com, Dave Chinner <dchinner@redhat.com>,
        tytso@google.com, "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 14/16] Gut bio_add_page()
Message-ID: <20120529020815.GB5091@dastard>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
 <1337977539-16977-15-git-send-email-koverstreet@google.com>
 <20120525204651.GA24246@redhat.com>
 <20120525210944.GB14196@google.com>
 <20120525223937.GF5761@agk-dp.fab.redhat.com>
 <Pine.LNX.4.64.1205281129180.2227@file.rdu.redhat.com>
 <20120528202839.GA18537@dhcp-172-17-108-109.mtv.corp.google.com>
 <Pine.LNX.4.64.1205281659580.11763@file.rdu.redhat.com>
 <20120528213839.GB18537@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120528230208.GA20954@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120528230208.GA20954@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 08:02:08AM +0900, Tejun Heo wrote:
> (cc'ing Martin K. Petersen, hi!)
> 
> On Tue, May 29, 2012 at 06:38:39AM +0900, Tejun Heo wrote:
> > > With this patchset, you don't have to expose all the limits. You can 
> > > expose just a few most useful limits to avoid bio split in the cases 
> > > described above.
> > 
> > Yeah, if that actually helps, sure.  From what I read, dm is already
> > (ab)using merge_bvec_fn() like that anyway.
> 
> i thought a bit more about it and the only thing which makes sense to
> me is exposing the stripe granularity for striped devices -
> ie. something which says "if you go across this boundary, the
> performance characteristics including latency might get affected",
> which should fit nicely with the rest of topology information.
> Martin, adding that shouldn't be difficult, right?

We already have the optimal IO size/alignment field in the topology.
Doesn't this fit what you want exactly?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab2E2Dgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 23:36:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49334 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab2E2Dgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 23:36:32 -0400
Date: Mon, 28 May 2012 23:36:28 -0400
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Mikulas Patocka <mpatocka@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        yehuda@hq.newdream.net, vgoyal@redhat.com, bharrosh@panasas.com,
        sage@newdream.net, drbd-dev@lists.linbit.com,
        Dave Chinner <dchinner@redhat.com>, tytso@google.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 14/16] Gut bio_add_page()
Message-ID: <20120529033628.GD10175@dhcp-172-18-216-138.mtv.corp.google.com>
References: <20120525204651.GA24246@redhat.com>
 <20120525210944.GB14196@google.com>
 <20120525223937.GF5761@agk-dp.fab.redhat.com>
 <Pine.LNX.4.64.1205281129180.2227@file.rdu.redhat.com>
 <20120528202839.GA18537@dhcp-172-17-108-109.mtv.corp.google.com>
 <Pine.LNX.4.64.1205281659580.11763@file.rdu.redhat.com>
 <20120528213839.GB18537@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120528230208.GA20954@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120529020815.GB5091@dastard>
 <20120529021558.GG20954@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120529021558.GG20954@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 11:15:58AM +0900, Tejun Heo wrote:
> Hello,
> 
> On Tue, May 29, 2012 at 12:08:15PM +1000, Dave Chinner wrote:
> > > i thought a bit more about it and the only thing which makes sense to
> > > me is exposing the stripe granularity for striped devices -
> > > ie. something which says "if you go across this boundary, the
> > > performance characteristics including latency might get affected",
> > > which should fit nicely with the rest of topology information.
> > > Martin, adding that shouldn't be difficult, right?
> > 
> > We already have the optimal IO size/alignment field in the topology.
> > Doesn't this fit what you want exactly?
> 
> I don't know how xfs/ext4 is currently benefiting from
> merge_bvec_fn(), so I'm unsure.  If the existing ones are enough,
> great.

Excepting readahead I don't think they are at all.

For readahead all we need is a hint - call it "atomic IO size" or
something. Assuming one of the gazillion things in queue_limits doesn't
already mean that anyways.

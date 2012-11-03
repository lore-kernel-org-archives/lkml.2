Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762208Ab2KCAXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 20:23:34 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35265 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab2KCAXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 20:23:33 -0400
Date: Fri, 2 Nov 2012 17:23:28 -0700
From: Tejun Heo <tj@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Kay Sievers <kay@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
Message-ID: <20121103002328.GI27843@mtj.dyndns.org>
References: <20121102164828.GA3823@mtj.dyndns.org>
 <20121102172145.184abfe3@pyramind.ukuu.org.uk>
 <20121102173022.GA27843@mtj.dyndns.org>
 <20121102201824.41b2516d@pyramind.ukuu.org.uk>
 <20121102202131.GE9169@htj.dyndns.org>
 <20121102204825.7e4bd641@pyramind.ukuu.org.uk>
 <20121102225912.GD27843@mtj.dyndns.org>
 <20121102235243.60dfa772@pyramind.ukuu.org.uk>
 <20121102235811.GG27843@mtj.dyndns.org>
 <20121103001905.6f894267@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121103001905.6f894267@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Nov 03, 2012 at 12:19:05AM +0000, Alan Cox wrote:
> > Hmmm?  You know which commands you're allowing.  You can definitely
> > filter those commands for their ranges.  What ioctls?
> 
> How do you know what the rules are in kernel. If I'm locking you to fixed
> mappings you have no idea in kernel what my user policy model is.

So, my first response was whether you mean to add arbitrary range
filtering for standard read/writes too.  If you're not gonna do that
and use the existing partition based access model, it's natural to
apply the same partition ranges to the allowed SG_IO commands, right?
There's no new access model which should be configured here.  It just
applied the same block device access model to SG_IO commands too.

> > > So that translates to me as "There is a good reason, but if your drive is
> > > one of the awkward ones then f**k you go use root". Again policy in the
> > > kernel just creates inflexibility and is the wrong place for it.
> > 
> > Yes, pretty much. 
> 
> Unfortunate and guaranteed to end up with problems not getting fixed
> again - or having to redo the work a second time later on. Plus this is
> but one example and you are blocking all the ones that haven't been
> considered.

But we should't add features for the ones which haven't been
considered.  Unless you can actually justify with actual use cases,
it's just hand waving.

> > > If you are doing virtual machines it is far from marginal.
> > 
> > Yeah, I agree VMs are the only one which isn't marginal, but then
> > again, VMs can work reasonably well with far simpler mechanism.
> 
> I'm dying to see your "simpler mechanism" - I bet by the time you've
> written the code it isn't simpler than calling the existing BPF logic.
> Your kernel already has all the BPF stuff in it unless you are building
> with no networking support so its essentially free.

The suggested mechanism is just having a switch to allow all SG_IO
commands and pass it to the hypervisor.  There's no filtering in
kernel at all.

> We have filtering because it is necessary. All you are doing is putting
> off the inevitable by adding more kernel hack "one true kernel enforced
> religion" policy and putting off the inevitable while adding APIs you'll
> then have to maintain until the job is done right.
> 
> Ultimately policy has to be user space driven, adding more temporary
> hacks is just a waste.

Exactly, let's provide a turn-off switch for in-kernel filtering and
let userland drive any appropriate access policy on it.  Let's please
stay away from doing deep packet inspecting on SG_IO commands.

I don't think we're disagreeing on the principle.  It's just that
we're drawing different where the line lies between mechanisms and
policies.

Thanks.

-- 
tejun

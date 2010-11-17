Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902Ab0KQPne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:43:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:50494 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab0KQPnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:43:33 -0500
Message-ID: <4CE3F773.2010303@kernel.org>
Date: Wed, 17 Nov 2010 16:40:35 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dan Smith <danms@us.ibm.com>
CC: Gene Cooperman <gene@ccs.neu.edu>, Oren Laadan <orenl@cs.columbia.edu>,
        Kapil Arya <kapil@ccs.neu.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com>	<4CD26948.7050009@kernel.org>	<20101104164401.GC10656@sundance.ccs.neu.edu>	<4CD3CE29.2010105@kernel.org>	<AANLkTimDXKsBCxbsEOfgkYV2R8FK=bhFdmx9UQow5hqp@mail.gmail.com>	<4CD5DCE3.3000109@cs.columbia.edu>	<20101107194222.GG31077@sundance.ccs.neu.edu>	<4CD71A6B.3020905@cs.columbia.edu>	<20101107230516.GJ31077@sundance.ccs.neu.edu>	<4CD774CA.8030004@cs.columbia.edu>	<20101108162630.GN31077@sundance.ccs.neu.edu>	<8739rbpreb.fsf@localhost6.localdomain6> <4CE3B927.1020401@kernel.org> <8762vwvubr.fsf@localhost6.localdomain6>
In-Reply-To: <8762vwvubr.fsf@localhost6.localdomain6>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Nov 2010 15:40:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/17/2010 04:33 PM, Dan Smith wrote:
> TH> If it ever becomes a general enough problem (which I extremely
> TH> strongly doubt),
> 
> Migration of a container?  Yeah, it's one of the primary reasons for
> doing what we're doing :)

Well, then push for the feature.  If the rationale is strong enough,
it'll get in.

> TH> we can think about allowing processes in a netns to change
> TH> sequence number but that would be a single setsockopt option
> 
> Yeah, well there's more than that, of course, if you want to be able
> to checkpoint a socket in any state.  Buffers, time-wait, etc.

I haven't really thought about it too deeply but for all other misc
states, you should be able to emulate it by talking to a netfilter
module.  The reason why I suggested sequence number changing setsocket
option is because that is the only performance sensitive part and with
that you should be able to resume live sockets without conntracking.
For cold paths, using netfilter module during resume should do, right?

> TH> instead of the horror show of dumping in-kernel data structures in
> TH> binary blob.
> 
> Well, as should be evident from a review of the code, we don't dump
> binary kernel data structures as a general rule.  We canonicalize them
> into checkpoint headers on the way out and build the new data
> structures (or use existing kernel interfaces to do so) on the way in.
> You know, just like netlink does.

netlink interaction is defined by ABI.

> It has even been suggested that we do this with netlink instead, to
> mirror the other "horror show" tools that we all use on a daily basis.
> We're not opposed to this, but we do have some concerns about
> performance.

The horror show part is dumping internal data structure without due
scrutinization in a way which can only ever be useful for CR when most
of the same states are already exported via ABI defined ways.

Thanks.

-- 
tejun

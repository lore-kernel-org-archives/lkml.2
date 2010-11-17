Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab0KQPdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:33:16 -0500
Received: from gw0.danplanet.com ([71.245.107.82]:34087 "EHLO
	mail.danplanet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753432Ab0KQPdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:33:15 -0500
To: Tejun Heo <tj@kernel.org>
Cc: Gene Cooperman <gene@ccs.neu.edu>, Oren Laadan <orenl@cs.columbia.edu>,
        Kapil Arya <kapil@ccs.neu.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com>
	<4CD26948.7050009@kernel.org>
	<20101104164401.GC10656@sundance.ccs.neu.edu>
	<4CD3CE29.2010105@kernel.org>
	<AANLkTimDXKsBCxbsEOfgkYV2R8FK=bhFdmx9UQow5hqp@mail.gmail.com>
	<4CD5DCE3.3000109@cs.columbia.edu>
	<20101107194222.GG31077@sundance.ccs.neu.edu>
	<4CD71A6B.3020905@cs.columbia.edu>
	<20101107230516.GJ31077@sundance.ccs.neu.edu>
	<4CD774CA.8030004@cs.columbia.edu>
	<20101108162630.GN31077@sundance.ccs.neu.edu>
	<8739rbpreb.fsf@localhost6.localdomain6> <4CE3B927.1020401@kernel.org>
From: Dan Smith <danms@us.ibm.com>
Date: Wed, 17 Nov 2010 07:33:12 -0800
Message-ID: <8762vwvubr.fsf@localhost6.localdomain6>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TH> If it ever becomes a general enough problem (which I extremely
TH> strongly doubt),

Migration of a container?  Yeah, it's one of the primary reasons for
doing what we're doing :)

TH> we can think about allowing processes in a netns to change
TH> sequence number but that would be a single setsockopt option

Yeah, well there's more than that, of course, if you want to be able
to checkpoint a socket in any state.  Buffers, time-wait, etc.

TH> instead of the horror show of dumping in-kernel data structures in
TH> binary blob.

Well, as should be evident from a review of the code, we don't dump
binary kernel data structures as a general rule.  We canonicalize them
into checkpoint headers on the way out and build the new data
structures (or use existing kernel interfaces to do so) on the way in.
You know, just like netlink does.

It has even been suggested that we do this with netlink instead, to
mirror the other "horror show" tools that we all use on a daily basis.
We're not opposed to this, but we do have some concerns about
performance.

-- 
Dan Smith
IBM Linux Technology Center
email: danms@us.ibm.com

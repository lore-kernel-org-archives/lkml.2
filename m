Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab2HOPoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:44:13 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:20429 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754621Ab2HOPoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:44:12 -0400
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2012 11:44:11 EDT
Date: Wed, 15 Aug 2012 15:34:39 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        kamezawa.hiroyu@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH v2 04/11] kmem accounting basic infrastructure
In-Reply-To: <502BBC35.809@parallels.com>
Message-ID: <000001392aec1926-72b3a631-1fb1-460c-803d-38c4405151e1-000000@email.amazonses.com>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-5-git-send-email-glommer@parallels.com> <20120814162144.GC6905@dhcp22.suse.cz> <502B6D03.1080804@parallels.com> <20120815123931.GF23985@dhcp22.suse.cz>
 <000001392ac15404-43a3fd2c-a6d3-4985-b173-74bb586ad47c-000000@email.amazonses.com> <502BBC35.809@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2012, Glauber Costa wrote:

> On 08/15/2012 06:47 PM, Christoph Lameter wrote:
> > On Wed, 15 Aug 2012, Michal Hocko wrote:
> >
> >>> That is not what the kernel does, in general. We assume that if he wants
> >>> that memory and we can serve it, we should. Also, not all kernel memory
> >>> is unreclaimable. We can shrink the slabs, for instance. Ying Han
> >>> claims she has patches for that already...
> >>
> >> Are those patches somewhere around?
> >
> > You can already shrink the reclaimable slabs (dentries / inodes) via
> > calls to the subsystem specific shrinkers. Did Ying Han do anything to
> > go beyond that?
> >
> That is not enough for us.
> We would like to make sure that the objects being discarded belong to
> the memcg which is under pressure. We don't need to be perfect here, and
> an occasional slip is totally fine. But if in general, shrinking from
> memcg A will mostly wipe out objects from memcg B, we harmed the system
> in return for nothing good.

How can you figure out which objects belong to which memcg? The ownerships
of dentries and inodes is a dubious concept already.


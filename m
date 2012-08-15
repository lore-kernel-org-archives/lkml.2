Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab2HOPpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:45:54 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:21742 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754621Ab2HOPpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:45:52 -0400
Date: Wed, 15 Aug 2012 15:36:28 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Greg Thelen <gthelen@google.com>
cc: Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@parallels.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, devel@openvz.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        kamezawa.hiroyu@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, yinghan@google.com
Subject: Re: [PATCH v2 04/11] kmem accounting basic infrastructure
In-Reply-To: <xr93obmcb2sh.fsf@gthelen.mtv.corp.google.com>
Message-ID: <000001392aedc393-52afb686-d95c-4ed7-9164-1388267fab06-000000@email.amazonses.com>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-5-git-send-email-glommer@parallels.com> <20120814162144.GC6905@dhcp22.suse.cz> <502B6D03.1080804@parallels.com> <20120815123931.GF23985@dhcp22.suse.cz>
 <000001392ac15404-43a3fd2c-a6d3-4985-b173-74bb586ad47c-000000@email.amazonses.com> <xr93obmcb2sh.fsf@gthelen.mtv.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2012, Greg Thelen wrote:

> > You can already shrink the reclaimable slabs (dentries / inodes) via
> > calls to the subsystem specific shrinkers. Did Ying Han do anything to
> > go beyond that?
>
> cc: Ying
>
> The Google shrinker patches enhance prune_dcache_sb() to limit dentry
> pressure to a specific memcg.

Ok then its restricted to the reclaimable slab caches already. The main
issue to sort out then is who is the "owner" of an inode/dentry (if
something like that exists). If you separate the objects into different
pages then the objects may be cleanly separated at the price of more
memory use.


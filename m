Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab2HOP0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:26:43 -0400
Received: from mail-ey0-f202.google.com ([209.85.215.202]:43349 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab2HOP0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:26:42 -0400
From: Greg Thelen <gthelen@google.com>
To: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@parallels.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, devel@openvz.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        kamezawa.hiroyu@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, yinghan@google.com
Subject: Re: [PATCH v2 04/11] kmem accounting basic infrastructure
References: <1344517279-30646-1-git-send-email-glommer@parallels.com>
	<1344517279-30646-5-git-send-email-glommer@parallels.com>
	<20120814162144.GC6905@dhcp22.suse.cz>
	<502B6D03.1080804@parallels.com>
	<20120815123931.GF23985@dhcp22.suse.cz>
	<000001392ac15404-43a3fd2c-a6d3-4985-b173-74bb586ad47c-000000@email.amazonses.com>
Date: Wed, 15 Aug 2012 08:19:58 -0700
In-Reply-To: <000001392ac15404-43a3fd2c-a6d3-4985-b173-74bb586ad47c-000000@email.amazonses.com>
	(Christoph Lameter's message of "Wed, 15 Aug 2012 14:47:57 +0000")
Message-ID: <xr93obmcb2sh.fsf@gthelen.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15 2012, Christoph Lameter wrote:

> On Wed, 15 Aug 2012, Michal Hocko wrote:
>
>> > That is not what the kernel does, in general. We assume that if he wants
>> > that memory and we can serve it, we should. Also, not all kernel memory
>> > is unreclaimable. We can shrink the slabs, for instance. Ying Han
>> > claims she has patches for that already...
>>
>> Are those patches somewhere around?
>
> You can already shrink the reclaimable slabs (dentries / inodes) via
> calls to the subsystem specific shrinkers. Did Ying Han do anything to
> go beyond that?

cc: Ying

The Google shrinker patches enhance prune_dcache_sb() to limit dentry
pressure to a specific memcg.

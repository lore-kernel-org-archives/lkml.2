Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab2HOSHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 14:07:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42114 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab2HOSHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 14:07:09 -0400
MIME-Version: 1.0
In-Reply-To: <502BBC35.809@parallels.com>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com>
	<1344517279-30646-5-git-send-email-glommer@parallels.com>
	<20120814162144.GC6905@dhcp22.suse.cz>
	<502B6D03.1080804@parallels.com>
	<20120815123931.GF23985@dhcp22.suse.cz>
	<000001392ac15404-43a3fd2c-a6d3-4985-b173-74bb586ad47c-000000@email.amazonses.com>
	<502BBC35.809@parallels.com>
Date: Wed, 15 Aug 2012 11:07:09 -0700
Message-ID: <CALWz4ix7ZfcX+TLob6n8M8gC0TkFRL7djMWT5OigZGTnSd99+Q@mail.gmail.com>
Subject: Re: [PATCH v2 04/11] kmem accounting basic infrastructure
From: Ying Han <yinghan@google.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Christoph Lameter <cl@linux.com>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, devel@openvz.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        kamezawa.hiroyu@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 8:11 AM, Glauber Costa <glommer@parallels.com> wrote:
> On 08/15/2012 06:47 PM, Christoph Lameter wrote:
>> On Wed, 15 Aug 2012, Michal Hocko wrote:
>>
>>>> That is not what the kernel does, in general. We assume that if he wants
>>>> that memory and we can serve it, we should. Also, not all kernel memory
>>>> is unreclaimable. We can shrink the slabs, for instance. Ying Han
>>>> claims she has patches for that already...
>>>
>>> Are those patches somewhere around?
>>
>> You can already shrink the reclaimable slabs (dentries / inodes) via
>> calls to the subsystem specific shrinkers. Did Ying Han do anything to
>> go beyond that?
>>
> That is not enough for us.
> We would like to make sure that the objects being discarded belong to
> the memcg which is under pressure. We don't need to be perfect here, and
> an occasional slip is totally fine. But if in general, shrinking from
> memcg A will mostly wipe out objects from memcg B, we harmed the system
> in return for nothing good.

Correct. For example, we have per-superblock shrinker today for vfs
caches. That is not enough since we need to isolate the dentry caches
per-memcg basis.

--Ying
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

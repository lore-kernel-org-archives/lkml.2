Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab2HOPPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:15:03 -0400
Received: from mx2.parallels.com ([64.131.90.16]:56068 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab2HOPPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:15:01 -0400
Message-ID: <502BBC35.809@parallels.com>
Date: Wed, 15 Aug 2012 19:11:49 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Michal Hocko <mhocko@suse.cz>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>, <devel@openvz.org>,
        "Johannes Weiner" <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, David Rientjes <rientjes@google.com>,
        "Pekka Enberg" <penberg@kernel.org>
Subject: Re: [PATCH v2 04/11] kmem accounting basic infrastructure
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-5-git-send-email-glommer@parallels.com> <20120814162144.GC6905@dhcp22.suse.cz> <502B6D03.1080804@parallels.com> <20120815123931.GF23985@dhcp22.suse.cz> <000001392ac15404-43a3fd2c-a6d3-4985-b173-74bb586ad47c-000000@email.amazonses.com>
In-Reply-To: <000001392ac15404-43a3fd2c-a6d3-4985-b173-74bb586ad47c-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.173.1.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 06:47 PM, Christoph Lameter wrote:
> On Wed, 15 Aug 2012, Michal Hocko wrote:
> 
>>> That is not what the kernel does, in general. We assume that if he wants
>>> that memory and we can serve it, we should. Also, not all kernel memory
>>> is unreclaimable. We can shrink the slabs, for instance. Ying Han
>>> claims she has patches for that already...
>>
>> Are those patches somewhere around?
> 
> You can already shrink the reclaimable slabs (dentries / inodes) via
> calls to the subsystem specific shrinkers. Did Ying Han do anything to
> go beyond that?
> 
That is not enough for us.
We would like to make sure that the objects being discarded belong to
the memcg which is under pressure. We don't need to be perfect here, and
an occasional slip is totally fine. But if in general, shrinking from
memcg A will mostly wipe out objects from memcg B, we harmed the system
in return for nothing good.


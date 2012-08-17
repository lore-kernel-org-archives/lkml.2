Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030618Ab2HQHEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 03:04:22 -0400
Received: from mx2.parallels.com ([64.131.90.16]:46639 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212Ab2HQHEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 03:04:20 -0400
Message-ID: <502DEC32.6070807@parallels.com>
Date: Fri, 17 Aug 2012 11:01:06 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v2 08/11] memcg: disable kmem code when not in use.
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-9-git-send-email-glommer@parallels.com> <20120817070241.GA18600@dhcp22.suse.cz>
In-Reply-To: <20120817070241.GA18600@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 11:02 AM, Michal Hocko wrote:
> On Thu 09-08-12 17:01:16, Glauber Costa wrote:
>> We can use jump labels to patch the code in or out when not used.
>>
>> Because the assignment: memcg->kmem_accounted = true is done after the
>> jump labels increment, we guarantee that the root memcg will always be
>> selected until all call sites are patched (see memcg_kmem_enabled).
> 
> Not that it would be really important because kmem_accounted goes away
> in a subsequent patch but I think the wording is a bit misleading here.
> First of all there is no guanratee that kmem_accounted=true is seen
> before atomic_inc(&key->enabled) because there is no memory barrier and
> the lock serves just a leave barrier. But I do not think this is
> important at all because key->enabled is what matters here. Even if
> memcg_kmem_enabled is true we do not consider it if the key is disabled,
> right?
> 

Right.


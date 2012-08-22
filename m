Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab2HVIjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:39:37 -0400
Received: from mx2.parallels.com ([64.131.90.16]:48153 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab2HVIj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:39:29 -0400
Message-ID: <50349A01.5020906@parallels.com>
Date: Wed, 22 Aug 2012 12:36:17 +0400
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
Subject: Re: [PATCH v2 10/11] memcg: allow a memcg with kmem charges to be
 destructed.
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-11-git-send-email-glommer@parallels.com> <20120821082259.GB19797@dhcp22.suse.cz>
In-Reply-To: <20120821082259.GB19797@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2012 12:22 PM, Michal Hocko wrote:
> On Thu 09-08-12 17:01:18, Glauber Costa wrote:
>> Because the ultimate goal of the kmem tracking in memcg is to track slab
>> pages as well, we can't guarantee that we'll always be able to point a
>> page to a particular process, and migrate the charges along with it -
>> since in the common case, a page will contain data belonging to multiple
>> processes.
>>
>> Because of that, when we destroy a memcg, we only make sure the
>> destruction will succeed by discounting the kmem charges from the user
>> charges when we try to empty the cgroup.
> 
> This changes the semantic of memory.force_empty file because the usage
> should be 0 on success but it will show kmem usage in fact now. I guess
> it is inevitable with u+k accounting so you should be explicit about
> that and also update the documentation.
aaand, it's done.


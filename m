Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab2I1JrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:47:23 -0400
Received: from mx2.parallels.com ([64.131.90.16]:37192 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600Ab2I1JrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:47:21 -0400
Message-ID: <50657153.8010101@parallels.com>
Date: Fri, 28 Sep 2012 13:43:47 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <devel@openvz.org>,
        Tejun Heo <tj@kernel.org>, <linux-mm@kvack.org>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "David Rientjes" <rientjes@google.com>,
        Christoph Lameter <cl@linux.com>,
        "Pekka Enberg" <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        "Johannes Weiner" <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 07/13] mm: Allocate kernel pages to the right memcg
References: <1347977050-29476-1-git-send-email-glommer@parallels.com> <1347977050-29476-8-git-send-email-glommer@parallels.com> <20120927135053.GF3429@suse.de>
In-Reply-To: <20120927135053.GF3429@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 05:50 PM, Mel Gorman wrote:
>> +void __free_accounted_pages(struct page *page, unsigned int order)
>> > +{
>> > +	memcg_kmem_uncharge_page(page, order);
>> > +	__free_pages(page, order);
>> > +}
>> > +
>> > +void free_accounted_pages(unsigned long addr, unsigned int order)
>> > +{
>> > +	if (addr != 0) {
>> > +		VM_BUG_ON(!virt_addr_valid((void *)addr));
> This is probably overkill. If it's invalid, the next line is likely to
> blow up anyway. It's no biggie.
> 

So this is here because it is in free_pages() as well. If it blows, at
least we know precisely why (if debugging), and VM_BUG_ON() is only
compiled in when CONFIG_DEBUG_VM.

But I'm fine with either.
Should it stay or should it go ?



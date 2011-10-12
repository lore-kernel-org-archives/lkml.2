Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab1JLNOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 09:14:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023Ab1JLNOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 09:14:05 -0400
Message-ID: <4E959292.9060301@redhat.com>
Date: Wed, 12 Oct 2011 09:13:54 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Satoru Moriya <satoru.moriya@hds.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: Re: [PATCH -v2 -mm] add extra free kbytes tunable
References: <20110901105208.3849a8ff@annuminas.surriel.com> <20110901100650.6d884589.rdunlap@xenotime.net> <20110901152650.7a63cb8b@annuminas.surriel.com> <alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com> <65795E11DBF1E645A09CEC7EAEE94B9CB516CBBC@USINDEVS02.corp.hds.com> <alpine.DEB.2.00.1110111343070.29761@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1110111343070.29761@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2011 05:04 PM, David Rientjes wrote:

> In other words, I think it's a fine solution if you're running a single
> application with very bursty memory allocations so you need to reclaim
> more memory when low, but that solution is troublesome if it comes at
> the penalty of other applications and that's a direct consequence of it
> being a global tunable.  I'd much rather identify memory allocations in
> the kernel that causing the pain here and mitigate it by (i) attempting to
> sanely rate limit those allocations,

Rate limiting just increases the problem from what it was
before the patch was introduced, because the entire purpose
is to reduce allocation latencies by tasks with low latency
requirements.

> (ii) preallocate at least a partial
> amount of those allocations ahead of time so avoid significant reclaim
> all at one,

Unless I'm mistaken, isn't this functionally equivalent to
increasing the size of the free memory pool?

> or (iii) annotate memory allocations with such potential so
> that the page allocator can add this reclaim bonus itself only in these
> conditions.

I am not sure what you are proposing here.

How would this scheme work?

-- 
All rights reversed

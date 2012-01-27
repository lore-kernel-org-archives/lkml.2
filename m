Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab2A0D2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 22:28:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab2A0D2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 22:28:37 -0500
Message-ID: <4F2219D4.9010209@redhat.com>
Date: Thu, 26 Jan 2012 22:28:20 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Konrad Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Nebojsa Trpkovic <trx.lists@gmail.com>, minchan@kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] mm: implement WasActive page flag (for improving cleancache)
References: <ea3b0850-dfe0-46db-9201-2bfef110848d@default> <4F218D36.2060308@linux.vnet.ibm.com> <9fcd06f5-360e-4542-9fbb-f8c7efb28cb6@default> <20120126163150.31a8688f.akpm@linux-foundation.org> <ccb76a4d-d453-4faa-93a9-d1ce015255c0@default>
In-Reply-To: <ccb76a4d-d453-4faa-93a9-d1ce015255c0@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2012 07:56 PM, Dan Magenheimer wrote:

> The patch resolves issues reported with cleancache which occur
> especially during streaming workloads on older processors,
> see https://lkml.org/lkml/2011/8/17/351
>
> I can see that may not be sufficient, so let me expand on it.
>
> First, just as page replacement worked prior to the active/inactive
> redesign at 2.6.27, cleancache works without the WasActive page flag.
> However, just as pre-2.6.27 page replacement had problems on
> streaming workloads, so does cleancache.  The WasActive page flag
> is an attempt to pass the same active/inactive info gathered by
> the post-2.6.27 kernel into cleancache, with the same objectives and
> presumably the same result: improving the "quality" of pages preserved
> in memory thus reducing refaults.
>
> Is that clearer?  If so, I'll do better on the description at v2.

Whether or not this patch improves things would depend
entirely on the workload, no?

I can imagine a workload where we have a small virtual
machine and a large cleancache buffer in the host.

Due to the small size of the virtual machine, pages
might not stay on the inactive list long enough to get
accessed twice in a row.

When the page gets rescued from the cleancache, we
know it was recently evicted and we can immediately
put it onto the active file list.

This is almost the opposite problem (and solution) of
what you ran into.

Both seem equally likely (and probable)...

-- 
All rights reversed

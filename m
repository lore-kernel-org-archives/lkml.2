Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab0HXRly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 13:41:54 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34887 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab0HXRlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 13:41:53 -0400
Message-ID: <4C740450.3030000@cs.helsinki.fi>
Date: Tue, 24 Aug 2010 20:41:36 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (slab
 tree related)
References: <20100824120714.8918f8de.sfr@canb.auug.org.au>
In-Reply-To: <20100824120714.8918f8de.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.8.2010 5.07, Stephen Rothwell wrote:
> Hi all,
>
> After merging the final tree, today's linux-next build (powerpc
> allnoconfig) failed like this:
>
> mm/slub.c: In function 'alloc_kmem_cache_cpus':
> mm/slub.c:2094: error: 'PERCPU_DYNAMIC_EARLY_SIZE' undeclared (first use in this function)
> mm/slub.c:2094: error: (Each undeclared identifier is reported only once
> mm/slub.c:2094: error: for each function it appears in.)
> mm/slub.c:2094: error: bit-field '<anonymous>' width not an integer constant
>
> Caused by commit e18d65f0500b95d8724b17d8ea9f1116cf390bbe ("slub: Remove
> static kmem_cache_cpu array for boot"). PERCPU_DYNAMIC_EARLY_SIZE is only
> defined for SMP (and only in linux/percpu.h which is not explicitly
> included).  This build does not have CONFIG_SMP set.
>
> I have used the version of the slab tree from next-20100823 for today.

Thanks for the report. The problem should be fixed by this commit:

http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=5792949c540c9fd719c3fc0d6edc97374222e792

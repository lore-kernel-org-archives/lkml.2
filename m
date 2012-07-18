Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab2GRIP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 04:15:56 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:59262 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab2GRIPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 04:15:49 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <js1304@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm: fix wrong argument of migrate_huge_pages() in soft_offline_huge_page()
In-Reply-To: <alpine.DEB.2.00.1207171526440.23015@chino.kir.corp.google.com>
References: <1342544460-20095-1-git-send-email-js1304@gmail.com> <alpine.DEB.2.00.1207171340420.9675@chino.kir.corp.google.com> <20120717134915.76adf9bd.akpm@linux-foundation.org> <alpine.DEB.2.00.1207171526440.23015@chino.kir.corp.google.com>
User-Agent: Notmuch/0.13.2+63~g548a9bf (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 18 Jul 2012 13:45:41 +0530
Message-ID: <87ipdlcwnm.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12071808-3864-0000-0000-000003D15E6F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes <rientjes@google.com> writes:

> On Tue, 17 Jul 2012, Andrew Morton wrote:
>
>> > > Commit a6bc32b899223a877f595ef9ddc1e89ead5072b8 ('mm: compaction: introduce
>> > > sync-light migration for use by compaction') change declaration of
>> > > migrate_pages() and migrate_huge_pages().
>> > > But, it miss changing argument of migrate_huge_pages()
>> > > in soft_offline_huge_page(). In this case, we should call with MIGRATE_SYNC.
>> > > So change it.
>> > > 
>> > > Additionally, there is mismatch between type of argument and function
>> > > declaration for migrate_pages(). So fix this simple case, too.
>> > > 
>> > > Signed-off-by: Joonsoo Kim <js1304@gmail.com>
>> > 
>> > Acked-by: David Rientjes <rientjes@google.com>
>> > 
>> > Should be cc'd to stable for 3.3+.
>> 
>> Well, why?  I'm suspecting a switch from MIGRATE_SYNC_LIGHT to
>> MIGRATE_SYNC will have no discernable effect.  Unless it triggers hitherto
>> unknkown about deadlocks...
>> 
>> For a -stable backport we should have a description of the end-user
>> visible effects of the bug.  This changelog lacked such a description.
>> 
>
> I would put this:
>
> MIGRATE_SYNC_LIGHT will not aggressively attempt to defragment memory when 
> allocating hugepages for migration with MIGRATE_SYNC_LIGHT, such as not 
> defragmenting dirty pages, so MADV_SOFT_OFFLINE and 
> /sys/devices/system/memory/soft_offline_page would be significantly 
> less successful without this patch.

Is that true with hugetlb pages ? hugetlbfs_migrate_page doesn't seem to
use the mode argument at all. We do look at MIGRATE_SYNC if we fail to
get page lock, but other than that do we look at mode argument for
hugetlb pages ?

-aneesh


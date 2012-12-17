Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325Ab2LQDAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 22:00:36 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:59783 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab2LQDAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 22:00:35 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1212161854000.1626@eggly.anvils>
References: <20121212100338.GS1009@suse.de> <CA+55aFzedbhcuo-WObUjigrXGuG2VGLqDOvh_HFA9Cn_BRkwjQ@mail.gmail.com>
 <alpine.LNX.2.00.1212161850060.1626@eggly.anvils> <alpine.LNX.2.00.1212161854000.1626@eggly.anvils>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 16 Dec 2012 19:00:12 -0800
X-Google-Sender-Auth: VLHaCo0R3NOhdNnaqNkrr-JqZBs
Message-ID: <CA+55aFxhT+e2C3m8VqPdQKK3QdkQFTPukCGv_GCjVBT=zCg4pA@mail.gmail.com>
Subject: Re: [PATCH] mm: fix kernel BUG at huge_memory.c:1474!
To: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Hillf Danton <dhillf@gmail.com>, David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 6:56 PM, Hugh Dickins <hughd@google.com> wrote:
> Andrea's autonuma-benchmark numa01 hits kernel BUG at huge_memory.c:1474!
> in change_huge_pmd called from change_protection from change_prot_numa
> from task_numa_work.
>
> That BUG, introduced in the huge zero page commit cad7f613c4d0 ("thp:
> change_huge_pmd(): make sure we don't try to make a page writable")
> was trying to verify that newprot never adds write permission to an
> anonymous huge page; but Automatic NUMA Balancing's 4b10e7d562c9 ("mm:
> mempolicy: Implement change_prot_numa() in terms of change_protection()")
> adds a new prot_numa path into change_huge_pmd(), which makes no use of
> the newprot provided, and may retain the write bit in the pmd.

Ok. I did wonder about that particular conflict, but it looked like
neither case was writable, so I resolved it wrongly, and it worked for
me, but then I don't have any numa setups, nor do I even enable it..

Thanks,

                Linus

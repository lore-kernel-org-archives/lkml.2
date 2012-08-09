Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360Ab2HIPYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:24:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40412 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab2HIPYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:24:35 -0400
Message-ID: <5023D60F.7010009@zytor.com>
Date: Thu, 09 Aug 2012 08:23:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Alex Shi <alex.shu@intel.com>, Jan Beulich <jbeulich@novell.com>,
        Robert Richter <robert.richter@amd.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH v2 4/6] x86: Add clear_page_nocache
References: <1344524583-1096-1-git-send-email-kirill.shutemov@linux.intel.com> <1344524583-1096-5-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1344524583-1096-5-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 08:03 AM, Kirill A. Shutemov wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Add a cache avoiding version of clear_page. Straight forward integer variant
> of the existing 64bit clear_page, for both 32bit and 64bit.
>
> Also add the necessary glue for highmem including a layer that non cache
> coherent architectures that use the virtual address for flushing can
> hook in. This is not needed on x86 of course.
>
> If an architecture wants to provide cache avoiding version of clear_page
> it should to define ARCH_HAS_USER_NOCACHE to 1 and implement
> clear_page_nocache() and clear_user_highpage_nocache().
>

Compile failure:

/home/hpa/kernel/tip.x86-mm/arch/x86/mm/fault.c: In function 
‘clear_user_highpage_nocache’:
/home/hpa/kernel/tip.x86-mm/arch/x86/mm/fault.c:1215:30: error: 
‘KM_USER0’ undeclared (first use in this function)
/home/hpa/kernel/tip.x86-mm/arch/x86/mm/fault.c:1215:30: note: each 
undeclared identifier is reported only once for each function it appears in
/home/hpa/kernel/tip.x86-mm/arch/x86/mm/fault.c:1215:2: error: too many 
arguments to function ‘kmap_atomic’
In file included from 
/home/hpa/kernel/tip.x86-mm/include/linux/pagemap.h:10:0,
                  from 
/home/hpa/kernel/tip.x86-mm/include/linux/mempolicy.h:70,
                  from 
/home/hpa/kernel/tip.x86-mm/include/linux/hugetlb.h:15,
                  from /home/hpa/kernel/tip.x86-mm/arch/x86/mm/fault.c:14:
/home/hpa/kernel/tip.x86-mm/include/linux/highmem.h:66:21: note: 
declared here
make[4]: *** [arch/x86/mm/fault.o] Error 1
make[3]: *** [arch/x86/mm] Error 2
make[2]: *** [arch/x86] Error 2
make[1]: *** [sub-make] Error 2
make[1]: Leaving directory `/home/hpa/kernel/tip.x86-mm'

This happens on *all* my test configurations, including both x86-64 and 
i386 allyesconfig.  I suspect your patchset base is stale.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


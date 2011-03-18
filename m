Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab1CRCTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 22:19:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:29069 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555Ab1CRCTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 22:19:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,203,1299484800"; 
   d="scan'208";a="721435628"
Subject: Re: [PATCH]x86: flush tlb if PGD entry is changed in i386 PAE mode
From: Shaohua Li <shaohua.li@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Rik van Riel <riel@redhat.com>,
        "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
In-Reply-To: <4D80B514.3030409@redhat.com>
References: <1300246649.2337.95.camel@sli10-conroe>
	 <4D80B514.3030409@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Mar 2011 10:19:08 +0800
Message-ID: <1300414748.2337.137.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 21:03 +0800, Rik van Riel wrote:
> On 03/15/2011 11:37 PM, Shaohua Li wrote:
> > According to intel CPU manual, every time PGD entry is changed in i386 PAE mode,
> > we need do a full TLB flush. Current code follows this and there is comment
> > for this too in the code. But current code misses the multi-threaded case. A
> > changed page table might be used by several CPUs, every such CPU should flush
> > TLB.
> > Usually this isn't a problem, because we prepopulate all PGD entries at process
> > fork. But when the process does munmap and follows new mmap, this issue will be
> > triggered. When it happens, some CPUs will keep doing page fault.
> >
> > See: http://marc.info/?l=linux-kernel&m=129915020508238&w=2
> >
> > Reported-by: Yasunori Goto<y-goto@jp.fujitsu.com>
> > Signed-off-by: Shaohua Li<shaohua.li@intel.com>
> > Tested-by: Yasunori Goto<y-goto@jp.fujitsu.com>
> 
> Reviewed-by: Rik van Riel <riel@redhat.com>
Ingo & akpm,
can you pick this one?

Thanks,
Shaohua


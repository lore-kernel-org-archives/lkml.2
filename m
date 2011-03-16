Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab1CPPzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 11:55:17 -0400
Received: from kroah.org ([198.145.64.141]:50178 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494Ab1CPPzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:55:13 -0400
Date: Wed, 16 Mar 2011 08:51:04 -0700
From: Greg KH <greg@kroah.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Rik van Riel <riel@redhat.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        stable <stable@kernel.org>, y-goto@jp.fujitsu.com,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [stable] [PATCH]x86: flush tlb if PGD entry is changed in i386
 PAE mode
Message-ID: <20110316155104.GA25008@kroah.com>
References: <1300246649.2337.95.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300246649.2337.95.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 11:37:29AM +0800, Shaohua Li wrote:
> According to intel CPU manual, every time PGD entry is changed in i386 PAE mode,
> we need do a full TLB flush. Current code follows this and there is comment
> for this too in the code. But current code misses the multi-threaded case. A
> changed page table might be used by several CPUs, every such CPU should flush
> TLB.
> Usually this isn't a problem, because we prepopulate all PGD entries at process
> fork. But when the process does munmap and follows new mmap, this issue will be
> triggered. When it happens, some CPUs will keep doing page fault.
> 
> See: http://marc.info/?l=linux-kernel&m=129915020508238&w=2
> 
> Reported-by: Yasunori Goto<y-goto@jp.fujitsu.com>
> Signed-off-by: Shaohua Li<shaohua.li@intel.com>
> Tested-by: Yasunori Goto<y-goto@jp.fujitsu.com>

This is not how you submit something to the stable kernel tree.  Please
go read Documentation/stable_kernel_rules.txt for how to do it properly.

thanks,

greg k-h

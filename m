Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab1CPNEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:04:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169Ab1CPNEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:04:31 -0400
Message-ID: <4D80B514.3030409@redhat.com>
Date: Wed, 16 Mar 2011 09:03:16 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        y-goto@jp.fujitsu.com, "Mallick, Asit K" <asit.k.mallick@intel.com>,
        stable <stable@kernel.org>
Subject: Re: [PATCH]x86: flush tlb if PGD entry is changed in i386 PAE mode
References: <1300246649.2337.95.camel@sli10-conroe>
In-Reply-To: <1300246649.2337.95.camel@sli10-conroe>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2011 11:37 PM, Shaohua Li wrote:
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

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed

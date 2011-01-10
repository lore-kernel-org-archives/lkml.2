Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab1AJVC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:02:57 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52090 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab1AJVCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:02:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=A3TO/5+Y/AOiEMcuXOOsv+hvbKpE16vMYDOJdCXjMxLL+p/5RYOJ4NfqrSdxbyAe4Z
         frdVl7o7RbwVjFGJMuAgWahcAkMoWwXVeKnLjc5TfZYDSme5gQVF+oRD2RJuDIqlQ8QZ
         BBKzOa/rhYeYUdjVuxt7DUhOrPtojm0V3/Z6U=
Message-ID: <4D2B73FA.807@gmail.com>
Date: Mon, 10 Jan 2011 22:02:50 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org
Subject: Re: qemu-kvm defunct due to THP [was: mmotm 2011-01-06-15-41 uploaded]
References: <201101070014.p070Egpo023959@imap1.linux-foundation.org> <4D2B19C5.5060709@gmail.com> <20110110150128.GC9506@random.random>
In-Reply-To: <20110110150128.GC9506@random.random>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2011 04:01 PM, Andrea Arcangeli wrote:
> On Mon, Jan 10, 2011 at 03:37:57PM +0100, Jiri Slaby wrote:
>> On 01/07/2011 12:41 AM, akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2011-01-06-15-41 has been uploaded to
>>
>> Hi, something of the following breaks qemu-kvm:
> 
> Thanks for the report. It's already fixed and I posted this a few days
> ago to linux-mm.
> 
> I had to rewrite the KVM THP support when merging THP in -mm, because
> the kvm code in -mm has async page faults and doing so I eliminated
> one gfn_to_page lookup for each kvm secondary mmu page fault. But
> first new attempt wasn't entirely successful ;), the below incremental
> fix should work. Please test it and let me know if any trouble is
> left.
> 
> Also note again on linux-mm I posted two more patches, I recommend to
> apply the other two as well. The second adds KSM THP support, the
> third cleanup some code but I like to have it tested.
> 
> Thanks a lot,
> Andrea
> 
> ====
> Subject: thp: fix for KVM THP support
> 
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> There were several bugs: dirty_bitmap ignored (migration shutoff largepages),
> has_wrprotect_page(directory_level) ignored, refcount taken on tail page and
> refcount released on pfn head page post-adjustment (now it's being transferred
> during the adjustment, that's where KSM over THP tripped inside
> split_huge_page, the rest I found it by code review).
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  arch/x86/kvm/mmu.c         |   97 ++++++++++++++++++++++++++++++++-------------
>  arch/x86/kvm/paging_tmpl.h |   10 +++-
>  2 files changed, 79 insertions(+), 28 deletions(-)

Yup, this works for me. If you point me to the other 2, I will test them
too...

thanks,
-- 
js

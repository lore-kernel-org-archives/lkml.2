Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab0JYJc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 05:32:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027Ab0JYJc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 05:32:56 -0400
Message-ID: <4CC54EB8.9020604@redhat.com>
Date: Mon, 25 Oct 2010 11:32:40 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Gleb Natapov <gleb@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Sheng Yang <sheng@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: write protect memory after slot swap
References: <20101025012124.GA31262@redhat.com>
In-Reply-To: <20101025012124.GA31262@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/25/2010 03:21 AM, Michael S. Tsirkin wrote:
> I have observed the following bug trigger:
>
> 1. userspace calls GET_DIRTY_LOG
> 2. kvm_mmu_slot_remove_write_access is called and makes a page ro
> 3. page fault happens and makes the page writeable
>     fault is logged in the bitmap appropriately
> 4. kvm_vm_ioctl_get_dirty_log swaps slot pointers
>
> a lot of time passes
>
> 5. guest writes into the page
> 6. userspace calls GET_DIRTY_LOG
>
> At point (5), bitmap is clean and page is writeable,
> thus, guest modification of memory is not logged
> and GET_DIRTY_LOG returns an empty bitmap.
>
> The rule is that all pages are either dirty in the current bitmap,
> or write-protected, which is violated here.
>
> It seems that just moving kvm_mmu_slot_remove_write_access down
> to after the slot pointer swap should fix this bug.
>
> Warning: completely untested.
> Please comment.
> Note: fix will be needed for -stable etc.

Excellent catch, I stared at this code for a while and didn't see the 
bug.  Patch applied.

-- 
error compiling committee.c: too many arguments to function


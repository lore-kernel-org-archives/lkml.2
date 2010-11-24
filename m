Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab0KXTRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:17:37 -0500
Received: from goliath.siemens.de ([192.35.17.28]:24315 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132Ab0KXTRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:17:36 -0500
Message-ID: <4CED649B.5000805@siemens.com>
Date: Wed, 24 Nov 2010 20:16:43 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Gleb Natapov <gleb@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: write protect memory after slot swap
References: <20101025012124.GA31262@redhat.com> <4CC54EB8.9020604@redhat.com>
In-Reply-To: <4CC54EB8.9020604@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 25.10.2010 11:32, Avi Kivity wrote:
>  On 10/25/2010 03:21 AM, Michael S. Tsirkin wrote:
>> I have observed the following bug trigger:
>>
>> 1. userspace calls GET_DIRTY_LOG
>> 2. kvm_mmu_slot_remove_write_access is called and makes a page ro
>> 3. page fault happens and makes the page writeable
>>     fault is logged in the bitmap appropriately
>> 4. kvm_vm_ioctl_get_dirty_log swaps slot pointers
>>
>> a lot of time passes
>>
>> 5. guest writes into the page
>> 6. userspace calls GET_DIRTY_LOG
>>
>> At point (5), bitmap is clean and page is writeable,
>> thus, guest modification of memory is not logged
>> and GET_DIRTY_LOG returns an empty bitmap.
>>
>> The rule is that all pages are either dirty in the current bitmap,
>> or write-protected, which is violated here.
>>
>> It seems that just moving kvm_mmu_slot_remove_write_access down
>> to after the slot pointer swap should fix this bug.
>>
>> Warning: completely untested.
>> Please comment.
>> Note: fix will be needed for -stable etc.
> 
> Excellent catch, I stared at this code for a while and didn't see the
> bug.  Patch applied.
> 

This patch was marked KVM-stable on commit, but it did not make into any
stable branch thus also none of the recent releases. Please fix (for
2.6.36 now).

Thanks,
Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux

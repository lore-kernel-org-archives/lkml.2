Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab2HOFwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 01:52:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304Ab2HOFwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 01:52:04 -0400
Message-ID: <502B38FB.6050603@redhat.com>
Date: Wed, 15 Aug 2012 13:51:55 +0800
From: WANG Chao <chaowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: Dave Young <dyoung@redhat.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Tejun Heo <tj@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH V2 0/5] x86: Create direct mappings for E820_RAM only
References: <1344894424-4434-1-git-send-email-jacob.shin@amd.com> <502A0D9F.4010509@redhat.com> <20120814225416.GB32453@jshin-Toonie>
In-Reply-To: <20120814225416.GB32453@jshin-Toonie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 06:54 AM, Jacob Shin wrote:
> On Tue, Aug 14, 2012 at 04:34:39PM +0800, Dave Young wrote:
>> On 08/14/2012 05:46 AM, Jacob Shin wrote:
>>
>>> Currently kernel direct mappings are created for all pfns between
>>> [ 0 to max_low_pfn ) and [ 4GB to max_pfn ). When we introduce memory
>>> holes, we end up mapping memory ranges that are not backed by physical
>>> DRAM. This is fine for lower memory addresses which can be marked as UC
>>> by fixed/variable range MTRRs, however we run in to trouble with high
>>> addresses.
>>>
>>> The following patchset creates direct mappings only for E820_RAM regions
>>> between 0 ~ max_low_pfn and 4GB ~ max_pfn. And leaves non-E820_RAM and
>>> memory holes unmapped.
>>
>>
>> Hi,
>>
>> Chaowang did some kdump test in a kvm guest with this patchset, 2nd
>> kenrel just reboot after some ACPI printk, see below dmesg of 2nd kernel:
>
> Hello, thanks for testing, since I have not tested under KVM .. I also have
> not tested passing in user supplied memory maps as your kernel log suggests.
>
> Looking into this, it seems like we get a page fault while trying to set up
> fixmap for the APIC. I think the fixmap is set up even before we get to
> setup_arch(), and it is sitting in memory that is not marked as usable by
> your user supplied e820.
>
> Could you give V3 a try? I just sent it out a minute ago, this version
> won't try to remap what has already been mapped as part of the boot process
> before we get to setup_arch, it'll just take what its given.
>

Hi, Jacob

I just tried v3 patchset in my x86_64 kvm guest, it was booting 
successfully and the issue mentioned is gone.

-WANG Chao


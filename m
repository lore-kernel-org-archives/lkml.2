Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab2H1QLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 12:11:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44422 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022Ab2H1QLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 12:11:40 -0400
References: <1345852516-3125-1-git-send-email-jacob.shin@amd.com> <1345852516-3125-4-git-send-email-jacob.shin@amd.com> <CAE9FiQUjaBSn0q=+om7+CPjLXVD9Pemf=mNvgYG7C3bE5XxOSw@mail.gmail.com> <20120825042409.GD26127@jshin-Toonie> <CAE9FiQX2DApN=OU=xTK3VA+p1mDJ=U+qFyyRkaeTiH+xF5dQXw@mail.gmail.com> <20120828160626.GA21454@jshin-Toonie>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120828160626.GA21454@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 3/5] x86: Only direct map addresses that are marked as E820_RAM
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 28 Aug 2012 09:11:26 -0700
To: Jacob Shin <jacob.shin@amd.com>, Yinghai Lu <yinghai@kernel.org>
CC: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Dave Young <dyoung@redhat.com>,
        Chao Wang <chaowang@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <9cbd5a22-c3af-471c-bc25-1b1a7230f816@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EFI runtime code we need to map, but we shouldn't use as RAM.  I suspect this is also true for the ACPI areas.

Jacob Shin <jacob.shin@amd.com> wrote:

>On Fri, Aug 24, 2012 at 09:54:04PM -0700, Yinghai Lu wrote:
>> On Fri, Aug 24, 2012 at 9:24 PM, Jacob Shin <jacob.shin@amd.com>
>wrote:
>> > On Fri, Aug 24, 2012 at 06:07:01PM -0700, Yinghai Lu wrote:
>> >> On Fri, Aug 24, 2012 at 4:55 PM, Jacob Shin <jacob.shin@amd.com>
>wrote:
>> >>
>> >> looks like you could avoid add pfn_mapped[] array.
>> >>
>> >> pfn_range_is_mapped() should be
>> >> check max_low_pfn_mapped, max_pfn_mapped with
>> >> e820_all_mapped(start, end, E820_RAM).
>> >
>> > Hmm .. I guess that could work .. but what about EFI code that keys
>off of
>> > EFI memory map? Does the EFI code update e820 and mark as E820_RAM
>whatever
>> > ranges that it calls init_memory_mapping on (via efi_ioremap?)
>> 
>> they are converted to e820 memmap before init_memory_mapping is
>called.
>
>Yinghai, looking into this further on my EFI enabled machine, there is
>a
>memory range where:
>
>- e820 marks it as E820_RESERVED
>- EFI memory map marks it as EFI_RUNTIME_SERVICES_DATA
>
>During EFI init, the range is added (redundantly) to e820 as
>E820_RESERVED,
>but during efi_enter_virtual_mode, direct mappings are created for the
>range with a call to efi_ioremap.
>
>Another such region is EFI_RUNTIME_SERVICES_CODE which is marked as
>ACPI NVS.
>
>So these are not E820_RAM, but direct mapped by EFI code path .. what
>do
>we do here? I think we should just stick with keeping the pfn_mapped[]
>array .. no?
>
>-Jacob
>
>> 
>> Thanks
>> 
>> Yinghai
>> 

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.

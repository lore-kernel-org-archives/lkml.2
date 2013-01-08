Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab3AHCXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:23:09 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:43429 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3AHCXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:23:07 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-27-git-send-email-yinghai@kernel.org>
	<CAKocOOP=jh2XOFJtoz-uHO2cvb9NRfOGdc05LKg1JH-ToiUwwA@mail.gmail.com>
	<CAE9FiQVKFz6K8xw2Eu5J8G6=QDdo2A7Y2-81GYP5yvP+T1YG5A@mail.gmail.com>
	<CAKocOOPqNPYU1dcDdHpKqMZtJnSOhT6tBGY7k4qGEy6uKSAr7Q@mail.gmail.com>
	<CAE9FiQVM-Rd82n-qhasDCA0+-n6TWH6m9Vm6N1nER__5p34z-Q@mail.gmail.com>
	<20130107152622.GD3219@phenom.dumpdata.com>
	<CAKocOOM9MYD8Z0-ha7NQP6B=J-eGS6uao5oAVfiO+i-a0TVy1A@mail.gmail.com>
Date: Mon, 07 Jan 2013 18:22:51 -0800
In-Reply-To: <CAKocOOM9MYD8Z0-ha7NQP6B=J-eGS6uao5oAVfiO+i-a0TVy1A@mail.gmail.com>
	(Shuah Khan's message of "Mon, 7 Jan 2013 10:02:52 -0700")
Message-ID: <8762382z2c.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18/bL6iR3xB1KFNPZRNmS6pNcnvgnPklmI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  2.9 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3709]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Shuah Khan <shuahkhan@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not enough ram for it
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shuah Khan <shuahkhan@gmail.com> writes:

> On Mon, Jan 7, 2013 at 8:26 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
>> On Fri, Jan 04, 2013 at 02:10:25PM -0800, Yinghai Lu wrote:
>>> On Fri, Jan 4, 2013 at 1:02 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
>>> > Pani'cing the system doesn't sound like a good option to me in this
>>> > case. This change to disable swiotlb is made for kdump. However, with
>>> > this change several system fail to boot, unless crashkernel_low=72M is
>>> > specified.
>>>
>>> this patchset is new feature to put second kdump kernel above 4G.
>>>
>>> >
>>> > I would the say the right approach to solve this would be to not
>>> > change the current pci_swiotlb_detect_override() behavior and treat
>>> > swiotlb =1 upon entry equivalent to swiotlb_force set.
>>>
>>> that will make intel system have to take crashkernel_low=72M too.
>>> otherwise intel system will get panic during swiotlb allocation.
>>
>> Two things:
>>
>>  1). You need to wrap the 'is_enough_..' in CONFIG_KEXEC, which means
>>     that the function needs to go in a header file.
>>  2). The check for 1MB is suspect. Why only 1MB? You mentioned it is
>>      b/c of crashkernel_low=72M (which I am not seeing in v3.8 kernel-parameters.txt?
>>      Is that part of your mega-patchset?). Anyhow, there seems to be a disconnect -
>>      what if the user supplied crashkernel_low=27M? Perhaps the 'is_enough'
>>      should also parse the bootparams to double-check that there is enough
>>      low-mem space? But then if the kernel grows then 72M might not be enough -
>>      you might need 82M with 3.9.
>>
>>      Perhaps a better way for this is to do:
>>         1). Change 'is_enough' to check only for 4MB.
>>         2). When booting as kexec, the SWIOTLB would only use 4MB instead of 64MB?
>>
>>      Or, we could also use the post-late SWIOTLB initialization similiary to how it was
>>      done on ia64. This would mean that the AMD VI code would just call the
>>      .. something like this - NOT tested or even compile tested:
>>
>> diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
>> index c1c74e0..e7fa8f7 100644
>> --- a/drivers/iommu/amd_iommu.c
>> +++ b/drivers/iommu/amd_iommu.c
>> @@ -3173,6 +3173,24 @@ int __init amd_iommu_init_dma_ops(void)
>>         if (unhandled && max_pfn > MAX_DMA32_PFN) {
>>                 /* There are unhandled devices - initialize swiotlb for them */
>>                 swiotlb = 1;
>> +               /* Late (so no bootmem allocator) usage and only if the early SWIOTLB
>> +                * hadn't been allocated (which can happen on kexec kernels booted
>> +                * above 4GB). */
>> +               if (!swiotlb_nr_tbl()) {
>> +                       int retry = 3;
>> +                       int mb_size = 64;
>> +                       int rc = 0;
>> +retry_me:
>> +                       if (retry < 0)
>> +                               panic("We tried setting %dMB for SWIOTLB but got -ENOMEM", mb_size << 1);
>> +                       rc = swiotlb_late_init_with_default_size(mb_size * (1<<20));
>> +                       if (rc) {
>> +                               retry --;
>> +                               mb_size >> 1;
>> +                               goto retry_me;
>> +                       }
>> +                       dma_ops = &swiotlb_dma_ops;
>> +               }
>>         }
>>
>>         amd_iommu_stats_init();
>>
>> And then the early SWIOTLB initialization for 64MB can fail and we are still OK.
>>>
>
> Yinghai/Konrad,
>
> Did more testing. btw this patch depends on your [v7u1,25/31]
> memblock: add memblock_mem_size(). Here are the test results:
>
> 1. When there is not enough memory: (enough_mem_for_swiotlb() returns false)
> system will panic in amd_iommu_init_dma_ops().
>
> 2. When there is enough memory: (enough_mem_for_swiotlb() returns true):
> swiotlb is reserved
> pci_swiotlb_late_init() leaves the buffer allocated since swiotlb=1
> with that getting changed in amd_iommu_init_dma_ops().
>
> I agree with Konrad that the logic should be wrapped in CONFIG_KEXEC.

If enough_mem_for_swiotlb needs to be conditional on CONFIG_KEXEC the
code is architected wrong.  None of this logic has anything to do with
kexec except that the kexec path is one way to get this condition to
happen.  Especially since the kexec'd kernel where this condition occurs
does not need kexec support built in.

Yinghai I sat down and read your patch and the approach you are taking
is totally wrong.

The problem is that swiotlb_init() in lib/swiotlb.c does not know how to
fail without panic'ing the system.

Which leaves two valid approaches.
- Create a variant of swiotlb_init that can fail for use on x86 and
  handle the failure.
- Delay initializing the swiotlb until someone actually needs a mapping
  from it.  

Delaying the initialization of the swiotlb is out because the code
needs an early memory allocation to get a large chunk of contiguous
memory for the bounce buffers.

Which means the panics that occurr in swiotlb_init() need to be delayed
until someone something actually needs bounce buffers from the swiotlb.

Although arguably what should actually happen instead of panic() is that
swiotlb_map_single should simply fail early when it was not possible to
preallocate bounce buffers.

Eric

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab0DGORS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 10:17:18 -0400
Received: from mail-pz0-f202.google.com ([209.85.222.202]:57157 "EHLO
	mail-pz0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283Ab0DGORR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 10:17:17 -0400
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Apr 2010 10:17:17 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=jSn0C/ll5lj642cj6AjEcTHLoXrJVk7akA/QYBKmfMPemXNxIyZxVrS7Zxa2sAKY2l
         6ona7iHq6WlGeLPoro2kw4iozOxnawDdP/emc5OWYSn9kVHlYOCUla6v5rA75ct34cRf
         FWOuEi+Ct2z0yIpYXbXSXT58G37H4zDimWlaE=
MIME-Version: 1.0
In-Reply-To: <t2yacff6c2b1004062309t89b6bddfy3b0cf5970846fbb0@mail.gmail.com>
References: <l2y5f6c52c61004060737me670f6e2t6071444c4fd1318b@mail.gmail.com>
	 <g2s9ff7a3bc1004060802va38aa361s6abd07e8c992dd56@mail.gmail.com>
	 <4BBB7AC9.5060008@zytor.com>
	 <o2m8f84f9951004061220x16f3aa8by9cf19ec28ea492d7@mail.gmail.com>
	 <4BBB8F07.60401@zytor.com>
	 <w2p9ff7a3bc1004061301v6cc76e1g1e573468b1b8807d@mail.gmail.com>
	 <q2iacff6c2b1004061528t28f1337eq977aabf8fe71bc22@mail.gmail.com>
	 <q2oc58e39921004062208z6410b031o8d5654a582cc2783@mail.gmail.com>
	 <t2yacff6c2b1004062309t89b6bddfy3b0cf5970846fbb0@mail.gmail.com>
Date: Wed, 7 Apr 2010 22:11:30 +0800
X-Google-Sender-Auth: 6aa6d5d43b6e01e1
Message-ID: <y2uc58e39921004070711i37937f4eh4448d8ad4eab0fab@mail.gmail.com>
Subject: Re: why choose 896MB to the start point of ZONE_HIGHMEM
From: tek-life <teklife.kernel@gmail.com>
To: Venkatram Tummala <venkatram867@gmail.com>,
       Zh-Kernel <linux-kernel@zh-kernel.org>, linux-kernel@vger.kernel.org,
       kernelnewbies@nl.linux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Venkatram,

Thanks for your  hot heart and detailed explaination.

Your opinion is just  for the balance with choosing 896MB ?
Then I want to konw wheather is the decision for 896  based on a lot
of  experiments.
I think it is an important things .

Best wishes.

2010/4/7 Venkatram Tummala <venkatram867@gmail.com>
>
> First Of All,
>
> Total Virtual address space of the user process + Virtual address space of the kernel should ALWAYS be equal to 4GB. (on 32-bit)
>
> So, you have to luxury to decide the split between user address space + kernel address space.
>
> Lets the consider the two exterme alternatives to choosing 896MB
>
> First Extreme : You dont want to  choose too less memory for identity mapped segment (eg. 512MB instead of 896MB) because you don't all the addition memory for vmalloc area. As identity mapped segment is 1-1 mapping, finding & accessing the corresponding physical address is easier & faster. You want to have the max. memory possible in this identity mapped segment.
>
> Second Extreme : You dont to choose too high memory either (eg. 960MB instead of 896 MB) because that will leave you with insufficient memory for the vmalloc area.
>
> So, you have to balance the two extremes. Kernel Guys decided that 128MB (1024MB - 896MB) is sufficient for vmalloc area. So, the rest of the address space is 1-1 mapped.
>
> Hope this is clear.
>
> Regards,
> Venkatram Tummala
>
>
>
>
>
>
> On Tue, Apr 6, 2010 at 10:08 PM, tek-life <teklife.kernel@gmail.com> wrote:
>>
>> Thanks for you so detailed answer.
>> But I  am also confused that why don't we choose 64MB physical memory
>> spaces for ZONE_HIGHMEM.
>> It's known that in the initialization of the memory ,kernel will
>> create main page table ,and the kernel use physical address + 3G to
>> map . then the kernel map from 0 to 896MB physical memory spaces to
>> 3G~3G+896MB virtual spaces. why cann't we map 0~512MB to 3G ~ 3G+512MB
>> , and the left (>512MB) is given to ZONE_HIGHMEM for dynamic mapping?
>> The focus is 896MB not others.
>> why choose 896 ? why not 512 or 960 or others?
>>
>> 2010/4/7 Venkatram Tummala <venkatram867@gmail.com>
>> >
>> > Joel,
>> >
>> > To make things clear, 896 MB is not a hardware limitation. The 3GB:1GB split can be configured during the kernel build but the split cannot be changed dynamically.
>> >
>> > you are correct that ZONE_* refers to grouping of physical memory but the very concept of ZONES is logical and not physical.
>> >
>> > Now, why does ZONE_NORMAL has only 896MB on a 32 bit system?
>> >
>> > If you recall the concept of virtual memory, you will remember that its aim is to provide a illusion to the user processes that it has all the theoritical maximum memory possible on that specific architecture, which is 4GB in this case, and that that is only process running on the system. The kernel internally deals with pages, swapping in & out pages to create this illusion. The advantage is that user processes does not have to care about how much physical memory is actually present in the system.
>> >
>> > So, out of this 4GB, it was conceptually decided that 3GB is the process's virtual address space and 1GB is the kernel virtual address space. The kernel maps these 3GB of user processes' virtual address space to physical memory using page tables. The kernel can just address 1GB of virtual addresses. This 1GB of virtual addresses is directly mapped (1-1 mapping) into the physical memory without using page tables. If the kernel wants to address more virtual addresses, it has to kmap the high memory(ZONE_HIGHMEM) which sets up the page tables etc. So, you can imagine this as : "Whenever a context switch occurs, 3GB virtual address space of the previous running process will be replaced by the virtual address space of the newly selected process, and the 1GB always remains with the kernel." Note that all this is virtual (That is, conceptual), this is only an illusion.
>> >
>> > So, out of this 1GB of kernel virtual address space that is 1-1 mapped into the physical memory(without requiring page tables), 0-16MB is used by device drivers, 896MB - 1024MB is used by the kernel for vmalloc, kmap, etc which leaves (16MB - 896MB) and this range is "called" ZONE_NORMAL.
>> >
>> > Giving specific emphasis to the word "called" in the previous sentence.
>> >
>> > In summary, the kernel can only access 896 MB of physical ram because it only has 1GB of virtual address space available out of which the lower 16MB is used for DMA by device drivers and the 896MB-1024MB is used to support kmap, vmalloc etc. And note that this limitation is not because of the hardware but this is because of the conceptualization of the division of virtual address space into user address space & kernel address space.
>> >
>> > For example, you can make the split 2G-2G instead of 3G-1G. So, the kernel can now use 2GB of virtual address space (directly mapped to 2GB of physical memory). You can also make the split 1GB:3GB instead of 3GB:1GB as already explained.
>> >
>> > Hope this clears the confusion.
>> >
>> > Regards,
>> > Venkatram Tummala
>> >
>> >
>> > On Tue, Apr 6, 2010 at 1:01 PM, Joel Fernandes <agnel.joel@gmail.com> wrote:
>> >>
>> >> Hi Peter,
>> >>
>> >> On Wed, Apr 7, 2010 at 1:14 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> >> > On 04/06/2010 12:20 PM, Frank Hu wrote:
>> >> >>>
>> >> >>> The ELF ABI specifies that user space has 3 GB available to it.  That
>> >> >>> leaves 1 GB for the kernel.  The kernel, by default, uses 128 MB for I/O
>> >> >>> mapping, vmalloc, and kmap support, which leaves 896 MB for LOWMEM.
>> >> >>>
>> >> >>> All of these boundaries are configurable; with PAE enabled the user
>> >> >>> space boundary has to be on a 1 GB boundary.
>> >> >>>
>> >> >>
>> >> >> the VM split is also configurable when building the kernel (for 32-bit
>> >> >> processors).
>> >> >
>> >> > I did say "all these boundaries are configurable".  Rather explicitly.
>> >> >
>> >>
>> >> I thought the 896 MB was a hardware limitation on 32 bit architectures
>> >> and something that cannot be configured? Or am I missing something
>> >> here? Also the vm-splits refer to "virtual memory" . While ZONE_* and
>> >> the 896MB we were discussing refers to "physical memory". How then is
>> >> discussing about vm splits pertinent here?
>> >>
>> >> Thanks,
>> >> -Joel
>> >>
>> >> --
>> >> To unsubscribe from this list: send an email with
>> >> "unsubscribe kernelnewbies" to ecartis@nl.linux.org
>> >> Please read the FAQ at http://kernelnewbies.org/FAQ
>> >>
>> >
>>
>

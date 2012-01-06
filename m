Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab2AFCMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 21:12:12 -0500
Received: from smtp2.ustc.edu.cn ([202.38.64.46]:32967 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758531Ab2AFCMG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 21:12:06 -0500
MIME-Version: 1.0
In-Reply-To: <4F05F073.2050209@redhat.com>
References: <CAJULonj9rFDKNCzpEXj2r3XjkYojy-CGYpVQ1RF8SxwLVrXqAA@mail.gmail.com>
	<20120103203357.GD17472@phenom.dumpdata.com>
	<CAJULongKix3QXmcoUcraQxCyLN0wz6oe6p5Efg2A7S_r3nO6Fg@mail.gmail.com>
	<1325692766.2758.22.camel@dabdike.int.hansenpartnership.com>
	<CAJULoniAdLbyNUyrCYWbxOWAdB-Re-BxSNb0xfuFD8w6pDETWA@mail.gmail.com>
	<4F05F073.2050209@redhat.com>
Date: Fri, 6 Jan 2012 10:11:58 +0800
Message-ID: <CAJULonggD94tzTvhO-7A0w-Sji07su8wLEvj15xto=rxyjW3Qg@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E3=80=90Question=E3=80=91Whether_it=27s_legal_to_enable_same_?=
	=?UTF-8?Q?physical_DMA_memory_mapped_for_different_NIC_device=3F?=
From: Yanfei Wang <backyes@mail.ustc.edu.cn>
To: Don Dutile <ddutile@redhat.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-CM-TRANSID: yia_0ZCrUwVvWAZPQFSJAA--.27505S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3WrW7ZFW7uFWkAFWUKFW3Jrb_yoW7WF4fpa
	y8tFy7Krs5Gr10yw40vw1fAFyUtws5JF4rW3s8Awn2kws0gF1YqrW7tr45ua47WF1UG3W0
	qFyUZa4xWa4UZaDanT9S1TB71UUUUUJv73VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UU
	Un47k042IE4IxYO2xFxVAqjxCEw4Av424lb7IF0VCFvT92vfvE14ylb7Iv0xC_KF4lb4IE
	77IF4wAFxVCF77xC6IxKo4kEV4yl1I0EscIYIxCEI4klw4CSwwAajcAI6xAYOVAKp-VFvr
	4ln7xl0VCFbcvEwTZvWa45M2kKe7AKxVWUXVWUAwAawVACjsI_Ar4v6c8GOVW06r1DJrWU
	AwAawVACjsI_Ar4v6c8GOVWY6r1DJrWUAwAa7VCY0VAaVVAqrcv_Jw1UWr13Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWr
	XVW3AwAv7VC2z280aVAFwI0_Gr1j6F4UJwCY1Ik267vv6cIUMxAIw28IcxkI7VAKI48JMx
	AIw28IcVCjz48v1sIEY20_GrWl4IxYO2xFxVAFwI0_JF0_Jw1l4IxY628EI7kG0VAYaI8x
	MxCIbVAxMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr4UvcSsGvfC2KfnxnUUI43
	ZEXa7IU0ySoJUUUUU==
X-CM-SenderInfo: 5edfy51hv6zt1loo32lwfovvfxof0/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 6, 2012 at 2:48 AM, Don Dutile <ddutile@redhat.com> wrote:
> On 01/05/2012 07:40 AM, Yanfei Wang wrote:
>>
>> On Wed, Jan 4, 2012 at 11:59 PM, James Bottomley
>> <James.Bottomley@hansenpartnership.com>  wrote:
>>>
>>> On Wed, 2012-01-04 at 10:44 +0800, Yanfei Wang wrote:
>>>>
>>>> On Wed, Jan 4, 2012 at 4:33 AM, Konrad Rzeszutek Wilk
>>>> <konrad.wilk@oracle.com>  wrote:
>>>>>
>>>>> On Wed, Dec 07, 2011 at 10:16:40PM +0800, ustc.mail wrote:
>>>>>>
>>>>>> Dear all,
>>>>>>
>>>>>> In NIC driver, to eliminate the  overhead of dma_map_single() for DMA
>>>>>> packet data,  we have statically allocated huge DMA memory buffer ring
>>>>>> at once instead of calling dma_map_single() per packet.  Considering
>>>>>> to further reduce the copy overhead between different NIC(port) ring
>>>>>> while forwarding, one packet from a input NIC(port) will be
>>>>>> transferred to output NIC(port) with no any copy action.
>>>>>>
>>>>>> To satisfy this requirement, the packet memory should be mapped into
>>>>>> input port and unmapped when leaving input port, then mapped into
>>>>>> output port and unmapped later.
>>>>>>
>>>>>> Whether it's legal to map the same DMA memory into input and output
>>>>>> port simultaneously? If it's not, then the zero-copy for packet
>>>>>> forwarding is not feasible?
>>>>>>
>>>>>
>>>>> Did you ever a get a response about this?
>>>>
>>>> No.
>>>
>>>
>>> This is probably because no-one really understands what you're asking.
>>> As far as mapping memory to PCI devices goes, it's the job of the bridge
>>> (or the iommu which may or may not be part of the bridge).  A standard
>>> iommu tends not to care about devices and functions, so a range once
>>> mapped is available to everything behind the bridge.  A more secure
>>> virtualisation based iommu (like the on in VT-D) does, and tends to map
>>> ranges per device.  I know of none that map per device and function, but
>>> maybe there are.
>>>
>>> Your question reads like you have a range of memory mapped to a PCI
>>> device that you want to use for two different purposes, can you do this?
>>> to which the answer is that a standard PCI bridge really doesn't care
>>> and it all depends on the mechanics of the actual device.  The only
>>> wrinkle might be if the two different purposes are on two separate PCI
>>> functions of the device and the iommu does care.
>>>
>>>>>
>>>>> Is the output/input port on a seperate device function? Or is it
>>>>> just a specific MMIO BAR in your PCI device?
>>>>>
>>>> Platform: x86, intel nehalem 8Core NUMA, linux 2.6.39, 10G
>>>> 82599NIC(two ports per NIC card);
>>>> Function: Forwarding packets between different ports.
>>>> Targets: Forwarding packets with Zero-Overhead, despite other obstacles.
>>
>> Besides hardware and OS presented above, more detailed descriptions as
>> follows,
>>
>> When IXGBE driver do initialization, DMA Descriptors Ring Buffers are
>> allocated statically and mapped as cache coherent. Instead of
>> dynamically allocating skb buffers for packet data, to reduce the huge
>> overhead from skb memory allocation, huge Packet data buffers are
>> pre-allocated and mapped  when driver is loaded. The same strategy  is
>> done for RX end and TX end.
>> For simple packet forwarding application, one packet from RX should be
>> replicated from kernel space to userspace, then copied TX end. Here,
>> One packet at least, should be copied twice to accomplish forwarding.
>> When doing high performance network application,  the copy action want
>> to be reduced. If Zero-copy can be done, that's better. (May be you
>> will find that Zero-copy will bring other obstacles, such as memory
>> management overhead with high performance. We do not care about it
>> temporally.)
>> To achieve this goal, a alternative approach is that,  unmapping the
>> packets buffer after receiving it from A device, then mapping this
>> packet buffer to B device. We hope to reduce the two mapping
>> operation, so one packet DMA buffer should be mapped to A device(NIC
>> port) as well as B device simultaneously.
>> Q: Can this come to ture? Is it legal for mmaping operation at this
>> platform?
>>
>> Thanks.
>>
>> Yanfei
>>
>>
> not if the two different devices (82599 VFs or PFs) are in different domains
> (assigned to different ((kvm; Konrad:xen?) virtualization guests).
> otherwise, I don't see why two devices can't have the same memory page
> mapped for DMA use -- a mere matter of multi-device, shared memory
> utilization! ;-)
>
OS is based on directly hardware, no kvm, xen, VT, exsit. That's to
say, it's legal to map same physical DMA buffer into different  PCIe
functions(devices) to eliminate the per-packet-map action.

Thanks
>
>>>
>>> This still doesn't really provide the information needed to elucidate
>>> the question.
>>>
>>> James
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>>
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506Ab2AFCFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 21:05:53 -0500
Received: from smtp2.ustc.edu.cn ([202.38.64.46]:39151 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758437Ab2AFCFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 21:05:51 -0500
MIME-Version: 1.0
In-Reply-To: <1325780417.2775.6.camel@dabdike.Larkspurhotels.com>
References: <CAJULonj9rFDKNCzpEXj2r3XjkYojy-CGYpVQ1RF8SxwLVrXqAA@mail.gmail.com>
	<20120103203357.GD17472@phenom.dumpdata.com>
	<CAJULongKix3QXmcoUcraQxCyLN0wz6oe6p5Efg2A7S_r3nO6Fg@mail.gmail.com>
	<1325692766.2758.22.camel@dabdike.int.hansenpartnership.com>
	<CAJULoniAdLbyNUyrCYWbxOWAdB-Re-BxSNb0xfuFD8w6pDETWA@mail.gmail.com>
	<1325780417.2775.6.camel@dabdike.Larkspurhotels.com>
Date: Fri, 6 Jan 2012 10:05:42 +0800
Message-ID: <CAJULonhqBMLFRLLizhVB1SxR=sWUPTTHFu2=KhEX2sf2GFdV0g@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E3=80=90Question=E3=80=91Whether_it=27s_legal_to_enable_same_?=
	=?UTF-8?Q?physical_DMA_memory_mapped_for_different_NIC_device=3F?=
From: Yanfei Wang <backyes@mail.ustc.edu.cn>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, linux-pci@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-CM-TRANSID: yia_0ZCbBAr3VgZPQFSJAA--.26221S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxtFWxGr13GF1xJF1xAFyUAwb_yoW7GF18pa
	yrKFy7Kws5Wr10yw4vvw1fJr1jkan5Ja1rX3s8A3s2kwn0gF90qryUtr45ua4xWFy8J3W0
	qFyUZFyfWF1UAaDanT9S1TB71UUUUUDv73VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UU
	U0A7k042IE4IxYO2xFxVAqjxCEw4Av424lb7IF0VCFvT92vfvE14ylb7Iv0xC_tr1lb4IE
	77IF4wAFxVCF77xC6IxKo4kEV4yl1I0EscIYIxCEI4klw4CSwwAajcAI6xAYOVAKp-VFvr
	4ln7xl0VCFbcvEwTZvWa45M2kK64x0aVW7GwIE548m6rI_Jw1UWr17M2kK64x0aVW7GwIE
	548m6rv_Jw1UWr17M2vj6xkI62vS6c8GOVWUtr1rJFyl57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv
	67AKxVW8Jr0_Cr1UMxkFs20EbsIEYx1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaV
	Av8VW8WwCFI7vE84CIb48I67vvx24l4IxY624lx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrbIYCTnIWIevJa73UjIFyTuYvjxU20eHDUUUU
X-CM-SenderInfo: 5edfy51hv6zt1loo32lwfovvfxof0/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 6, 2012 at 12:20 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2012-01-05 at 20:40 +0800, Yanfei Wang wrote:
>> On Wed, Jan 4, 2012 at 11:59 PM, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>> > On Wed, 2012-01-04 at 10:44 +0800, Yanfei Wang wrote:
>> >> On Wed, Jan 4, 2012 at 4:33 AM, Konrad Rzeszutek Wilk
>> >> <konrad.wilk@oracle.com> wrote:
>> >> > On Wed, Dec 07, 2011 at 10:16:40PM +0800, ustc.mail wrote:
>> >> >> Dear all,
>> >> >>
>> >> >> In NIC driver, to eliminate the  overhead of dma_map_single() for DMA
>> >> >> packet data,  we have statically allocated huge DMA memory buffer ring
>> >> >> at once instead of calling dma_map_single() per packet.  Considering
>> >> >> to further reduce the copy overhead between different NIC(port) ring
>> >> >> while forwarding, one packet from a input NIC(port) will be
>> >> >> transferred to output NIC(port) with no any copy action.
>> >> >>
>> >> >> To satisfy this requirement, the packet memory should be mapped into
>> >> >> input port and unmapped when leaving input port, then mapped into
>> >> >> output port and unmapped later.
>> >> >>
>> >> >> Whether it's legal to map the same DMA memory into input and output
>> >> >> port simultaneously? If it's not, then the zero-copy for packet
>> >> >> forwarding is not feasible?
>> >> >>
>> >> >
>> >> > Did you ever a get a response about this?
>> >> No.
>> >
>> > This is probably because no-one really understands what you're asking.
>> > As far as mapping memory to PCI devices goes, it's the job of the bridge
>> > (or the iommu which may or may not be part of the bridge).  A standard
>> > iommu tends not to care about devices and functions, so a range once
>> > mapped is available to everything behind the bridge.  A more secure
>> > virtualisation based iommu (like the on in VT-D) does, and tends to map
>> > ranges per device.  I know of none that map per device and function, but
>> > maybe there are.
>> >
>> > Your question reads like you have a range of memory mapped to a PCI
>> > device that you want to use for two different purposes, can you do this?
>> > to which the answer is that a standard PCI bridge really doesn't care
>> > and it all depends on the mechanics of the actual device.  The only
>> > wrinkle might be if the two different purposes are on two separate PCI
>> > functions of the device and the iommu does care.
>> >
>> >> >
>> >> > Is the output/input port on a seperate device function? Or is it
>> >> > just a specific MMIO BAR in your PCI device?
>> >> >
>> >> Platform: x86, intel nehalem 8Core NUMA, linux 2.6.39, 10G
>> >> 82599NIC(two ports per NIC card);
>> >> Function: Forwarding packets between different ports.
>> >> Targets: Forwarding packets with Zero-Overhead, despite other obstacles.
>> Besides hardware and OS presented above, more detailed descriptions as follows,
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
>> Q: Can this come to ture? Is it legal for mmaping operation at this platform?
>
> But you still haven't answered the question upon which all this depends.
> Let me make it simple.  In PCI terms are A and B
>
>     I. Same Device, Same Function
>    II. Same Device, Different Function
>   III. Different Devices
$lspci
09:00.0 Ethernet controller: Intel Corporation 82599EB 10-Gigabit
Network Connection (rev 01)
09:00.1 Ethernet controller: Intel Corporation 82599EB 10-Gigabit
Network Connection (rev 01)
Here, only one physical 10G NIC device, which contains two 10G ports.
So, the information list above shows that one port correspond one
function.
If forwarding packet between two ports, then A,B are different functions.
Otherwise, A,B are different devices if forwarding packets between two
physical NIC device. Is it right?
The OS is built on bare-metal hardware, no kvm, no xen, no VT.

Thanks.
>
> ?
>
> James
>
>


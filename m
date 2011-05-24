Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab1EXKXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 06:23:12 -0400
Received: from ns5.dns-guards.com ([41.203.20.164]:46549 "EHLO
	velocity.dns-guards.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab1EXKXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 06:23:10 -0400
Message-ID: <sig.6125c0d242.4DDB86FE.5090809@radicalsystems.co.za>
Date: Tue, 24 May 2011 12:22:54 +0200
From: Jan Zwiegers <jan@radicalsystems.co.za>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Xianghua Xiao <xiaoxianghua@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PCI BAR1 Unassigned
References: <4DD5452F.9050108@radicalsystems.co.za> <BANLkTi=g=fKaXF4uwwjLSX-R+pk0FUa6OQ@mail.gmail.com> <sig.512079e334.4DD57D44.50009@radicalsystems.co.za> <BANLkTikHQNQdWoDS2dXUC9gTPWvtmUM=yA@mail.gmail.com> <sig.51214cae32.4DD61B48.8010601@radicalsystems.co.za> <BANLkTi=jTKp9+_KDmTxYfGXe6Ln02GLmDA@mail.gmail.com>
In-Reply-To: <BANLkTi=jTKp9+_KDmTxYfGXe6Ln02GLmDA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-ID: velocity.dns-guards.com ()
X-Assp-Version: 1.7.1.3(1.0.2)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - velocity.dns-guards.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - radicalsystems.co.za
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-20 04:53 PM, Bjorn Helgaas wrote:
> On Fri, May 20, 2011 at 1:42 AM, Jan Zwiegers<jan@radicalsystems.co.za>  wrote:
>> On 2011-05-19 10:50 PM, Xianghua Xiao wrote:
>>>
>>> On Thu, May 19, 2011 at 3:27 PM, Jan Zwiegers<jan@radicalsystems.co.za>
>>>   wrote:
>>>>
>>>> On 2011-05-19 08:50 PM, Bjorn Helgaas wrote:
>>>>>
>>>>> On Thu, May 19, 2011 at 10:28 AM, Jan Zwiegers<jan@radicalsystems.co.za>
>>>>>   wrote:
>>>>>>
>>>>>> I have the problem below where my PCI card's second BAR does not get
>>>>>> assigned.
>>>>>> What can be the cause of this problem?
>>>>>> The last kernel I tested on which worked OK was 2.6.27.
>>>>>> My current problematic kernel 2.6.35.
>>>>>>
>>>>>> 05:01.0 Unassigned class [ff00]: Eagle Technology PCI-703 Analog I/O
>>>>>> Card
>>>>>> (rev 5c)
>>>>>>     Flags: bus master, slow devsel, latency 32, IRQ 22
>>>>>>     Memory at 93b00000 (type 3, prefetchable) [size=2K]
>>>>>>     Memory at<unassigned>      (type 3, prefetchable)
>>>>>>     Capabilities: [80] #00 [0600]
>>>>>>     Kernel modules: pci703drv
>>>>>
>>>>> Could be resource exhaustion or, more likely, we ran out because we
>>>>> now assign resource to things that don't need them, leaving none for
>>>>> things that *do* need them.  This sounds like a regression, so we
>>>>> should open a bugzilla for it and attach dmesg logs from 2.6.27 and
>>>>> 2.6.35.
>>>>>
>>>>> Does this problem keep the driver from working?  (Sometimes drivers
>>>>> don't actually use all the BARs a device supports.)
>>>>>
>>>>> Bjorn
>>>>>
>>>>
>>>> I'm the maintainer of the driver and was involved in the development of
>>>> the
>>>> board as well in 2003. The board uses two BARS and the second BAR is the
>>>> most important. The board worked fine since the 2.4 days and only
>>>> recently
>>>> became problematic. I suspect it works on even later kernels than 27,
>>>> maybe
>>>> 2.6.32.
>>>>
>>>> My knowledge is too little to actually determine if the problem is
>>>> because
>>>> the FPGA based PCI interface is not within spec or something that changed
>>>> in
>>>> the kernel, because of the post .30 releases becoming more strict to PCI
>>>> specification, i.e. BIOS / Kernel interaction.
>>>>
>>>> Jan
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>> What's the size for BAR1? one reason is that no more space to
>>> align/allocate BAR1.
>>>
>>> If the board stays the same then your FPGA might be the cause, I have
>>> seen similar issues and they ended up in FPGA implementation.
>>>
>>
>> I have submitted the difference in iomem, lspci and dmesg of 2.6.27&  2.6.35
>> kernels from the same machine. The BAR size is 2K. As above BAR0 is at
>> 93b0000 and BAR1 should be at 93b00800.
>
> Thanks for the data.
>
> I think your FPGA is "unusual" after all.  lspci says this:
>
>    05:01.0 Unassigned class [ff00]: Eagle Technology PCI-703 Analog I/O
> Card (rev 5c)
>         Flags: bus master, slow devsel, latency 32, IRQ 22
>         Memory at 93b00000 (type 3, prefetchable) [size=2K]
>         Memory at<unassigned>  (type 3, prefetchable)
>
> The "type 3" means the BAR has both type bits set (bits 1 and 2).  The
> spec (PCI 3.0 sec 6.2.5.1) says the type field means:
>
>    00 - Locate anywhere in 32-bit access space
>    01 - Reserved
>    10 - Locate anywhere in 64-bit access space
>    11 - Reserved
>
> I think your BARs are using the "11 - Reserved" setting when they
> should be "00".  The way Linux handles this did change between 2.6.27
> and 2.6.35, and I think the change was unintentional, so we might
> consider changing it back.
>
> Commit e354597cce8d219d made this change to decode_bar():
>
>            res->flags = bar&  ~PCI_BASE_ADDRESS_MEM_MASK;
>
>    -       if (res->flags == PCI_BASE_ADDRESS_MEM_TYPE_64)
>    +       if (res->flags&  PCI_BASE_ADDRESS_MEM_TYPE_64)
>                    return pci_bar_mem64;
>            return pci_bar_mem32;
>
> In 2.6.27, we treated the BAR as 64-bit only if the low four bits were
> 0100 (non-prefetchable, 64-bit type, memory).  That was incorrect,
> because we should ignore the prefetchable bit.  The fix was to look
> *only* at bit 2, so now we decide the BAR is 64-bit if the low four
> bits are x1xx.
>
> Your BARs contain 1110 in the low four bits.  This is invalid but was
> treated as 32-bit by 2.6.27 and as 64-bit by 2.6.35.
>
> Here's an untested Linux change I think we might consider making to
> restore the previous behavior.  Can you try it (gmail will probably
> mangle it, so you'll have to apply it by hand)?
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 44cbbba..33894ba 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -138,15 +138,20 @@ static u64 pci_size(u64 base, u64 maxbase, u64 mask)
>
>   static inline enum pci_bar_type decode_bar(struct resource *res, u32 bar)
>   {
> +       u32 mem_type;
> +
>          if ((bar&  PCI_BASE_ADDRESS_SPACE) == PCI_BASE_ADDRESS_SPACE_IO) {
>                  res->flags = bar&  ~PCI_BASE_ADDRESS_IO_MASK;
>                  return pci_bar_io;
>          }
>
> -       res->flags = bar&  ~PCI_BASE_ADDRESS_MEM_MASK;
> +       res->flags = bar&  PCI_BASE_ADDRESS_MEM_PREFETCH;
>
> -       if (res->flags&  PCI_BASE_ADDRESS_MEM_TYPE_64)
> +       mem_type = bar&  PCI_BASE_ADDRESS_MEM_TYPE_MASK;
> +       if (mem_type == PCI_BASE_ADDRESS_MEM_TYPE_64) {
> +               res->flags |= PCI_BASE_ADDRESS_MEM_TYPE_64;
>                  return pci_bar_mem64;
> +       }
>          return pci_bar_mem32;
>   }
>

Hi Bjorn

I have tested your suggested implementation and this definitely solved 
my problem. Both of my BARs are now mapped as they should.

Please indicate if the changed will be reverted. In the meantime I will 
try and get this corrected in newer versions of the Eagle Technology 
PCI703 FPGA's.

Thanks again for the help.
Jan



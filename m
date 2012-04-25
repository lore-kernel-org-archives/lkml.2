Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab2DYSRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:17:20 -0400
Received: from mail1.windriver.com ([147.11.146.13]:38407 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab2DYSRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:17:19 -0400
Message-ID: <4F983FA9.5040301@windriver.com>
Date: Wed, 25 Apr 2012 14:17:13 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] pci: frv architecture needs generic setup-bus infrastructure
References: <1334784254-17603-1-git-send-email-paul.gortmaker@windriver.com> <CAErSpo4t2USorOiSMs99UQ_JPyhnz=FKfF=R5twhepDMPVH5oQ@mail.gmail.com> <4F95CB3E.6070504@windriver.com> <CAErSpo7rsqtPEBsS4VzFYX+AGYXDYv2+MzR023=VqEqrzTtanA@mail.gmail.com>
In-Reply-To: <CAErSpo7rsqtPEBsS4VzFYX+AGYXDYv2+MzR023=VqEqrzTtanA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-04-25 12:12 PM, Bjorn Helgaas wrote:
> On Mon, Apr 23, 2012 at 3:35 PM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
>> On 12-04-23 04:38 PM, Bjorn Helgaas wrote:
>>> On Wed, Apr 18, 2012 at 3:24 PM, Paul Gortmaker
>>> <paul.gortmaker@windriver.com> wrote:
>>>> Otherwise we get this link failure for frv's defconfig:
>>>>
>>>>   LD      .tmp_vmlinux1
>>>>  drivers/built-in.o: In function `pci_assign_resource':
>>>>  (.text+0xbf0c): undefined reference to `pci_cardbus_resource_alignment'
>>>>  drivers/built-in.o: In function `pci_setup':
>>>>  pci.c:(.init.text+0x174): undefined reference to `pci_realloc_get_opt'
>>>>  pci.c:(.init.text+0x1a0): undefined reference to `pci_realloc_get_opt'
>>>>  make[1]: *** [.tmp_vmlinux1] Error 1
>>>>
>>>> Cc: Bjorn Helgaas <bhelgaas@google.com>
> 
> This looks good to me, and if you'd put it in your queue, that'd be
> great.  It won't break any other arches, so I'm fine with it going in
> either for 3.4 or in the 3.5 merge window.
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Thanks, I'll queue it up for the 3.4 pull

Paul.
--

> 
>>>> Cc: David Howells <dhowells@redhat.com>
>>>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>>>>
>>>> diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
>>>> index 083a49f..165274c 100644
>>>> --- a/drivers/pci/Makefile
>>>> +++ b/drivers/pci/Makefile
>>>> @@ -42,6 +42,7 @@ obj-$(CONFIG_UNICORE32) += setup-bus.o setup-irq.o
>>>>  obj-$(CONFIG_PARISC) += setup-bus.o
>>>>  obj-$(CONFIG_SUPERH) += setup-bus.o setup-irq.o
>>>>  obj-$(CONFIG_PPC) += setup-bus.o
>>>> +obj-$(CONFIG_FRV) += setup-bus.o
>>>>  obj-$(CONFIG_MIPS) += setup-bus.o setup-irq.o
>>>>  obj-$(CONFIG_X86_VISWS) += setup-irq.o
>>>>  obj-$(CONFIG_MN10300) += setup-bus.o
>>>
>>> Wow, I didn't even realize that we had this sort of arch-specific
>>> selection of generic PCI parts.  drivers/pci/setup-irq.c is on my list
>>> for reworking because it looks like it doesn't work correctly for
>>> hotplug.  setup-bus.c is much more complicated, but (a) it looks like
>>> most architectures include it anyway, and (b) it seems like it'd be
>>> cleaner to have a CONFIG_PCI_REALLOC or something to avoid having
>>> arch-specific stuff in the Makefile.
>>>
>>> Anyway, that's all for the future.  Does this fix need to go in 3.4,
>>> or should it go in -next?  What commit introduced the problem?
>>
>> It does address a compile fail seen in 3.4 (sorry for not calling
>> that out explicitly).  I've not dug back in time to see when it
>> 1st appeared.  With a lot of these less common arch, it seems they
>> can get broken and remain broken for quite some time, so the original
>> breakage may predate the 3.4 merge window.
>>
>> I've already got a queue with fixes for 3.4 in various other
>> less common arch; it is no trouble for me to carry this there,
>> if you are OK with it as a 3.4 fix.
>>
>> Thanks,
>> Paul.
>> --
>>
>>>
>>> Bjorn

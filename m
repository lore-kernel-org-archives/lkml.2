Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab2DYQNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:13:22 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48227 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363Ab2DYQNU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:13:20 -0400
MIME-Version: 1.0
In-Reply-To: <4F95CB3E.6070504@windriver.com>
References: <1334784254-17603-1-git-send-email-paul.gortmaker@windriver.com>
 <CAErSpo4t2USorOiSMs99UQ_JPyhnz=FKfF=R5twhepDMPVH5oQ@mail.gmail.com> <4F95CB3E.6070504@windriver.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 25 Apr 2012 10:12:58 -0600
Message-ID: <CAErSpo7rsqtPEBsS4VzFYX+AGYXDYv2+MzR023=VqEqrzTtanA@mail.gmail.com>
Subject: Re: [PATCH] pci: frv architecture needs generic setup-bus infrastructure
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 3:35 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> On 12-04-23 04:38 PM, Bjorn Helgaas wrote:
>> On Wed, Apr 18, 2012 at 3:24 PM, Paul Gortmaker
>> <paul.gortmaker@windriver.com> wrote:
>>> Otherwise we get this link failure for frv's defconfig:
>>>
>>>   LD      .tmp_vmlinux1
>>>  drivers/built-in.o: In function `pci_assign_resource':
>>>  (.text+0xbf0c): undefined reference to `pci_cardbus_resource_alignment'
>>>  drivers/built-in.o: In function `pci_setup':
>>>  pci.c:(.init.text+0x174): undefined reference to `pci_realloc_get_opt'
>>>  pci.c:(.init.text+0x1a0): undefined reference to `pci_realloc_get_opt'
>>>  make[1]: *** [.tmp_vmlinux1] Error 1
>>>
>>> Cc: Bjorn Helgaas <bhelgaas@google.com>

This looks good to me, and if you'd put it in your queue, that'd be
great.  It won't break any other arches, so I'm fine with it going in
either for 3.4 or in the 3.5 merge window.

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

>>> Cc: David Howells <dhowells@redhat.com>
>>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>>>
>>> diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
>>> index 083a49f..165274c 100644
>>> --- a/drivers/pci/Makefile
>>> +++ b/drivers/pci/Makefile
>>> @@ -42,6 +42,7 @@ obj-$(CONFIG_UNICORE32) += setup-bus.o setup-irq.o
>>>  obj-$(CONFIG_PARISC) += setup-bus.o
>>>  obj-$(CONFIG_SUPERH) += setup-bus.o setup-irq.o
>>>  obj-$(CONFIG_PPC) += setup-bus.o
>>> +obj-$(CONFIG_FRV) += setup-bus.o
>>>  obj-$(CONFIG_MIPS) += setup-bus.o setup-irq.o
>>>  obj-$(CONFIG_X86_VISWS) += setup-irq.o
>>>  obj-$(CONFIG_MN10300) += setup-bus.o
>>
>> Wow, I didn't even realize that we had this sort of arch-specific
>> selection of generic PCI parts.  drivers/pci/setup-irq.c is on my list
>> for reworking because it looks like it doesn't work correctly for
>> hotplug.  setup-bus.c is much more complicated, but (a) it looks like
>> most architectures include it anyway, and (b) it seems like it'd be
>> cleaner to have a CONFIG_PCI_REALLOC or something to avoid having
>> arch-specific stuff in the Makefile.
>>
>> Anyway, that's all for the future.  Does this fix need to go in 3.4,
>> or should it go in -next?  What commit introduced the problem?
>
> It does address a compile fail seen in 3.4 (sorry for not calling
> that out explicitly).  I've not dug back in time to see when it
> 1st appeared.  With a lot of these less common arch, it seems they
> can get broken and remain broken for quite some time, so the original
> breakage may predate the 3.4 merge window.
>
> I've already got a queue with fixes for 3.4 in various other
> less common arch; it is no trouble for me to carry this there,
> if you are OK with it as a 3.4 fix.
>
> Thanks,
> Paul.
> --
>
>>
>> Bjorn

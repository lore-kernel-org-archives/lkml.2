Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab2KIRhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:37:42 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64681 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2KIRhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:37:39 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo7i+pZoPZWdJOLfJ4xJzs1NRVEmk1-N-NL+xK65coFZiA@mail.gmail.com>
References: <000001cdbe47$48f5dbc0$dae19340$%han@samsung.com>
	<CAErSpo7i+pZoPZWdJOLfJ4xJzs1NRVEmk1-N-NL+xK65coFZiA@mail.gmail.com>
Date: Fri, 9 Nov 2012 12:37:38 -0500
Message-ID: <CADnq5_NWNjsowbPRxiL0cA6XJ_5uZYKO-OfYMZu_NxYeg7s0yA@mail.gmail.com>
Subject: Re: [PATCH] PCI: Fix bit definitions of PCI_EXP_LNKCAP2 register
From: Alex Deucher <alexdeucher@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jingoo Han <jg1.han@samsung.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 12:15 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Thu, Nov 8, 2012 at 11:56 PM, Jingoo Han <jg1.han@samsung.com> wrote:
>> According to the PCIe 3.0 spec, PCI_EXP_LNKCAP2_SLS_2_5GB is
>> 1st bit of PCI_EXP_LNKCAP2 register, not 0th bit. So, the bit
>> definition of supported link speed vector should be fixed.
>>
>> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
>> ---
>>  include/uapi/linux/pci_regs.h |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
>> index 20ae747..14a3184 100644
>> --- a/include/uapi/linux/pci_regs.h
>> +++ b/include/uapi/linux/pci_regs.h
>> @@ -544,9 +544,9 @@
>>  #define  PCI_EXP_OBFF_WAKE_EN  0x6000  /* OBFF using WAKE# signaling */
>>  #define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2 44      /* v2 endpoints end here */
>>  #define PCI_EXP_LNKCAP2                44      /* Link Capability 2 */
>> -#define  PCI_EXP_LNKCAP2_SLS_2_5GB 0x01        /* Current Link Speed 2.5GT/s */
>> -#define  PCI_EXP_LNKCAP2_SLS_5_0GB 0x02        /* Current Link Speed 5.0GT/s */
>> -#define  PCI_EXP_LNKCAP2_SLS_8_0GB 0x04        /* Current Link Speed 8.0GT/s */
>> +#define  PCI_EXP_LNKCAP2_SLS_2_5GB 0x02        /* Current Link Speed 2.5GT/s */
>> +#define  PCI_EXP_LNKCAP2_SLS_5_0GB 0x04        /* Current Link Speed 5.0GT/s */
>> +#define  PCI_EXP_LNKCAP2_SLS_8_0GB 0x08        /* Current Link Speed 8.0GT/s */
>>  #define  PCI_EXP_LNKCAP2_CROSSLINK 0x100 /* Crosslink supported */
>>  #define PCI_EXP_LNKCTL2                48      /* Link Control 2 */
>>  #define PCI_EXP_LNKSTA2                50      /* Link Status 2 */
>
> I think this patch is correct, per spec sec 7.8.18.  If I apply it, I
> think the comments should also be changed to "Supported Link Speed"
> instead of "Current."

Correct.

>
> The only in-tree user of these symbols is
> drm_pcie_get_speed_cap_mask().  Dave, can you ack/nack this?  I don't
> want to apply this if it's going to break something there.

The patch is fine and shouldn't break anything.

Alex

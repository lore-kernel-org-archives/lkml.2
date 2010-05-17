Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab0EQREa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 13:04:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38319 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391Ab0EQRE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 13:04:29 -0400
Message-ID: <4BF17704.9030805@zytor.com>
Date: Mon, 17 May 2010 10:04:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 1/8] x86/mrst/pci: return 0 for non-present pci bars
References: <1273873281-17489-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273873281-17489-2-git-send-email-jacob.jun.pan@linux.intel.com> <201005171058.07020.bjorn.helgaas@hp.com>
In-Reply-To: <201005171058.07020.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2010 09:58 AM, Bjorn Helgaas wrote:
> On Friday, May 14, 2010 03:41:14 pm Jacob Pan wrote:
>> Moorestown PCI code has special handling of devices with fixed BARs. In
>> case of BAR sizing writes, we need to update the fake PCI MMCFG space with real
>> size decode value.
>>
>> When a BAR is not present, we need to return 0 instead of ~0. ~0 will be
>> treated as device error per bugzilla 12006.
> 
> It would be more convenient if you included the URL,
> https://bugzilla.kernel.org/show_bug.cgi?id=12006,
> rather than just the bugzilla number.
> 
> You probably noticed already, but we reverted the patch I
> proposed in 12006 because it was too aggressive, so you may
> not need this patch for that reason.
> 
> Per 6.2.5.1 in the PCI 3.0 spec, "unimplemented Base Address
> registers are hardwired to zero," so it would make sense to me
> to follow that, but your patch affects the *write* path, not
> the read path, so I don't know how it's related to what
> __pci_read_base() will see when it reads the BAR.
> 

Very simple... these device headers are really just data structures in
RAM, so what is written is what is read.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab2JBQpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:45:33 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:59994 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2JBQpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:45:30 -0400
Message-ID: <506B1A26.2060609@pobox.com>
Date: Tue, 02 Oct 2012 12:45:26 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Matthew Wilcox <willy@linux.intel.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v3 -tip 5/5] AHCI: Support multiple MSIs
References: <cover.1349074231.git.agordeev@redhat.com> <cc6441a31a2c600ad9ae33e7715de65b8d46a66f.1349074231.git.agordeev@redhat.com> <20121002050929.GD7756@gmail.com> <20121002164220.GB2258@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20121002164220.GB2258@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2012 12:42 PM, Alexander Gordeev wrote:
> On Tue, Oct 02, 2012 at 07:09:29AM +0200, Ingo Molnar wrote:
>>> +irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance)
>>> +{
>>> +	struct ata_port *ap_this = dev_instance;
>>> +	struct ahci_port_priv *pp = ap_this->private_data;
>>> +	struct ata_host *host = ap_this->host;
>>> +	struct ahci_host_priv *hpriv = host->private_data;
>>> +	void __iomem *mmio = hpriv->mmio;
>>> +	unsigned int i;
>>> +	u32 irq_stat, irq_masked;
>>> +
>>> +	VPRINTK("ENTER\n");
>>
>> Is this per IRQ handler execution debugging code still needed?
>> Same for the other VPRINTK() lines in this patch.
>
> These VPRINKs are only to make new handlers look like ahci_interrupt()
> which did not change. I believe, if they need to go it is better to
> remove them altogether, with a separate followup patch.

Definitely followup patch material + discussion :)

For the moment, the above is consistent with existing code, and by 
default compiled out, as one would expect.

	Jeff






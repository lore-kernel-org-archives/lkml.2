Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab1JKSOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:14:34 -0400
Received: from smtp-out.google.com ([74.125.121.67]:54094 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab1JKSOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:14:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:content-transfer-encoding;
	b=UJji3iF08iMrWXYgrG1CQrCySmzzD1maOhNTknWPhUJ0W+D4FTEc+CbHSy/esIyE1
	DkdQjKDJaZdL+s86oFwXw==
MIME-Version: 1.0
In-Reply-To: <20111011172019.GI10838@kvack.org>
References: <20111011165903.GA30976@kroah.com> <20111011165708.466042477@pistachio.kroah.org>
 <20111011172019.GI10838@kvack.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 11 Oct 2011 12:14:05 -0600
Message-ID: <CAErSpo6JFTm4y35Nz7aNUgM3ynX52fM1-AwX7OTOwm3cminv1Q@mail.gmail.com>
Subject: Re: [01/38] PCI: Set PCI-E Max Payload Size on fabric
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jon Mason <mason@myri.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 11:20 AM, Benjamin LaHaise <bcrl@kvack.org> wrote:
> Hello Greg,
>
> On Tue, Oct 11, 2011 at 10:55:11AM -0600, Greg KH wrote:
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -77,6 +77,8 @@ unsigned long pci_cardbus_mem_size = DEF
>>  unsigned long pci_hotplug_io_size  = DEFAULT_HOTPLUG_IO_SIZE;
>>  unsigned long pci_hotplug_mem_size = DEFAULT_HOTPLUG_MEM_SIZE;
>>
>> +enum pcie_bus_config_types pcie_bus_config = PCIE_BUS_PERFORMANCE;
>> +
>
> This version of the patch incorrectly defaults to the new performance
> mode.  Since we haven't even had that code in the 3.1 release yet, I don't
> think it is suitable for a stable release.  This patch should be revised
> to a version with default set to safe/don't-touch mode if it is to be
> included.

It's not obvious that this fits the criteria for -stable
(Documentation/stable_kernel_rules.txt).

For example, I can't tell what real problem this fixes.

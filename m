Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab2BGRHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 12:07:23 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:52768 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab2BGRHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 12:07:22 -0500
Date: Tue, 7 Feb 2012 18:07:09 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 3.2.5
Message-ID: <20120207170709.GA28108@citd.de>
References: <20120206181622.GA28811@kroah.com>
 <20120207084037.GA6140@citd.de>
 <4F30FABF.4060409@ladisch.de>
 <20120207105835.GA12864@citd.de>
 <4F310DBC.1040501@ladisch.de>
 <20120207114806.GA15323@citd.de>
 <4F3118F7.8050205@ladisch.de>
 <CA+55aFxLKAN7rBWo_5oFNJdvaDfvvJydgmaHYPF5JQ_enDPe+Q@mail.gmail.com>
 <20120207165416.GA27342@citd.de>
 <20120207165944.GA30442@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207165944.GA30442@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.02.2012 16:59, Matthew Garrett wrote:
> Ok. Can you try this?
> 
> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> index 1cfbf22..24f049e 100644
> --- a/drivers/pci/pcie/aspm.c
> +++ b/drivers/pci/pcie/aspm.c
> @@ -500,6 +500,9 @@ static int pcie_aspm_sanity_check(struct pci_dev *pdev)
>  	int pos;
>  	u32 reg32;
>  
> +	if (aspm_disabled)
> +		return 0;
> +
>  	/*
>  	 * Some functions in a slot might not all be PCIe functions,
>  	 * very strange. Disable ASPM for the whole slot
> 

Works too. What is the difference (in my case)?

dmesg looks the same.

dmesg | grep -i aspm
[    0.761712] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.792916] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.626739] e1000e 0000:03:00.0: Disabling ASPM  L1






Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.


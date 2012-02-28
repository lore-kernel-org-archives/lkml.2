Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab2B1ARR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:17:17 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46773 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab2B1ARP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:17:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.136.231 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Mon, 27 Feb 2012 16:13:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matthias Schniedermeyer <ms@citd.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 3.2.5
Message-ID: <20120228001309.GA2989@kroah.com>
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

On Tue, Feb 07, 2012 at 04:59:44PM +0000, Matthew Garrett wrote:
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

Matthew, this doesn't look like it made it into Linus's tree, don't we
still need this for 3.3-final?

thanks,

greg k-h

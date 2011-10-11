Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab1JKRUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:20:21 -0400
Received: from kanga.kvack.org ([205.233.56.17]:59730 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870Ab1JKRUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:20:20 -0400
Date: Tue, 11 Oct 2011 13:20:19 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jon Mason <mason@myri.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [01/38] PCI: Set PCI-E Max Payload Size on fabric
Message-ID: <20111011172019.GI10838@kvack.org>
References: <20111011165903.GA30976@kroah.com> <20111011165708.466042477@pistachio.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111011165708.466042477@pistachio.kroah.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

On Tue, Oct 11, 2011 at 10:55:11AM -0600, Greg KH wrote:
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -77,6 +77,8 @@ unsigned long pci_cardbus_mem_size = DEF
>  unsigned long pci_hotplug_io_size  = DEFAULT_HOTPLUG_IO_SIZE;
>  unsigned long pci_hotplug_mem_size = DEFAULT_HOTPLUG_MEM_SIZE;
>  
> +enum pcie_bus_config_types pcie_bus_config = PCIE_BUS_PERFORMANCE;
> +

This version of the patch incorrectly defaults to the new performance 
mode.  Since we haven't even had that code in the 3.1 release yet, I don't 
think it is suitable for a stable release.  This patch should be revised 
to a version with default set to safe/don't-touch mode if it is to be 
included.

		-ben

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab1AFSwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:52:07 -0500
Received: from kroah.org ([198.145.64.141]:43346 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab1AFSvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:51:53 -0500
Date: Thu, 6 Jan 2011 10:48:40 -0800
From: Greg KH <greg@kroah.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Pratyush Anand <pratyush.anand@st.com>
Subject: Re: [PATCH V2] ST SPEAr: PCIE gadget suppport
Message-ID: <20110106184840.GA21672@kroah.com>
References: <137dfad4a093ea0ac80396f5eb7fbf0c382be698.1294314772.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <137dfad4a093ea0ac80396f5eb7fbf0c382be698.1294314772.git.viresh.kumar@st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 05:29:10PM +0530, Viresh Kumar wrote:
> From: Pratyush Anand <pratyush.anand@st.com>
> 
> This is a configurable gadget. can be configured by sysfs interface. Any
> IP available at PCIE bus can be programmed to be used by host
> controller.It supoorts both INTX and MSI.
> By default, gadget is configured for INTX and SYSRAM1 is mapped to BAR0
> with size 0x1000
> 
> Changes since V1:
> - __iomem added for register addresses
> - kerneldoc comment removed whereever not required.
> - help node moved from sysfs to documentation/misc-devices
> - strict_strtoul used instead of sscanf
> 
> Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  Documentation/misc-devices/spear-pcie-gadget.txt |  125 ++++

New sysfs entries require updates to the Documentation/ABI/ directory
for them.

Please rework the patch to include these entries.

> +read behaviour of nodes:
> +------------------------------
> +link 		:gives ltssm status.
> +int_type 	:type of supported interrupt
> +no_of_msi read	:zero if MSI is not enabled by host.A positive value is the
> +		number of MSI vector granted.
> +vendor_id	:returns programmed vendor id (hex)
> +device_id	:returns programmed device id(hex)
> +bar0_size:	:retruns size of bar0 in hex.
> +bar0_address	:returns address of bar0 mapped area in hex.
> +bar0_rw_offset	:returns offset of bar0 for which bar0_data will return value.
> +bar0_data	:returns data at bar0_rw_offset.
> +
> +write behaviour of nodes:
> +------------------------------
> +link 		:write UP to enable ltsmm DOWN to disable
> +int_type	:write interrupt type to be configured and (int_type could be
> +		INTA, MSI or NO_INT).select MSI only when you have programmed
> +		no_of_msi node.
> +no_of_msi	:number of MSI vector needed.
> +inta		:write 1 to assert INTA and 0 to de-assert.
> +send_msi	:write MSI vector to be send.
> +vendor_id	:write vendor id(hex) to be programmed.
> +device_id	:write device id(hex) to be programmed.
> +bar0_size	:write size of bar0 in hex. default bar0 size is 1000 (hex)
> +		bytes.
> +bar0_address	:write	address of bar0 mapped area in hex. (default mapping of
> +		bar0 is SYSRAM1(E0800000).Aalways program bar size before bar
> +		address. kernel might modify bar size and address to align. So
> +		read back bar size and address after writing to cross check.
> +bar0_rw_offset	:write offset of bar0 for which	bar0_data will write value.
> +bar0_data	:write data to be written at bar0_rw_offset.

Should you use configfs for this instead of sysfs?  It looks like that
is what you are looking for here.

thanks,

greg k-h

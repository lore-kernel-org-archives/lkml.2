Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab2CSKUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:20:42 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33521 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab2CSKUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:20:40 -0400
Message-ID: <4F670872.2090700@suse.cz>
Date: Mon, 19 Mar 2012 11:20:34 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120314 Thunderbird/12.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matthew Garrett <mjg@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, romain@orebokech.com,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [ 05/38] PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled
References: <20120316233447.747702375@linuxfoundation.org>
In-Reply-To: <20120316233447.747702375@linuxfoundation.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2012 12:34 AM, Greg KH wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me know.

The commit below is reported to crash the machine in the early init. See
the first reply to this message (lkml.org seems to be down right now):
lkml.org/lkml/2012/3/18/132

> From: Matthew Garrett <mjg@redhat.com>
> 
> commit 4949be16822e92a18ea0cc1616319926628092ee upstream.
> 
> Right now we won't touch ASPM state if ASPM is disabled, except in the case
> where we find a device that appears to be too old to reliably support ASPM.
> Right now we'll clear it in that case, which is almost certainly the wrong
> thing to do. The easiest way around this is just to disable the blacklisting
> when ASPM is disabled.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/pci/pcie/aspm.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- a/drivers/pci/pcie/aspm.c
> +++ b/drivers/pci/pcie/aspm.c
> @@ -500,6 +500,9 @@ static int pcie_aspm_sanity_check(struct
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
> 

thanks,
-- 
js
suse labs

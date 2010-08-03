Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818Ab0HCVwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 17:52:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64669 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794Ab0HCVwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 17:52:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=MscvfN+6qOYMrm+VvcOx8WHcYnZI6x8JY3LTSrn++WvA8GCxMaxBzsS9FmUSVbDJai
         5U96mwfE80TKBFHYF279duttcK9Su+7265yvB3jaHgfABNIW6EEIw6+YnqwJftDvFTDI
         UEOMAvfqnssFoxjiK1YZ947G+63nU06Lxmy6I=
Date: Tue, 3 Aug 2010 23:51:38 +0200
From: Dan Carpenter <error27@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 8/9] arch/powerpc/kernel: Drop unnecessary null test
Message-ID: <20100803215137.GU26313@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Julia Lawall <julia@diku.dk>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@ozlabs.org,
	linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.1008032334420.20393@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008032334420.20393@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 11:35:17PM +0200, Julia Lawall wrote:
> diff --git a/arch/powerpc/kernel/pci_of_scan.c b/arch/powerpc/kernel/pci_of_scan.c
> index 6ddb795..62dd363 100644
> --- a/arch/powerpc/kernel/pci_of_scan.c
> +++ b/arch/powerpc/kernel/pci_of_scan.c
> @@ -336,8 +336,7 @@ static void __devinit __of_scan_bus(struct device_node *node,
>  		if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
>  		    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
>  			struct device_node *child = pci_device_to_OF_node(dev);
> -			if (dev)
> -				of_scan_pci_bridge(child, dev);
> +			of_scan_pci_bridge(child, dev);

The intention was probably to check "child" instead of "dev".
pci_device_to_OF_node() can return NULL.  On the other hand the code
has been this way for a year and no one has complained...

regards,
dan carpenter

>  		}
>  	}
>  }

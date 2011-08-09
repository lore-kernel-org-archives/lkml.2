Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1HIOa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:30:58 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17204 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab1HIOa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:30:57 -0400
Date: Tue, 9 Aug 2011 10:30:20 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen/pciback: use resource_size()
Message-ID: <20110809143020.GD13905@dumpdata.com>
References: <1312621538.5589.45.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312621538.5589.45.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4E414485.0029:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 06, 2011 at 11:05:35AM +0200, Thomas Meyer wrote:
> From: Thomas Meyer <thomas@m3y3r.de>
> 
>  Use resource_size function on resource object
>  instead of explicit computation.
> 
>  The semantic patch that makes this output is available
>  in scripts/coccinelle/api/resource_size.cocci.
> 
>  More information about semantic patching is available at
>  http://coccinelle.lip6.fr/

Queued up for 3.2
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/drivers/xen/xen-pciback/conf_space_header.c b/drivers/xen/xen-pciback/conf_space_header.c
> --- a/drivers/xen/xen-pciback/conf_space_header.c 2011-07-26 00:46:09.730171570 +0200
> +++ b/drivers/xen/xen-pciback/conf_space_header.c 2011-08-01 23:02:39.180421787 +0200
> @@ -187,7 +187,7 @@ static inline void read_dev_bar(struct p
>  
>  	bar_info->val = res[pos].start |
>  			(res[pos].flags & PCI_REGION_FLAG_MASK);
> -	bar_info->len_val = res[pos].end - res[pos].start + 1;
> +	bar_info->len_val = resource_size(&res[pos]);
>  }
>  
>  static void *bar_init(struct pci_dev *dev, int offset)
> 
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel

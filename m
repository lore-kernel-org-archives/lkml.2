Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab2AaQak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 11:30:40 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:43522 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab2AaQaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 11:30:39 -0500
Date: Tue, 31 Jan 2012 11:27:59 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen pvhvm: do not remap pirqs onto evtchns if
 !xen_have_vector_callback
Message-ID: <20120131162759.GA18248@phenom.dumpdata.com>
References: <alpine.DEB.2.00.1201301429530.3196@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1201301429530.3196@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4F28172A.0048,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 02:31:46PM +0000, Stefano Stabellini wrote:
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

So the xen_have_vector_callback looks to be only set by

1398         if (xen_feature(XENFEAT_hvm_callback_vector))
1399                 xen_have_vector_callback = 1;

So could this be just done via a check for that instead?


> 
> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> index 492ade8..d99346e 100644
> --- a/arch/x86/pci/xen.c
> +++ b/arch/x86/pci/xen.c
> @@ -374,7 +374,7 @@ int __init pci_xen_init(void)
>  
>  int __init pci_xen_hvm_init(void)
>  {
> -	if (!xen_feature(XENFEAT_hvm_pirqs))
> +	if (!xen_have_vector_callback || !xen_feature(XENFEAT_hvm_pirqs))
>  		return 0;
>  
>  #ifdef CONFIG_ACPI
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

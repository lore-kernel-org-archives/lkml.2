Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab1HHOhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 10:37:40 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47462 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab1HHOhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 10:37:39 -0400
Date: Mon, 8 Aug 2011 10:37:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: jeremy.fitzhardinge@citrix.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: redefinition of typedef '__guest_handle_uint64_t'
Message-ID: <20110808143723.GB7213@dumpdata.com>
References: <alpine.DEB.2.01.1108080146000.9183@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1108080146000.9183@trent.utfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E3FF4AC.0149:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 01:54:39AM -0700, Christian Kujau wrote:
> Hi,
> 
> when trying to compile xen/next-3.0 from Jeremy's tree, this happens:

Ugh, just use the released 3.0 stock kernel.
> 
> ---------------------------------------------------
> /usr/local/src/linux-xen-next-3-git/arch/x86/kernel/asm-offsets.c:8:
> /usr/local/src/linux-xen-next-3-git/include/xen/interface/xen.h:527:1: 
> error: redefinition of typedef '__guest_handle_uint64_t'
> /usr/local/src/linux-xen-next-3-git/arch/x86/include/asm/xen/interface.h:58:1: 
> note: previous declaration of '__guest_handle_uint64_t' was here
> ---------------------------------------------------
> 
> The .config is here: http://nerdbynature.de/bits/3.0-rc7/
> The following makes it compile again, but it may not be the Right Thing 
> to do:
> 
> diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
> index 3c072c8..5a91c66 100644
> --- a/include/xen/interface/xen.h
> +++ b/include/xen/interface/xen.h
> @@ -524,8 +524,6 @@ struct tmem_op {
>  	} u;
>  };
>  
> -DEFINE_GUEST_HANDLE(uint64_t);
> -
>  #else /* __ASSEMBLY__ */
>  
>  /* In assembly code we cannot use C numeric constant suffixes. */
> 
> 
> Thanks,
> Christian.
> -- 
> BOFH excuse #100:
> 
> IRQ dropout

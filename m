Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab0KOSPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:15:47 -0500
Received: from claw.goop.org ([74.207.240.146]:60361 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757186Ab0KOSPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:15:46 -0500
Message-ID: <4CE178CF.3020308@goop.org>
Date: Mon, 15 Nov 2010 10:15:43 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Tony Finch <dot@dotat.at>
Subject: Re: [PATCH -next] xen: fix header export to userspace
References: <20101112130547.c2a3c2c1.sfr@canb.auug.org.au> <20101113084439.d21bd0f0.randy.dunlap@oracle.com>
In-Reply-To: <20101113084439.d21bd0f0.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2010 08:44 AM, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> scripts/headers_install.pl prevents "__user" from being exported
> to userspace headers, so just use compiler.h to make sure that
> __user is defined and avoid the error.
>
> unifdef: linux-next-20101112/xx64/usr/include/xen/privcmd.h.tmp: 79: Premature EOF (#if line 33 depth 1)

Ah, OK, thanks.  I was wondering what the proper fix for this was.  I'll
stick this in my tree.

Thanks,
    J

> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc:	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc:	xen-devel@lists.xensource.com (moderated for non-subscribers)
> Cc:	virtualization@lists.osdl.org
> Cc:	Tony Finch <dot@dotat.at>
> ---
>  include/xen/privcmd.h |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> --- linux-next-20101112.orig/include/xen/privcmd.h
> +++ linux-next-20101112/include/xen/privcmd.h
> @@ -34,13 +34,10 @@
>  #define __LINUX_PUBLIC_PRIVCMD_H__
>  
>  #include <linux/types.h>
> +#include <linux/compiler.h>
>  
>  typedef unsigned long xen_pfn_t;
>  
> -#ifndef __user
> -#define __user
> -#endif
> -
>  struct privcmd_hypercall {
>  	__u64 op;
>  	__u64 arg[5];


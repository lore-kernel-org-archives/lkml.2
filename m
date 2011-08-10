Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab1HJTUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 15:20:39 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47507 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab1HJTUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 15:20:38 -0400
Date: Wed, 10 Aug 2011 15:20:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH mainline] xen: xen-selfballoon.c needs more header files
Message-ID: <20110810192021.GA26264@dumpdata.com>
References: <CA+55aFwkJdyEpyNY64aAQ5ChrPZ8Kvx9iRUwy1J6_SRaxoN=zA@mail.gmail.com>
 <20110810112242.18b743de.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810112242.18b743de.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E42DA00.0011:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 11:22:42AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix build errors (found when CONFIG_SYSFS is not enabled):
> 
> drivers/xen/xen-selfballoon.c:446: warning: data definition has no type or storage class
> drivers/xen/xen-selfballoon.c:446: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
> drivers/xen/xen-selfballoon.c:446: warning: parameter names (without types) in function declaration
> drivers/xen/xen-selfballoon.c:485: error: expected declaration specifiers or '...' before string constant
> drivers/xen/xen-selfballoon.c:485: warning: data definition has no type or storage class
> drivers/xen/xen-selfballoon.c:485: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
> drivers/xen/xen-selfballoon.c:485: warning: function declaration isn't a prototype
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Ok, will stick it on my linux-next. Thanks!
> ---
>  drivers/xen/xen-selfballoon.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> and will need <linux/export.h> when module.h is split up.
> 
> --- lnx-31-rc1.orig/drivers/xen/xen-selfballoon.c
> +++ lnx-31-rc1/drivers/xen/xen-selfballoon.c
> @@ -70,6 +70,7 @@
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
>  #include <linux/mman.h>
> +#include <linux/module.h>
>  #include <linux/workqueue.h>
>  #include <xen/balloon.h>
>  #include <xen/tmem.h>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

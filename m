Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab1HPFMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 01:12:07 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23520 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab1HPFMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 01:12:03 -0400
Date: Tue, 16 Aug 2011 01:11:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3.1-rc2] xen: self-balloon needs module.h
Message-ID: <20110816051122.GC27908@dumpdata.com>
References: <CA+55aFycTvbuNzdgbHjoiNkTeDpzgu6Yf=vx9DU+PDOtC_17zA@mail.gmail.com>
 <20110815214143.ed2fa458.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815214143.ed2fa458.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4E49FC01.0012:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 09:41:43PM -0700, Randy Dunlap wrote:
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

I think .. yeah I do have it queued it up in my stable/bug.fixes tree, .. ah
but did not push it (albeit it was in #linux-next which was pushed).

Linus, if you want to take it, it has my
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

or if you just want to do a git pull, I will shortly send an email asking
to pull the above mentioned tree.

> ---
>  drivers/xen/xen-selfballoon.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> and will need <linux/export.h> when module.h is split up.
> 
> --- lnx-31-rc2.orig/drivers/xen/xen-selfballoon.c
> +++ lnx-31-rc2/drivers/xen/xen-selfballoon.c
> @@ -70,6 +70,7 @@
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
>  #include <linux/mman.h>
> +#include <linux/module.h>
>  #include <linux/workqueue.h>
>  #include <xen/balloon.h>
>  #include <xen/tmem.h>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab1HKRp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:45:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:40184 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab1HKRpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:45:23 -0400
Date: Thu, 11 Aug 2011 09:45:20 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Tracey Dent <tdent48227@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, gregkh@suse.de
Subject: Re: [PATCH 1/1] misc/pti.c: Fix build error when PCI is not
 selected
Message-Id: <20110811094520.4ee7819f.rdunlap@xenotime.net>
In-Reply-To: <20110811162306.GA30710@tj-desktop>
References: <20110811162306.GA30710@tj-desktop>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
X-Greylist: Delayed for 00:59:59 by milter-greylist-4.2.3 (hera.kernel.org [140.211.167.34]); Thu, 11 Aug 2011 17:45:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Aug 2011 12:23:06 -0400 Tracey Dent wrote:

> When you try to build INTEL_MID_PTI without having PCI
> enabled. It fails like this-
> 
>  CC [M]  drivers/misc/pti.o
>  drivers/misc/pti.c: In function ‘pti_pci_remove’:
>  drivers/misc/pti.c:410: error: implicit declaration of function ‘pci_release_region’
>  drivers/misc/pti.c: In function ‘pti_pci_probe’:
>  drivers/misc/pti.c:859: error: implicit declaration of function ‘pci_request_region’
> 
> So make INTEL_MID_PTI depend on PCI to fix build error.

I think (hope) that Greg already has a patch like this queued.
Greg- are you planning to push some patches soon?


> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> ---
>  drivers/misc/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 0a4d86c..2d6423c 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -146,6 +146,7 @@ config PHANTOM
>  
>  config INTEL_MID_PTI
>  	tristate "Parallel Trace Interface for MIPI P1149.7 cJTAG standard"
> +	depends on PCI
>  	default n
>  	help
>  	  The PTI (Parallel Trace Interface) driver directs
> -- 

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

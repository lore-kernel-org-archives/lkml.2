Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab1HBPLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 11:11:38 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:38684 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752201Ab1HBPLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 11:11:32 -0400
Date: Tue, 2 Aug 2011 08:11:29 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Heiko Carstens <heiko.carstens@de.ibm.com>,
        akpm <akpm@linux-foundation.org>,
        torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        J Freyensee <james_p_freyensee@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pti: add missing CONFIG_PCI dependency
Message-Id: <20110802081129.b84a7bc7.rdunlap@xenotime.net>
In-Reply-To: <20110802080834.GA9847@osiris.boeblingen.de.ibm.com>
References: <20110802080834.GA9847@osiris.boeblingen.de.ibm.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Aug 2011 10:08:34 +0200 Heiko Carstens wrote:

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> allmodconfig compile fails on s390 because of the new PTI driver:
> 
> drivers/misc/pti.c:407:3: error: implicit declaration of function 'pci_iounmap'
> drivers/misc/pti.c:410:3: error: implicit declaration of function 'pci_release_region'
> 
> Add a 'depends on PCI' statement so it doesn't get compiled.
> 
> Cc: J Freyensee <james_p_freyensee@linux.intel.com>

James has already acked my identical patch.
The problem seems to be that we don't have a drivers/misc/ maintainter to
merge the patch.

Anyway:
Acked-by: Randy Dunlap <rdunlap@xenotime.net>


> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  drivers/misc/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
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

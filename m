Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab1LTKOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 05:14:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43545 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab1LTKN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 05:13:57 -0500
Date: Tue, 20 Dec 2011 11:12:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/autoprobe] x86, cpufreq: Add support for x86 cpuinfo
 auto loading
Message-ID: <20111220101201.GB20788@elte.hu>
References: <1324338394-4670-8-git-send-email-andi@firstfloor.org>
 <tip-c347c2092efcd7d4fc1575057db7a42c1fc15ec5@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-c347c2092efcd7d4fc1575057db7a42c1fc15ec5@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Andi Kleen <ak@linux.intel.com> wrote:

> Commit-ID:  c347c2092efcd7d4fc1575057db7a42c1fc15ec5
> Gitweb:     http://git.kernel.org/tip/c347c2092efcd7d4fc1575057db7a42c1fc15ec5
> Author:     Andi Kleen <ak@linux.intel.com>
> AuthorDate: Mon, 19 Dec 2011 15:46:33 -0800
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Mon, 19 Dec 2011 15:50:01 -0800
> 
> x86, cpufreq: Add support for x86 cpuinfo auto loading

> diff --git a/drivers/cpufreq/gx-suspmod.c b/drivers/cpufreq/gx-suspmod.c
> index ffe1f2c..5a06c0b 100644
> --- a/drivers/cpufreq/gx-suspmod.c
> +++ b/drivers/cpufreq/gx-suspmod.c
> @@ -82,6 +82,7 @@
>  #include <linux/errno.h>
>  #include <linux/slab.h>
>  
> +#include <asm/cpu_device_id.h>
>  #include <asm/processor-cyrix.h>
>  
>  /* PCI config registers, all at F0 */
> @@ -171,6 +172,7 @@ static struct pci_device_id gx_chipset_tbl[] __initdata = {
>  	{ PCI_VDEVICE(CYRIX, PCI_DEVICE_ID_CYRIX_5510), },
>  	{ 0, },
>  };
> +MODULE_DEVICE_TABLE(gx_chipset_tbl);

Andi, you are sloppy as usual:

 drivers/cpufreq/gx-suspmod.c:175:35: error: macro "MODULE_DEVICE_TABLE" requires 2 arguments, but only 1 given

You have not even build tested this change?

Thanks,

	Ingo

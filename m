Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab1IFRD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 13:03:29 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:56807 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab1IFRDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 13:03:21 -0400
Date: Tue, 6 Sep 2011 13:02:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com, stefan.bader@canonical.com
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen: disable PV spinlocks on HVM
Message-ID: <20110906170255.GA29839@dumpdata.com>
References: <1315327307-392-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315327307-392-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020202.4E665252.0124:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 05:41:47PM +0100, stefano.stabellini@eu.citrix.com wrote:
> From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> PV spinlocks cannot possibly work with the current code because they are
> enabled after pvops patching has already been done, and because PV
> spinlocks use a different data structure than native spinlocks so we
> cannot switch between them dynamically. A spinlock that has been taken
> once by the native code (__ticket_spin_lock) cannot be taken by
> __xen_spin_lock even after it has been released.

Let me stick it on my 3.1-rc5 bug-fix list and add stable@kernel.org to it.

Stefan, if you have some time this week, and can test it - I can also
stick 'Tested-by' if you would like.

Thinking to send the patches on Friday.

> 
> Reported-by: Stefan Bader <stefan.bader@canonical.com>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/xen/smp.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index e79dbb9..51339b4 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -522,7 +522,6 @@ static void __init xen_hvm_smp_prepare_cpus(unsigned int max_cpus)
>  	WARN_ON(xen_smp_intr_init(0));
>  
>  	xen_init_lock_cpu(0);
> -	xen_init_spinlocks();
>  }
>  
>  static int __cpuinit xen_hvm_cpu_up(unsigned int cpu)
> -- 
> 1.7.2.3
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel

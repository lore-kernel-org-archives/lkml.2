Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab1IGVYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 17:24:35 -0400
Received: from claw.goop.org ([74.207.240.146]:53566 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757027Ab1IGVYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 17:24:34 -0400
Message-ID: <4E67E10A.3020809@goop.org>
Date: Wed, 07 Sep 2011 14:24:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: stefano.stabellini@eu.citrix.com
CC: konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH] xen: disable PV spinlocks on HVM
References: <1315327307-392-1-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1315327307-392-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2011 09:41 AM, stefano.stabellini@eu.citrix.com wrote:
> From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>
> PV spinlocks cannot possibly work with the current code because they are
> enabled after pvops patching has already been done, and because PV
> spinlocks use a different data structure than native spinlocks so we
> cannot switch between them dynamically. A spinlock that has been taken
> once by the native code (__ticket_spin_lock) cannot be taken by
> __xen_spin_lock even after it has been released.
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

Should I add this back here on the pv ticketlock branch?

    J


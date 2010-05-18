Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589Ab0ERRnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:43:23 -0400
Received: from claw.goop.org ([74.207.240.146]:33741 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756398Ab0ERRnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:43:21 -0400
Message-ID: <4BF2D1B8.7050004@goop.org>
Date: Tue, 18 May 2010 10:43:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>
Subject: Re: [PATCH 03/12] evtchn delivery on HVM
References: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop> <1274178187-20602-3-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1274178187-20602-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2010 03:22 AM, Stefano Stabellini wrote:
> From: Sheng Yang <sheng@linux.intel.com>
>
> Set the callback to receive evtchns from Xen, using the
> callback vector delivery mechanism.
>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Signed-off-by: Sheng Yang <sheng@linux.intel.com>
> ---
>  arch/x86/xen/enlighten.c         |   35 +++++++++++++++++++++++++++++++++++
>  drivers/xen/events.c             |   31 ++++++++++++++++++++++++-------
>  include/xen/events.h             |    3 +++
>  include/xen/hvm.h                |    9 +++++++++
>  include/xen/interface/features.h |    3 +++
>  5 files changed, 74 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 87a3b10..502c4f8 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -37,8 +37,11 @@
>  #include <xen/interface/vcpu.h>
>  #include <xen/interface/memory.h>
>  #include <xen/interface/hvm/hvm_op.h>
> +#include <xen/interface/hvm/params.h>
>  #include <xen/features.h>
>  #include <xen/page.h>
> +#include <xen/hvm.h>
> +#include <xen/events.h>
>  #include <xen/hvc-console.h>
>  
>  #include <asm/paravirt.h>
> @@ -79,6 +82,8 @@ struct shared_info xen_dummy_shared_info;
>  
>  void *xen_initial_gdt;
>  
> +int xen_have_vector_callback;
>   

BTW, this can be a __read_mostly.

    J

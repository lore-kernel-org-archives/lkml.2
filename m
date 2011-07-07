Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab1GGXpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 19:45:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:2001 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039Ab1GGXpf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 19:45:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,496,1304319600"; 
   d="scan'208";a="27648510"
From: "Dong, Eddie" <eddie.dong@intel.com>
To: Anupam Chanda <achanda@nicira.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "jeremy.fitzhardinge@citrix.com" <jeremy.fitzhardinge@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Dong, Eddie" <eddie.dong@intel.com>
Date: Fri, 8 Jul 2011 07:45:14 +0800
Subject: RE: [PATCH] Change hypervisor detection order
Thread-Topic: [PATCH] Change hypervisor detection order
Thread-Index: Acw80pG9VWdbX+hVSxmASwdu1UJnFwALTNTw
Message-ID: <1A42CE6F5F474C41B63392A5F80372B212DAA3F5F6@shsmsx501.ccr.corp.intel.com>
References: <1310062788-9445-1-git-send-email-achanda@nicira.com>
In-Reply-To: <1310062788-9445-1-git-send-email-achanda@nicira.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sounds good.
Eddie

> -----Original Message-----
> From: Anupam Chanda [mailto:achanda@nicira.com]
> Sent: Friday, July 08, 2011 2:20 AM
> To: tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com;
> x86@kernel.org; stefano.stabellini@eu.citrix.com;
> jeremy.fitzhardinge@citrix.com; Dong, Eddie; linux-kernel@vger.kernel.org
> Cc: achanda@nicira.com
> Subject: [PATCH] Change hypervisor detection order
> 
> Detect Xen before HyperV because in Viridian compatibility mode Xen
> presents
> itself as HyperV.
> 
> Signed-off-by: Anupam Chanda <achanda@nicira.com>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/kernel/cpu/hypervisor.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/hypervisor.c
> b/arch/x86/kernel/cpu/hypervisor.c
> index 8095f86..ca23091 100644
> --- a/arch/x86/kernel/cpu/hypervisor.c
> +++ b/arch/x86/kernel/cpu/hypervisor.c
> @@ -33,10 +33,10 @@
>  static const __initconst struct hypervisor_x86 * const hypervisors[] =
>  {
>  	&x86_hyper_vmware,
> -	&x86_hyper_ms_hyperv,
>  #ifdef CONFIG_XEN_PVHVM
>  	&x86_hyper_xen_hvm,
>  #endif
> +	&x86_hyper_ms_hyperv,
>  };
> 
>  const struct hypervisor_x86 *x86_hyper;
> --
> 1.7.2.5


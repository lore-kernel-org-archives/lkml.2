Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab1JXJDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:03:21 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37650 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab1JXJDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:03:19 -0400
Subject: Re: [PATCH RFC V2 4/5] kvm guest : Added configuration support to
 enable debug information for KVM Guests
From: Sasha Levin <levinsasha928@gmail.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, KVM <kvm@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Gleb Natapov <gleb@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xen <xen-devel@lists.xensource.com>, Avi Kivity <avi@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20111023190700.16364.7548.sendpatchset@oc5400248562.ibm.com>
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com>
	 <20111023190700.16364.7548.sendpatchset@oc5400248562.ibm.com>
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 24 Oct 2011 12:01:45 +0200
Message-ID: <1319450505.5660.5.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-24 at 00:37 +0530, Raghavendra K T wrote:
> Added configuration support to enable debug information
> for KVM Guests in debugfs
>     
> Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 1f03f82..ed34269 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -562,6 +562,15 @@ config KVM_GUEST
>  	  This option enables various optimizations for running under the KVM
>  	  hypervisor.
>  
> +config KVM_DEBUG_FS
> +	bool "Enable debug information for KVM Guests in debugfs"
> +	depends on KVM_GUEST

Shouldn't it depend on DEBUG_FS as well?

> +	default n
> +	---help---
> +	  This option enables collection of various statistics for KVM guest.
> +   	  Statistics are displayed in debugfs filesystem. Enabling this option
> +	  may incur significant overhead.
> +
>  source "arch/x86/lguest/Kconfig"
>  
>  config PARAVIRT

-- 

Sasha.


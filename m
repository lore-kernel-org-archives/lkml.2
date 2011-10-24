Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab1JXKP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 06:15:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714Ab1JXKP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 06:15:57 -0400
Message-ID: <4EA53AB2.9050805@redhat.com>
Date: Mon, 24 Oct 2011 12:15:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, KVM <kvm@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Gleb Natapov <gleb@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xen <xen-devel@lists.xensource.com>, Rik van Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC V2 4/5] kvm guest : Added configuration support to
 enable debug information for KVM Guests
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com> <20111023190700.16364.7548.sendpatchset@oc5400248562.ibm.com>
In-Reply-To: <20111023190700.16364.7548.sendpatchset@oc5400248562.ibm.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2011 09:07 PM, Raghavendra K T wrote:
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
> +	default n
> +	---help---
> +	  This option enables collection of various statistics for KVM guest.
> +   	  Statistics are displayed in debugfs filesystem. Enabling this option
> +	  may incur significant overhead.
> +
>  source "arch/x86/lguest/Kconfig"
>  
>

This might be better implemented through tracepoints, which an be
enabled dynamically.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.


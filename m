Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab0LPQbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 11:31:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:33749 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152Ab0LPQbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:31:08 -0500
Message-ID: <4D0A3EB1.7060207@kernel.org>
Date: Thu, 16 Dec 2010 17:30:41 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org, shaohui.zheng@intel.com
Subject: Re: [PATCHSET] x86: unify x86_32 and 64 NUMA init paths, take#3
References: <1292074247-20891-1-git-send-email-tj@kernel.org>
In-Reply-To: <1292074247-20891-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Dec 2010 16:30:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Shaohui)
Hello, Thoams.

On 12/11/2010 02:30 PM, Tejun Heo wrote:
> This is the third take of unify-x86_32-and-64-NUMA-init-paths
> patchset.  Most changes from the last take[L] are to reflect comments
> from tglx.
> 
> * Rebased on top of tip/x86/apic-cleanup.
> 
> * "x86: apic: Cleanup and simplify setup_local_APIC()" is already
>   merged into x86/apic-cleanup and dropped from this series.
> 
> * Instead of repurposing apic->cpu_to_logical_apicid(), replace it
>   with a new 32bit specific callback
>   apic->x86_32_early_logical_apicid().
> 
> * For consistency, in 0012, apic->apicid_to_node() is renamed to
>   x86_32_numa_cpu_node() and put inside CONFIG_X86_32.
> 
> * NULL assignments for unimplemented apic ops dropped.
> 
> * 0013 now explicitly describes why amd srat_detect_node() accesses
>   __apicid_to_node[] directly.  Also, add a comment in the function
>   noting the ugliness.
> 
> * Patch description updated in 0014.
> 
> * Other misc updates.

Do the above changes agreeable to you?  Shaohui is wondering what to
do with the conflicts between the NUMA hotplug simulator and this
series, so...

Thank you.

-- 
tejun

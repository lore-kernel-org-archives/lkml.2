Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab1IWLIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 07:08:09 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49065 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab1IWLIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 07:08:05 -0400
Message-ID: <4E7C686F.30608@linux.vnet.ibm.com>
Date: Fri, 23 Sep 2011 16:37:27 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Kevin Hilman <khilman@ti.com>
CC: venki@google.com, ak@linux.intel.com, len.brown@intel.com,
        peterz@infradead.org, santosh.shilimkar@ti.com, arjan@linux.intel.com,
        lenb@kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, rmk@arm.linux.org.uk
Subject: Re: [RFC PATCH V6 0/4] cpuidle: Global registration of idle states
 with per-cpu statistics
References: <20110922082840.10520.85895.stgit@localhost6.localdomain6> <87ty84tl7n.fsf@ti.com>
In-Reply-To: <87ty84tl7n.fsf@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 September 2011 01:15 AM, Kevin Hilman wrote:
> Deepthi Dharwar <deepthi@linux.vnet.ibm.com> writes:
> 
>> The following patch series implements global registration of cpuidle
>> states, and also has the necessary data structure changes to
>> accommodate the per-cpu writable members of the cpuidle_states
>> structure.
> 
> I reviewed earlier versions of the series, and this version still looks
> good to me.  Any reason it is still RFC?
> 
> Reviewed-by: Kevin Hilman <khilman@ti.com>
> 
> and for the OMAP-specific parts,
> 
> Acked-by: Kevin Hilman <khilman@ti.com>
> 
> Kevin
> 
Hi Kevin,
Thanks for reviewing the patch.

This was posted as an RFC, as there were
a couple of ToDos listed in this patch series
which I thought needed additional review before 
I could ask for inclusion. 

To Do :
======

1. Russell King pointed out that in (V5 1/4) of this patch in
arch/arm/mach-at91/cpuidle.c, AT91 pieces may be broken.
In at91_enter_idle() routine, folks need to fix the two
consecutive asm() statements by combining
it to one as per the GCC reference manual.

Reference:
https://lkml.org/lkml/2011/6/6/273

2. In (V6 4/4), handle the case when idle states may change at run time
and acpi_processor_cst_has_changed() routine is called in a
better way than the current solution in this patch.

In this current solution where global registration is implemented,
the boot cpu on x86 would disable all the devices, repopulate the
states and later enable all the devices, irrespective of the cpu
that would receive the notification first.

Reference:
https://lkml.org/lkml/2011/4/25/83

Thanks & Regards,
 -Deepthi

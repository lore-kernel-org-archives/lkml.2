Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab1BILST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 06:18:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:41650 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab1BILSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 06:18:18 -0500
Subject: Re: [RFC PATCH V3 3/3] cpuidle: default idle driver for x86
From: Peter Zijlstra <peterz@infradead.org>
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: arjan@linux.intel.com, lenb@kernel.org, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110208105214.9998.85114.stgit@tringupt.in.ibm.com>
References: <20110208105146.9998.22103.stgit@tringupt.in.ibm.com>
	 <20110208105214.9998.85114.stgit@tringupt.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 12:19:24 +0100
Message-ID: <1297250364.13327.160.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-08 at 16:22 +0530, Trinabh Gupta wrote:
> +/*
> + * cpu_idle_wait - Used to ensure that all the CPUs discard old value of
> + * pm_idle and update to new pm_idle value. Required while changing pm_idle
> + * handler on SMP systems.
> + *
> + * Caller must have changed pm_idle to the new value before the call. Old
> + * pm_idle value will not be used by any CPU after the return of this function.
> + */
> +void cpu_idle_wait(void)
> +{
> +       smp_mb();
> +       /* kick all the CPUs so that they exit out of pm_idle */
> +       smp_call_function(do_nothing, NULL, 1);
> +} 

pm_idle exists no longer... 


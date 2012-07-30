Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab2G3RGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:06:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:20942 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab2G3RGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:06:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="174914424"
Subject: Re: [PATCH v2] x86: don't ever patch back to UP if we unplug cpus.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@us.ibm.com>
Date: Mon, 30 Jul 2012 10:09:53 -0700
In-Reply-To: <874noqm21b.fsf@rustcorp.com.au>
References: <87y5m5mz6o.fsf@rustcorp.com.au>
	 <1343420909.3696.560.camel@sbsiddha-desk.sc.intel.com>
	 <87d33em4mf.fsf@rustcorp.com.au> <874noqm21b.fsf@rustcorp.com.au>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1343668193.3696.574.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-30 at 11:40 +0930, Rusty Russell wrote:
> We still patch SMP instructions to UP variants if we boot with a
> single CPU, but not at any other time.  In particular, not if we
> unplug CPUs to return to a single cpu.
> 
> Paul McKenney points out:
> 
>  mean offline overhead is 6251/48=130.2 milliseconds.
> 
>  If I remove the alternatives_smp_switch() from the offline
>  path [...] the mean offline overhead is 550/42=13.1 milliseconds
> 
> Basically, we're never going to get those 120ms back, and the code is
> pretty messy.
> 
> We get rid of:
> 1) The "smp-alt-once" boot option.  It's actually "smp-alt-boot", the
>    documentation is wrong.  It's now the default.
> 2) The skip_smp_alternatives flag used by suspend.
> 3) arch_disable_nonboot_cpus_begin() and arch_disable_nonboot_cpus_end()
>    which were only used to set this one flag.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>


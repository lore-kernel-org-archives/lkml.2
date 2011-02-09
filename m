Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab1BILUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 06:20:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50406 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab1BILUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 06:20:15 -0500
Subject: Re: [RFC PATCH V3 0/3] cpuidle: Cleanup pm_idle and include
 driver/cpuidle.c in-kernel
From: Peter Zijlstra <peterz@infradead.org>
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: arjan@linux.intel.com, lenb@kernel.org, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110208105146.9998.22103.stgit@tringupt.in.ibm.com>
References: <20110208105146.9998.22103.stgit@tringupt.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 12:21:18 +0100
Message-ID: <1297250478.13327.162.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-08 at 16:21 +0530, Trinabh Gupta wrote:
> 
>  arch/x86/kernel/process.c     |  340 -------------------------------
>  arch/x86/kernel/process_32.c  |    4
>  arch/x86/kernel/process_64.c  |    4
>  arch/x86/xen/setup.c          |    1
>  drivers/acpi/processor_idle.c |    2
>  drivers/cpuidle/Kconfig       |    9 +
>  drivers/cpuidle/cpuidle.c     |   43 +++-
>  drivers/cpuidle/driver.c      |  112 ++++++++++
>  drivers/idle/Makefile         |    2
>  drivers/idle/default_driver.c |  453 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/cpuidle.h       |    3
>  11 files changed, 613 insertions(+), 360 deletions(-)
>  create mode 100644 drivers/idle/default_driver.c


# git grep -l "\<pm_idle\>" arch/x86/
arch/x86/kernel/apm_32.c
arch/x86/kernel/process.c
arch/x86/kernel/process_32.c
arch/x86/kernel/process_64.c
arch/x86/xen/setup.c

You seemed to have missed touching apm_32.c


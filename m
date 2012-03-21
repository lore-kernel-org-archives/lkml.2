Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab2CUBma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 21:42:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:43815 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108Ab2CUBm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 21:42:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="79797962"
Subject: Re: 3.2.1 Unable to reset IRR messages on boot
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: jwboyer@redhat.com, mingo@elte.hu, hpa@zytor.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 20 Mar 2012 18:42:33 -0700
In-Reply-To: <1332288764-10351-1-git-send-email-konrad.wilk@oracle.com>
References: <1332273919.16101.74.camel@sbsiddha-desk.sc.intel.com>
	 <1332288764-10351-1-git-send-email-konrad.wilk@oracle.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1332294154.16101.97.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 20:12 -0400, Konrad Rzeszutek Wilk wrote:
> I was talking with Suresh on IRC and I realized that some of these patches
> that did this were posted some time ago, so I dusted them off and redid them
> just a tiny bit.
> 
> Ingo, please take a look - and if you are OK with them please put in them
> the v3.4 queue - if you are not comfortable, then the above patch will have to
> suffice as a work-around for the regression.
> 
>  arch/x86/include/asm/io_apic.h  |   31 +++++++++++++++++++++++++++++--
>  arch/x86/include/asm/x86_init.h |    8 ++++++++
>  arch/x86/kernel/apic/io_apic.c  |   10 ++++++----
>  arch/x86/kernel/setup.c         |    2 +-
>  arch/x86/kernel/x86_init.c      |    8 ++++++++
>  arch/x86/xen/Makefile           |    2 +-
>  arch/x86/xen/apic.c             |   17 +++++++++++++++++
>  arch/x86/xen/enlighten.c        |    2 ++
>  arch/x86/xen/xen-ops.h          |    4 ++++
>  9 files changed, 76 insertions(+), 8 deletions(-)
> Jeremy Fitzhardinge (1):
>       x86: add io_apic_ops to allow interception
> 
> Konrad Rzeszutek Wilk (2):
>       x86/apic_ops: Replace apic_ops with x86_apic_ops.
>       xen/x86: Implement x86_apic_ops
> 

Ingo, Konrad was mentioning you didn't like this pieces before.

But for what Xen is trying to do, either we have to pursue this or
untangle the gsi and ioapic dependency.

I am ok with this path for now.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845Ab2JKAGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:06:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:55812 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757677Ab2JKAGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:06:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,567,1344236400"; 
   d="scan'208";a="204113841"
Subject: RE: [PATCH] fix x2apic defect that Linux kernel doesn't mask 8259A
 interrupt during the time window between changing VT-d table base address
 and initializing these VT-d entries(smpboot.c and apic.c )
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Croxon, Nigel" <nigel.croxon@hp.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "agordeev@redhat.com" <agordeev@redhat.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Date: Wed, 10 Oct 2012 17:07:19 -0700
In-Reply-To: <92645B27BF79D04FBD2B0F8494FFD0F90FE41E@G2W2429.americas.hpqcorp.net>
References: <92645B27BF79D04FBD2B0F8494FFD0F90FC806@G2W2429.americas.hpqcorp.net>
	 <1349740633.11093.43.camel@sbsiddha-desk.sc.intel.com>
	 <92645B27BF79D04FBD2B0F8494FFD0F90FE41E@G2W2429.americas.hpqcorp.net>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1349914040.3042.12.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-10 at 00:26 +0000, Zhang, Lin-Bao (Linux Kernel R&D)
wrote:

> So , we can think ,as your patch , during the window , IO-apic is
> useless or we can think IO-APIC doesn't exist ? 
> Could you mind please sharing your design details ? thanks very much! 

Between the window of interrupt-remapping enabled and the masked IO-APIC
RTE's are configured properly, linux kernel doesn't wait/depend on any
external interrupts.

> > Can you please apply the appended patch to 2.6.32 kernel and see if the issue
> > you mentioned gets fixed? If so, we can ask the -stable and OSV's teams to
> > pick up this fix.
> Yes , it can resolve current issue. 

Thanks for testing it out.

I will add the appropriate changelog and send the patch out (to 2.6.32
stable and OSV kernels) with your "Tested-by:" if you are ok.

thanks,
suresh


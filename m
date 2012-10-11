Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757Ab2JKAAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:00:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:41231 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757637Ab2JKAAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:00:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,567,1344236400"; 
   d="scan'208";a="203021212"
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
        "yinghai@kernel.org" <yinghai@kernel.org>
Date: Wed, 10 Oct 2012 17:01:39 -0700
In-Reply-To: <92645B27BF79D04FBD2B0F8494FFD0F9102841@G2W2429.americas.hpqcorp.net>
References: <92645B27BF79D04FBD2B0F8494FFD0F90FC806@G2W2429.americas.hpqcorp.net>
	 <1349740633.11093.43.camel@sbsiddha-desk.sc.intel.com>
	  <92645B27BF79D04FBD2B0F8494FFD0F9102841@G2W2429.americas.hpqcorp.net>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1349913700.3042.7.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-10 at 16:02 -0700, Zhang, Lin-Bao (Linux Kernel R&D)
wrote:
> > As I mentioned earlier, the current design already ensures that all the IO-APIC
> > RTE's are masked between the time we enable interrupt-remapping to the time
> > when the IO-APIC RTE's are configured correctly.
> >
> > So I looked at why you are seeing the problem with v2.6.32 but not with the
> > recent kernels. And I think I found out the reason.
> 
> I want to know what masking IO-APIC means?

As the platform is configured to use virtual-wire B and the
corresponding IO-APIC RTE is masked, that interrupt will be dropped.

thanks,
suresh


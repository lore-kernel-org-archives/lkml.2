Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab0IQIra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 04:47:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:55147 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab0IQIr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 04:47:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,381,1280732400"; 
   d="scan'208";a="838516347"
Subject: Re: [PATCH] x86: fix duplicate calls of the nmi handler
From: Huang Ying <ying.huang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lin, Ming M" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "eranian@google.com" <eranian@google.com>
In-Reply-To: <1284709936.3764.2241.camel@twins>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
	 <1284118900.402.35.camel@laptop> <20100910132741.GB4879@redhat.com>
	 <20100910144634.GA1060@elte.hu>  <20100910155659.GD13563@erda.amd.com>
	 <1284658950.2275.591.camel@laptop>  <1284682396.32373.16.camel@yhuang-dev>
	 <1284709936.3764.2241.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Sep 2010 16:47:27 +0800
Message-ID: <1284713247.32373.274.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-17 at 15:52 +0800, Peter Zijlstra wrote:
> On Fri, 2010-09-17 at 08:13 +0800, Huang Ying wrote:
> 
> > Please take a look at my recent patch that rewrites the NMI handler.
> 
> (Link would have been useful)

http://lkml.org/lkml/2010/9/9/575

> > Where NMI are divided into two types. CPU specific NMI are processed
> > firstly as DIE_NMI_IPI, and non-CPU specific NMI are processed as
> > DIE_NMI.
> 
> OK, and you can discriminate between these two by means of that reason
> port? Still I think NMI_IPI is a terrible name for that.

In my patches, DIE_NMI_IPI go firstly, then DIE_NMI follows. NMI reason
is not used for that.

I don't know the history of naming too. But I think the name may come
from apic->send_IPI(mask, NMI_VECTOR). Which is used by crash_kexec,

crash_kexec
  machine_crash_shutdown
    kdump_nmi_shootdown_cpus
      nmi_shootdown_cpus
        smp_send_nmi_allbutself

Best Regards,
Huang Ying



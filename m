Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab2CMXQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:16:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:40382 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab2CMXQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:16:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="117419186"
Subject: Re: x2APIC and many-APIC systems...
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Daniel J Blueman <daniel@numascale-asia.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Steffen Persvold <sp@numascale.com>
Date: Tue, 13 Mar 2012 16:16:29 -0700
In-Reply-To: <CAE9FiQWtHD41qoYSm+tzLROUyR_33bwyBgE882cop3vbEmSPhw@mail.gmail.com>
References: <4F5F1385.60406@numascale-asia.com>
	 <CAE9FiQWtHD41qoYSm+tzLROUyR_33bwyBgE882cop3vbEmSPhw@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1331680589.18900.76.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-13 at 15:58 -0700, Yinghai Lu wrote:
> On Tue, Mar 13, 2012 at 2:29 AM, Daniel J Blueman
> <daniel@numascale-asia.com> wrote:
> > Ingo, Suresh,
> >
> > Commit a35fd28256e7736cc84af8931a16224f0bfaaf6c prevents x2APIC structures
> > being used from the ACPI MADT if the cores don't advertise the x2APIC
> > feature. Commit c284b42abadbb22083bfde24d308899c08d44ffa prevents onlining
> > cores with APIC ID >255 in non-x2APIC mode. Since NumaChip/NumaConnect uses
> > x2APIC structures to describe non-x2APIC systems (AMD Opteron) with lots of
> > APICs, we thus now can't boot all the cores.
> >
> > We are able to set the x2APIC bit in the processor feature flags, so get
> > caught by the second patch. Is there an appropriate approach to use in these
> > circumstances? Otherwise, would a patch that separates the APIC ID handover
> > and future x2APIC MSR access be appropriate?
> >
> 
> add is_apicid_valid() in struct apic?

Yes, we can generalize that and move into the apicdriver. Daniel, will
you be able to prepare such a patch?

thanks,
suresh


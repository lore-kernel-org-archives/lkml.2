Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab2FETyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 15:54:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:47710 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab2FETyV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 15:54:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="153314822"
From: "Luck, Tony" <tony.luck@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: RE: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
Thread-Topic: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
Thread-Index: AQHNQoAPFj9sktPv9UGlpY91mwdZJJbrDNOAgAAGFYCAAEURgIAAdQ+AgACMaICAAAIPgIAAApCAgAAAWQD//6AhUIAAffCA//+mwpA=
Date: Tue, 5 Jun 2012 19:54:19 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19301A16@ORSMSX104.amr.corp.intel.com>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
	 <alpine.LFD.2.02.1206042203590.3086@ionos>
	 <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au>
	 <1338881971.28282.150.camel@twins>
	 <3E5A0FA7E9CA944F9D5414FEC6C7122007727023@ORSMSX105.amr.corp.intel.com>
	 <1338912565.2749.9.camel@twins>
	 <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com>
	 <1338913190.2749.10.camel@twins>
	 <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com>
 <1338919647.2749.30.camel@twins>
In-Reply-To: <1338919647.2749.30.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But given that you care about how fast a cpu can come up again, this
> seems to be exactly what you want. You want to adapt to load fast, so
> why bother going through userspace and wrecking bits in between?

There are multiple needs here - that appear to have some significant
overlap (re-routing interrupts, stopping scheduling).

My need is for RAS reasons to take a cpu offline - and since
it is broken, I'm not going to bring it back again (at least not anytime
soon - perhaps a service engineer will drive by in a few hours, pull out
the broken cpu, put in a new one, and then bring that online ... but
saving a few milli-seconds in this use case it pointless).

Other people want to do this for power saving. They probably do care
how fast the processor can be brought back.

-Tony

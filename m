Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab0KZJmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 04:42:08 -0500
Received: from service87.mimecast.com ([94.185.240.25]:33407 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753760Ab0KZJmG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 04:42:06 -0500
Subject: Re: [RFC][PATCH 2/8] perf, arch: Use early_initcall() for all arch
 pmu implementations
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Kyle Moffett <kyle@moffetthome.net>, linux-kernel@vger.kernel.org,
        davem <davem@davemloft.net>, Michael Cree <mcree@orcon.net.nz>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>, Don Zickus <dzickus@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>
In-Reply-To: <1290707759.2145.119.camel@laptop>
References: <20101117221730.002627458@chello.nl>
	 <20101117222056.040309789@chello.nl>  <1290680713.2145.18.camel@laptop>
	 <1290707759.2145.119.camel@laptop>
Date: Fri, 26 Nov 2010 09:41:50 +0000
Message-ID: <1290764510.24565.6.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 26 Nov 2010 09:41:51.0830 (UTC) FILETIME=[27683F60:01CB8D4E]
X-MC-Unique: 110112609415901501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-25 at 17:55 +0000, Peter Zijlstra wrote:
> So the perf_event_init() site is _waaay_ to early to init stuff.. I
> guess I'll move it all to early_initcall() and I'll move the watchdog to
> an explicit call right after it.
> 
> Something like the below,.. now I guess the question to all of you is,
> can your arch pmu code cope with early_initcall() or does it need to be
> some other place?
> 
The ARM init code basically just parses the CPUID to work out what PMU
is available, so it should be safe to call it as early as you like.

Will



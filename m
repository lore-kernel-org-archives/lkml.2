Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab0KYQWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 11:22:52 -0500
Received: from service87.mimecast.com ([94.185.240.25]:54502 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752546Ab0KYQWv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 11:22:51 -0500
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
        Paul Mundt <lethal@linux-sh.org>, Don Zickus <dzickus@redhat.com>
In-Reply-To: <1290696476.2145.46.camel@laptop>
References: <20101117221730.002627458@chello.nl>
	 <20101117222056.040309789@chello.nl>  <1290680713.2145.18.camel@laptop>
	 <1290696476.2145.46.camel@laptop>
Date: Thu, 25 Nov 2010 16:22:30 +0000
Message-ID: <1290702150.2059.10.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 25 Nov 2010 16:22:34.0852 (UTC) FILETIME=[F7C08240:01CB8CBC]
X-MC-Unique: 110112516224101201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Thu, 2010-11-25 at 14:47 +0000, Peter Zijlstra wrote:
> > So do I create a perf_initcall() or is there another solution that
> > avoids things like calling the watchdog code from all arch init code?
> 
> How about something like these? After this we could even look at making
> the watchdog code an explicit init in main.c right after
> do_perf_initcalls() (or later if it requires more to be up and running).
> 
What tree/branch are these patches taken against? They don't seem
to apply against -rc3 or tip/master. Anyway, I currently have some
pending patches to split up the monolithic perf_event.c we have for ARM
so that different PMU implementations can live in different files (in
the same way that x86 does it). This might mean that your initcall patch
no longer applies because it will be a couple of thousand lines higher
up in the file.

The patches are available here:

git://linux-arm.org/linux-2.6-wd.git perf-split

I'll put these into Russell's patch system today so they should be
candidates for 2.6.38.
> 
> Hrm,. except that it all builds but doesn't seem to actually work, I
> guess I need more magics to make the perf_initcall() thing work.
> 
> /me goes investigate

Good luck!

Will




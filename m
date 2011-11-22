Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab1KVL5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:57:25 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5403 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1KVL5Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:57:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 22 Nov 2011 03:56:56 -0800
From: Oleg Strikov <OSTRIKOV@nvidia.com>
To: Will Deacon <will.deacon@arm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, "mingo@elte.hu" <mingo@elte.hu>,
        William Cohen <wcohen@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Cree <mcree@orcon.net.nz>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Anton Blanchard <anton@samba.org>, Eric B Munson <emunson@mgebm.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Kuo <rkuo@codeaurora.org>,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        Vince Weaver <vince@deater.net>
Date: Tue, 22 Nov 2011 12:56:53 +0100
Subject: RE: [RFC][PATCH 2/6] perf, arch: Rework perf_event_index()
Thread-Topic: [RFC][PATCH 2/6] perf, arch: Rework perf_event_index()
Thread-Index: AcypDUzuyFJX1gn6RuyZhKuLfdhNwQAAD9Gg
Message-ID: <68B2676CBD57C643A577008EC1419ED1504663E243@DEMAIL01.nvidia.com>
References: <20111121145114.049265181@chello.nl>
 <20111121145337.533322271@chello.nl>
 <20111121172323.GH20611@mudshark.cambridge.arm.com>
 <1321903090.28118.21.camel@twins>
 <20111121203145.GA7301@mudshark.cambridge.arm.com>
 <1321907755.28118.30.camel@twins>
 <20111121224343.GA7862@mudshark.cambridge.arm.com>
 <1321961180.5148.31.camel@twins>
 <20111122114700.GJ20518@mudshark.cambridge.arm.com>
 <68B2676CBD57C643A577008EC1419ED1504663E239@DEMAIL01.nvidia.com>
 <20111122115221.GL20518@mudshark.cambridge.arm.com>
In-Reply-To: <20111122115221.GL20518@mudshark.cambridge.arm.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the clock_gettime() is usually used for the in-app profiling.
It usually creates a lot of redundant work and may even change the profiling results (if you _are_ CPU-bounded already).
So it will be significant leap ahead.

-----Original Message-----
From: Will Deacon [mailto:will.deacon@arm.com] 
Sent: Tuesday, November 22, 2011 3:52 PM
To: Oleg Strikov
Cc: Peter Zijlstra; mingo@elte.hu; William Cohen; linux-kernel@vger.kernel.org; Michael Cree; Deng-Cheng Zhu; Anton Blanchard; Eric B Munson; Heiko Carstens; Paul Mundt; David S. Miller; Richard Kuo; Stephane Eranian; Arun Sharma; Vince Weaver
Subject: Re: [RFC][PATCH 2/6] perf, arch: Rework perf_event_index()

On Tue, Nov 22, 2011 at 11:49:41AM +0000, Oleg Strikov wrote:
> > The user-readable clock will first appear in Cortex-A15, so the code for that still needs to hit mainline before I can look at doing this in perf.
> 
> This could be very useful. I think that the cycles counter covers the 90% of all the in-app profiler needs.

Well, it's slightly different to the cycle counter in that it will continue to count when the core is idle. The PMU cycle counter may stop when you issue a WFI. The frequency of the clock is also unlikely to be the same as the CPU clock.

Will

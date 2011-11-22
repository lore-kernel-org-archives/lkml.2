Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab1KVM0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 07:26:12 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8366 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab1KVM0K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 07:26:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 22 Nov 2011 04:25:20 -0800
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
Date: Tue, 22 Nov 2011 13:25:16 +0100
Subject: RE: [RFC][PATCH 2/6] perf, arch: Rework perf_event_index()
Thread-Topic: [RFC][PATCH 2/6] perf, arch: Rework perf_event_index()
Thread-Index: AcypEFpvBgbAIXcdRDSflW/b702o1QAAT0Ig
Message-ID: <68B2676CBD57C643A577008EC1419ED1504677892E@DEMAIL01.nvidia.com>
References: <20111121172323.GH20611@mudshark.cambridge.arm.com>
 <1321903090.28118.21.camel@twins>
 <20111121203145.GA7301@mudshark.cambridge.arm.com>
 <1321907755.28118.30.camel@twins>
 <20111121224343.GA7862@mudshark.cambridge.arm.com>
 <1321961180.5148.31.camel@twins>
 <20111122114700.GJ20518@mudshark.cambridge.arm.com>
 <68B2676CBD57C643A577008EC1419ED1504663E239@DEMAIL01.nvidia.com>
 <20111122115221.GL20518@mudshark.cambridge.arm.com>
 <68B2676CBD57C643A577008EC1419ED15046778919@DEMAIL01.nvidia.com>
 <20111122121422.GN20518@mudshark.cambridge.arm.com>
In-Reply-To: <20111122121422.GN20518@mudshark.cambridge.arm.com>
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

> Actually, the registers for controlling interrupts aren't visible to userspace with ARMv7. On ARMv6, this is a different story, which is why I didn't mention doing this > for older platforms earlier :)

Yes. But the profiling tool enables the interrupts.
I mean that with the profiler running the bad application can break the system.

Oleg

-----Original Message-----
From: Will Deacon [mailto:will.deacon@arm.com] 
Sent: Tuesday, November 22, 2011 4:14 PM
To: Oleg Strikov
Cc: Peter Zijlstra; mingo@elte.hu; William Cohen; linux-kernel@vger.kernel.org; Michael Cree; Deng-Cheng Zhu; Anton Blanchard; Eric B Munson; Heiko Carstens; Paul Mundt; David S. Miller; Richard Kuo; Stephane Eranian; Arun Sharma; Vince Weaver
Subject: Re: [RFC][PATCH 2/6] perf, arch: Rework perf_event_index()

On Tue, Nov 22, 2011 at 12:00:33PM +0000, Oleg Strikov wrote:
> Also, please do not forget that enabling the userspace access to the 
> counters may not only create some problems to the profilers like Perf/OProfile but could also trash the kernel with the interrupts.

Actually, the registers for controlling interrupts aren't visible to userspace with ARMv7. On ARMv6, this is a different story, which is why I didn't mention doing this for older platforms earlier :)

Anyway, this thread has digressed now so you can always jump onto the ARM list (linux-arm-kernel) if you want to discuss this more.

Cheers,

Will

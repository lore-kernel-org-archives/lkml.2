Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab1KUUbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:31:50 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62038 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753178Ab1KUUbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:31:49 -0500
Date: Mon, 21 Nov 2011 20:31:45 +0000
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "mingo@elte.hu" <mingo@elte.hu>, William Cohen <wcohen@redhat.com>,
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
Subject: Re: [RFC][PATCH 2/6] perf, arch: Rework perf_event_index()
Message-ID: <20111121203145.GA7301@mudshark.cambridge.arm.com>
References: <20111121145114.049265181@chello.nl>
 <20111121145337.533322271@chello.nl>
 <20111121172323.GH20611@mudshark.cambridge.arm.com>
 <1321903090.28118.21.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321903090.28118.21.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 07:18:10PM +0000, Peter Zijlstra wrote:
> But does ARM have a read PMU counter from userspace
> instruction/capability?

In ARMv7, you can enable user access to the performance counters but the
access is R/W so I don't think it's something we want to do (could interfere
with another task doing system-wide profiling).

> Lacking that its all moot of course. If it does, it would be nice to
> have an ARM version of patch 6.

Well we'd need a way to get around the all-or-nothing user access to the PMU
and also the fact that we don't always have a user-readable clocksource.

Either way, the event counters are indexed from 0 on ARMv7 so we should
use perf_event_idx_default.

Will

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab1KVLrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:47:09 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52688 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755587Ab1KVLrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:47:07 -0500
Date: Tue, 22 Nov 2011 11:47:00 +0000
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
        Vince Weaver <vince@deater.net>,
        "ostrikov@nvidia.com" <ostrikov@nvidia.com>
Subject: Re: [RFC][PATCH 2/6] perf, arch: Rework perf_event_index()
Message-ID: <20111122114700.GJ20518@mudshark.cambridge.arm.com>
References: <20111121145114.049265181@chello.nl>
 <20111121145337.533322271@chello.nl>
 <20111121172323.GH20611@mudshark.cambridge.arm.com>
 <1321903090.28118.21.camel@twins>
 <20111121203145.GA7301@mudshark.cambridge.arm.com>
 <1321907755.28118.30.camel@twins>
 <20111121224343.GA7862@mudshark.cambridge.arm.com>
 <1321961180.5148.31.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321961180.5148.31.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:26:20AM +0000, Peter Zijlstra wrote:
> On Mon, 2011-11-21 at 22:43 +0000, Will Deacon wrote:
> > Perhaps we could disable it while per-cpu events are running, although I
> > think this will probably just lead to SIGILL central for anybody trying to
> > use the counters in userspace.
> 
> One possibility would be to do as I did in patch 4, except ARM has it
> disabled by default and the folks who think they know WTF they're doing
> can enable it or so.

The problem is that everybody thinks they know WTF they're doing!

> Ostrikov mentioned on #kernelnewbies he wanted to have this enabled
> because apparently games use it. He mentioned toggling the user access
> on/off depending on if the kernel was using perf or not, but that would
> create very unreliable service.

Well we already have a reserve/release PMU thing which perf honours so we
could conceivably do this. I still reckon this will just lead to SIGILLs in
userspace though because we can't sanely notify tasks that they should leave
the PMU alone for a bit.

> Best would be to use perf to program the thing and use the userspace
> read and simply agree not to write to these registers (and pray people
> don't)..

But you know that the first thing people will do is zero the registers.

> Also, for those ARMs that do have a user readable clock, you could
> support the new time_{mult,shift,offset} from patch 5.

The user-readable clock will first appear in Cortex-A15, so the code for
that still needs to hit mainline before I can look at doing this in perf.

Will

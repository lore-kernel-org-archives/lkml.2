Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab1KVL0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:26:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38239 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab1KVL0q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:26:46 -0500
Message-ID: <1321961180.5148.31.camel@twins>
Subject: Re: [RFC][PATCH 2/6] perf, arch: Rework perf_event_index()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Will Deacon <will.deacon@arm.com>
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
        Vince Weaver <vince@deater.net>, ostrikov@nvidia.com
Date: Tue, 22 Nov 2011 12:26:20 +0100
In-Reply-To: <20111121224343.GA7862@mudshark.cambridge.arm.com>
References: <20111121145114.049265181@chello.nl>
	 <20111121145337.533322271@chello.nl>
	 <20111121172323.GH20611@mudshark.cambridge.arm.com>
	 <1321903090.28118.21.camel@twins>
	 <20111121203145.GA7301@mudshark.cambridge.arm.com>
	 <1321907755.28118.30.camel@twins>
	 <20111121224343.GA7862@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 22:43 +0000, Will Deacon wrote:
> On Mon, Nov 21, 2011 at 08:35:55PM +0000, Peter Zijlstra wrote:
> > On Mon, 2011-11-21 at 20:31 +0000, Will Deacon wrote:
> > > On Mon, Nov 21, 2011 at 07:18:10PM +0000, Peter Zijlstra wrote:
> > > > But does ARM have a read PMU counter from userspace
> > > > instruction/capability?
> > > 
> > > In ARMv7, you can enable user access to the performance counters but the
> > > access is R/W so I don't think it's something we want to do (could interfere
> > > with another task doing system-wide profiling).
> > 
> > Yeah, write access is pushing it a bit.. 
> 
> Perhaps we could disable it while per-cpu events are running, although I
> think this will probably just lead to SIGILL central for anybody trying to
> use the counters in userspace.

One possibility would be to do as I did in patch 4, except ARM has it
disabled by default and the folks who think they know WTF they're doing
can enable it or so.

Ostrikov mentioned on #kernelnewbies he wanted to have this enabled
because apparently games use it. He mentioned toggling the user access
on/off depending on if the kernel was using perf or not, but that would
create very unreliable service.

Best would be to use perf to program the thing and use the userspace
read and simply agree not to write to these registers (and pray people
don't)..

Also, for those ARMs that do have a user readable clock, you could
support the new time_{mult,shift,offset} from patch 5.



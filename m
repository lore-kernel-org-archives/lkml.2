Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab1KUTSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:18:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39370 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab1KUTSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:18:48 -0500
Message-ID: <1321903090.28118.21.camel@twins>
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
        Vince Weaver <vince@deater.net>
Date: Mon, 21 Nov 2011 20:18:10 +0100
In-Reply-To: <20111121172323.GH20611@mudshark.cambridge.arm.com>
References: <20111121145114.049265181@chello.nl>
	 <20111121145337.533322271@chello.nl>
	 <20111121172323.GH20611@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 17:23 +0000, Will Deacon wrote:
> Hi Peter,
> 
> On Mon, Nov 21, 2011 at 02:51:16PM +0000, Peter Zijlstra wrote:
> > Put the logic to compute the event index into a per pmu method. This
> > is required because the x86 rules are weird and wonderful and don't
> > match the capabilities of the current scheme.
> > 
> > AFAIK only powerpc actually has a usable userspace read of the PMCs
> > but I'm not at all sure anybody actually used that.
> > 
> > ARM looks like it cared, but I really wouldn't know, Will?
> 
> It used to care, but it doesn't anymore. Feel free to make the offset 0 and
> use the (now) generic codepath.
> 
> With that:
> 
> Acked-by: Will Deacon <will.deacon@arm.com>


But does ARM have a read PMU counter from userspace
instruction/capability?

Lacking that its all moot of course. If it does, it would be nice to
have an ARM version of patch 6.

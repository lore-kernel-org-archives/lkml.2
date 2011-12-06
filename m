Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327Ab1LFLE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 06:04:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43982 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933153Ab1LFLEZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 06:04:25 -0500
Message-ID: <1323169412.32012.69.camel@twins>
Subject: Re: [PATCH 00/12] perf_events: add support for sampling taken
 branches (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Stephane Eranian <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "acme@redhat.com" <acme@redhat.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        "ravitillo@lbl.gov" <ravitillo@lbl.gov>,
        "paulus@samba.org" <paulus@samba.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>
Date: Tue, 06 Dec 2011 12:03:32 +0100
In-Reply-To: <20111206094927.GA25782@mudshark.cambridge.arm.com>
References: <1318595833-29984-1-git-send-email-eranian@google.com>
	 <1323124766.32012.49.camel@twins>
	 <20111206094927.GA25782@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-06 at 09:49 +0000, Will Deacon wrote:
> On Mon, Dec 05, 2011 at 10:39:26PM +0000, Peter Zijlstra wrote:
> > On Fri, 2011-10-14 at 14:37 +0200, Stephane Eranian wrote:
> > > This patchset adds an important and useful new feature to
> > > perf_events: branch stack sampling. In other words, the
> > > ability to capture taken branches into each sample.
> > > 
> > Other than the few comments given it all looks good. My main worry is
> > the Intel only aspect, I'd really love for there to be another platform
> > that could implement at least part of this.
> 
> I discussed this with Stephane in Prague and, although it would be lovely to
> have this on ARM, we simply don't have the hardware to do it. So the nature
> of series does seem to be x86-centric unless there's way to do a watered
> down version in software.

The only way to do this in software would be like
CONFIG_PROFILE_ALL_BRANCHES and that's horrid (and kernel only).

But there's more than Intel & ARM, but it looks like PPC doesn't have
this either and I suspect MIPS and SPARC don't either, which doesn't
leave us with much else.

So I guess we should just go ahead and merge this and hope more hardware
grows this feature in a compatible enough manner.

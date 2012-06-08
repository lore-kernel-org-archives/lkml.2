Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab2FHNyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:54:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58493 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab2FHNym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:54:42 -0400
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <20120608135117.GB31359@aftab.osrc.amd.com>
References: <20120607071531.GA4849@quad> <1339064319.23343.13.camel@twins>
	 <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
	 <1339065932.23343.18.camel@twins>
	 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
	 <1339067757.23343.21.camel@twins> <20120608093513.GA22520@gmail.com>
	 <1339149613.23343.52.camel@twins> <1339161972.2507.13.camel@laptop>
	 <20120608135117.GB31359@aftab.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jun 2012 15:54:29 +0200
Message-ID: <1339163669.2507.16.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 15:51 +0200, Borislav Petkov wrote:
> Reportedly, there are some obscure systems which need different
> microcode versions per CPU:
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/1105.3/01010.html

*groan*,.. ok.

> > The biggest problem is finding when the minimum revision changes, at
> > best this is a n log n sorting problem due to the per-cpu setup, but I
> > couldn't be arsed to implement a tree or anything fancy since it all
> > stinks anyway.
> 
> I know. Can't you just iterate over all CPUs and collect the lowest
> ucode version? Provided, of course, newer microcode versions means a
> higher version number. 

That's what I do.. but that's O(n) per cpu, so if you update all cpus,
that's O(n^2).

You don't know when userspace is done updating the 'last' cpu, so you
have to scan all cpus for every cpu.

I'm sure the SGI people with their silly CPU counts aren't too thrilled
to have this.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734Ab2FHOVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:21:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:45073 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246Ab2FHOVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:21:02 -0400
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <20120608141543.GD31359@aftab.osrc.amd.com>
References: <1339064319.23343.13.camel@twins>
	 <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
	 <1339065932.23343.18.camel@twins>
	 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
	 <1339067757.23343.21.camel@twins> <20120608093513.GA22520@gmail.com>
	 <1339149613.23343.52.camel@twins> <1339161972.2507.13.camel@laptop>
	 <20120608135117.GB31359@aftab.osrc.amd.com>
	 <1339163669.2507.16.camel@laptop>
	 <20120608141543.GD31359@aftab.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jun 2012 16:20:50 +0200
Message-ID: <1339165250.2507.27.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 16:15 +0200, Borislav Petkov wrote:
> have a variable which gets initialized to the number of all CPUs and
> each time ->apply_microcode() finishes by returning 0, we decrement it
> once.

> 
> Hmm, I'm probably missing some obscure case. 

Since its all per-cpu sysfs muck, userspace could update a random
subsets of cpus.. leaving us hanging.

The 'bestestet' idea I came up with is doing the verify thing I have
from a delayed work -- say 1 second into the future. That way, when
there's lots of cpus they all try and enqueue the one work, which at the
end executes only once, provided the entire update scan took less than
the second.

But yuck..


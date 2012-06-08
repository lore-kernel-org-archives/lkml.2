Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab2FHSw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 14:52:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52032 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2FHSw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 14:52:26 -0400
Message-ID: <1339181537.30462.7.camel@twins>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Date: Fri, 08 Jun 2012 20:52:17 +0200
In-Reply-To: <20120608180505.GA4171@aftab.osrc.amd.com>
References: <20120607071531.GA4849@quad> <1339064319.23343.13.camel@twins>
	 <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
	 <1339065932.23343.18.camel@twins>
	 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
	 <1339067757.23343.21.camel@twins> <20120608093513.GA22520@gmail.com>
	 <1339149613.23343.52.camel@twins> <1339161972.2507.13.camel@laptop>
	 <20120608180505.GA4171@aftab.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 20:05 +0200, Borislav Petkov wrote:
> How about this: since the ucode cannot be downgraded and since higher
> ucode versions are supposed to fix current and older problems (otherwise
> ucoders will get an earlfull) you shouldn't be needing to verify the
> ucode version on all CPUs per-CPU, i.e. the O(n^2) overhead.
> 
> Rather, simply track which CPUs _haven't_ been updated yet, and once
> this is the empty set, run the verify thing to check ucode version on
> all CPUs.
> 
> And this should happen only when we update ucode from version A to
> version B, where B > A.
> 
> And unless I'm missing something, this should be O(n) and ucode update
> should happen very seldomly anyway. 

Checking a bitmap of n bits for being all zero is O(n), so the total is
still O(n^2). Still, probably faster than the for_each_online_cpu() scan
I do now.



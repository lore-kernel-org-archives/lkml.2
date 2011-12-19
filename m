Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab1LSK43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 05:56:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43113 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228Ab1LSK4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 05:56:25 -0500
Date: Mon, 19 Dec 2011 11:54:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Benjamin Block <bebl@mageta.org>, Hans Rosenfeld <hans.rosenfeld@amd.com>,
        hpa@zytor.com, tglx@linutronix.de, suresh.b.siddha@intel.com,
        eranian@google.com, brgerst@gmail.com, Andreas.Herrmann3@amd.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Block <benjamin.block@amd.com>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
Message-ID: <20111219105429.GC19861@elte.hu>
References: <20111216160757.GL665@escobedo.osrc.amd.com>
 <1324051943-21112-1-git-send-email-hans.rosenfeld@amd.com>
 <1324051943-21112-4-git-send-email-hans.rosenfeld@amd.com>
 <20111218080443.GB4144@elte.hu>
 <ae462f089fd4375fe44b09361fb955af@server102.greatnet.de>
 <20111218234309.GA12958@elte.hu>
 <20111219090923.GB16765@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219090923.GB16765@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> On 19.12.11 00:43:10, Ingo Molnar wrote:
>
> > So the question becomes, how well is it integrated: can perf 
> > 'record -a + perf report', or 'perf top' use LWP, to do 
> > system-wide precise [user-space] profiling and such?
> 
> There is only self-monitoring of a process possible, no kernel 
> and system-wide profiling. This is because we can not allocate 
> memory regions in the kernel for a thread other than the 
> current. This would require a complete rework of mm code.

Hm, i don't think a rework is needed: check the 
vmalloc_to_page() code in kernel/events/ring_buffer.c. Right now 
CONFIG_PERF_USE_VMALLOC is an ARM, MIPS, SH and Sparc specific 
feature, on x86 it turns on if CONFIG_DEBUG_PERF_USE_VMALLOC=y.

That should be good enough for prototyping the kernel/user 
shared buffering approach.

Thanks,

	Ingo

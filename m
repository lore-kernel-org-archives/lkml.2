Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab2FLU6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 16:58:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45790 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab2FLU6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 16:58:47 -0400
Message-ID: <4FD7AD6F.6010008@zytor.com>
Date: Tue, 12 Jun 2012 13:58:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on SandyBridge
References: <20120607071531.GA4849@quad> <4FD78BE6.4060207@zytor.com> <20120612190720.GA11137@aftab.osrc.amd.com> <1339529614.31548.104.camel@twins> <20120612194900.GC11137@aftab.osrc.amd.com> <4FD7A687.3040500@zytor.com> <20120612203730.GE11137@aftab.osrc.amd.com> <4FD7A99F.8030007@zytor.com> <20120612205609.GF11137@aftab.osrc.amd.com>
In-Reply-To: <20120612205609.GF11137@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 01:56 PM, Borislav Petkov wrote:
> On Tue, Jun 12, 2012 at 01:42:07PM -0700, H. Peter Anvin wrote:
>> I personally don't know of any valid use case for per-core loads, and
>> it sounds like a horrid idea.
> 
> Vehemently agreed.
> 
> However, last time we talked about Ingo mentioned some possibility
> of having different microcode versions on different CPUs:
> http://lkml.indiana.edu/hypermail/linux/kernel/1105.3/00749.html
> 
> Hmm...
> 
>> And yes, I would prefer a single sysfs file, or better yet a plain old
>> device node.
> 
> Also agreed.
> 

There is a difference here.  Mixed steppings or even mixed CPUs are,
indeed, supported (even things like Nehalem + Westmere in the same
system).  However, the notion is that we should upload the *entire set*
of microcodes to the kernel, and let it flash the appropriate one into
each CPU.

This may result in different version number on different CPUs.

	-hpa

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab2KPKGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 05:06:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab2KPKGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 05:06:09 -0500
Date: Fri, 16 Nov 2012 08:05:48 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        David Sharp <dhsharp@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Re: [RFC PATCH 0/2] kvm/vmx: Output TSC offset
Message-ID: <20121116100548.GA20892@amt.cnet>
References: <20121114013611.5338.15086.stgit@yunodevel>
 <20121116031946.GA23939@amt.cnet>
 <50A5F4C4.2030909@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A5F4C4.2030909@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 05:09:40PM +0900, Yoshihiro YUNOMAE wrote:
> Hi Marcelo,
> 
> Thank you for commenting on my patch set.
> 
> (2012/11/16 12:19), Marcelo Tosatti wrote:
> >On Wed, Nov 14, 2012 at 10:36:21AM +0900, Yoshihiro YUNOMAE wrote:
> [...]
> >>In this summary, I suggest the patch which TSC offset for each guest can be
> >>output on the host.
> >
> >The guest TSC can change (for example if TSC scaling is used). Moreover
> >TSC offset can change, and you'd have to monitor that. What
> 
> Yes, that's true. Changing TSC offset is the key point to use TSC for
> merging trace data of guests and the host.
> 
> >about a module option so that tsc_offset is written as zero (to be
> >used as debugging tool). Then the following restrictions apply:
> >
> >- TSC must be synchronized across CPUs/VCPUS.
> >- TSC must be reliable.
> >
> >Would that suffice? (a module option to kvm.ko, say zero_tsc_offset).
> 
> As you say, the guest TSC can change, so guest TSC needs to meet these
> two restrictions to merge the trace data in chronological order.
> 
> However, the zero-TSC offset method is not enough, I think.
> I will use TSC values as the tracing timestamp not only for debugging
> but for failure analysis on actual operations. When we introduce
> the zero-TSC offset, normally it will be no problem. However, if
> the guest executes write_tsc or the guest works live migration, TSC
> offset will be changed. After all, we need to monitor the TSC offset
> value.
> 
> Thank you,

What i wrote was not precise.

With TSC scaling (of AMD's svm.c) or TSC trapping, the guest RDTSC is
not monotonic with reference to the host TSC. That is, TSC scaling
and/or trapping are fundamentally incompatible with the feature you
propose.

What you are saying is that is you'd like this feature for production,
not debugging. Unfortunately this requires a synchronized TSC across
CPUs, which is not widespread. Therefore the suggestion to introduce a
debugging facility (you cannot rely on this for failure analysis on all
systems).

Even then, a more reliable method for reporting TSC offset must be used.

Apart from these issues, it is very useful to correlate guest/host
events in the way you propose.


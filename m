Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab1ELJV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 05:21:57 -0400
Received: from 8bytes.org ([88.198.83.132]:47261 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873Ab1ELJVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 05:21:55 -0400
Date: Thu, 12 May 2011 11:21:53 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        benh <benh@kernel.crashing.org>, Anton Blanchard <anton@samba.org>,
        davem <davem@davemloft.net>
Subject: Re: [PATCH 2/3] perf, x86: Use GO/HO bits in perf-ctr
Message-ID: <20110512092153.GC8707@8bytes.org>
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com> <1305038132-5080-3-git-send-email-joerg.roedel@amd.com> <1305038900.2914.97.camel@laptop> <20110510150412.GB30996@amd.com> <4DCA87FA.4070902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCA87FA.4070902@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 03:58:34PM +0300, Avi Kivity wrote:
> On 05/10/2011 06:04 PM, Roedel, Joerg wrote:
>> On Tue, May 10, 2011 at 10:48:20AM -0400, Peter Zijlstra wrote:
>> >  On Tue, 2011-05-10 at 16:35 +0200, Joerg Roedel wrote:
>> >  >  The AMD perf-counters support counting in guest or host-mode
>> >  >  only. Make use of that feature when user-space specified
>> >  >  guest/host-mode only counting.
>> >
>> >  Subject mentions x86, does Intel have anything similar so you can make
>> >  it work for them too?
>>
>> Intel does not support guest or host-only counting in the hardware (at
>> least according to my documentation). If wanted it could be approximated by
>> enabling/disabling the counters in the guest-entry path.
>
> vmx has support for atomically swapping MSRs during guest entry and exit  
> (you can load guest MSRs on entry, save guest MSRs on exit, and load  
> host MSRs on exit, but you can't save host MSRs on entry, so host-only  
> counters cannot be 100% accurate).  We'd need some kvm/perf hooks to  
> program these MSR swaps, and to manually save the counters that cannot  
> be done automatically.

Well, wenn host counters are not saved on vmentry then we just need to
save them manually (which is a one-time thing and does not need to
happen at every vmentry).
Thanks for that information, when I am back in office on monday I'll try
to grab a machine and hopefully get this running.

> btw, your patchset can be further improved by integrating  
> exclude_guest/exclude_host into the constraints.  For example if we have  
> three general purpose counters, two generic perf_events in user, one  
> exclude_guest perf_event, and one exclude_host perf_event, we can  
> schedule them all at all times, swapping the exclude_guest and  
> exclude_host events during guest entry/exit.

Well, it will need some additional code in the amd vmrun path too. I'll
take a look at it, but probably leave it as a future optimization.
Thanks for the hint.

	Joerg


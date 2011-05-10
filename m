Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab1EJPui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 11:50:38 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.185]:37747
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754320Ab1EJPug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 11:50:36 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LKZLC3-01-0O9-02
X-M-MSG: 
Date: Tue, 10 May 2011 17:50:24 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/3] perf support for amd guest/host-only bits
Message-ID: <20110510155024.GG30996@amd.com>
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
 <20110510152132.GA25705@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110510152132.GA25705@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 11:21:32AM -0400, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > So any feedback is greatly appreciated :-)
> 
> it's nice to see this hw feature utilized :)

Yeah, I planned to do this for some time now and finally found the time
to do it :)

> 
> > Diffstat:
> > 
> >  arch/x86/include/asm/perf_event.h    |    3 +++
> >  arch/x86/kernel/cpu/perf_event_amd.c |    6 ++++++
> >  include/linux/perf_event.h           |    5 ++++-
> >  kernel/perf_event.c                  |    4 ++++
> >  tools/perf/util/parse-events.c       |   10 +++++++++-
> >  5 files changed, 26 insertions(+), 2 deletions(-)
> 
> I see you have not touched tools/perf/builtin-kvm.c - how does this feature 
> integrate with the features of 'perf kvm'? (are you using perf kvm by any 
> chance?)

builtin-kvm looks like a wrapper for other perf-cmds which just sets up
some additional state to tell the sub-cmds that guest-symbols need to be
resolved and so on.
Implementing this into the place where the other exclude-bits get set
(which is in generic code) seemed like a good idea to me. Touching
builtin-kvm was unnecessary for this.

Regards,

	Joerg



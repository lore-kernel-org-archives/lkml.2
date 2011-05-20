Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935669Ab1ETLxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 07:53:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42508 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935640Ab1ETLx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 07:53:26 -0400
Date: Fri, 20 May 2011 13:53:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@alien8.de>, Don Zickus <dzickus@redhat.com>,
        Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [RFC] ACPI, APEI, Generic Hardware Error Source (GHES) injecting
 support
Message-ID: <20110520115307.GG14745@elte.hu>
References: <1304996921-24881-1-git-send-email-ying.huang@intel.com>
 <20110516193301.GF29881@redhat.com>
 <4DD218B1.7080601@intel.com>
 <20110517135027.GJ31888@redhat.com>
 <20110517191803.GC29574@elte.hu>
 <20110517195757.GA31067@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517195757.GA31067@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Borislav Petkov <bp@alien8.de> wrote:

> On Tue, May 17, 2011 at 09:18:03PM +0200, Ingo Molnar wrote:
> > So for example [sufficienty privileged] user-space could inject *any*
> > perf event - for example a PERF_COUNT_HW_CACHE_MISSES event (for test
> > purposes) and any tooling that runs could not tell apart this injected
> > event from a real event.
> 
> Yeah about that, I was recently speculating how that would work. So do we do
> 
> $ perf record ...
> 
> in the one xterm, and, in the other,
> 
> $ perf inject
> 
> so that while recording, we can inject some events from userspace? Or
> do we inject it, it gets buffered somewhere in the meantime and then
> the next perf record session sees it along with the remaining injection
> events?

Well, for persistent events there would be interim buffering even if there's no 
observation going on anywhere. I.e. there's always an 'observer' of events.

For non-persistent events, if they are injected, then they are like trace 
events for which nobody is interested in: they are lost.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824Ab1EJPIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 11:08:21 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:50919 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab1EJPIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 11:08:19 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LKZJDO-01-7IK-02
X-M-MSG: 
Date: Tue, 10 May 2011 17:08:21 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] perf, tools: Add support for guest/host-only
 profiling
Message-ID: <20110510150821.GC30996@amd.com>
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
 <1305038132-5080-4-git-send-email-joerg.roedel@amd.com>
 <1305039008.2914.98.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1305039008.2914.98.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 10:50:08AM -0400, Peter Zijlstra wrote:
> On Tue, 2011-05-10 at 16:35 +0200, Joerg Roedel wrote:
> > @@ -740,6 +740,12 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
> >                         if (!exclude)
> >                                 exclude = eu = ek = eh = 1;
> >                         eh = 0;
> > +               } else if (*str == 'G') {
> > +                       eg   = 0;
> > +                       ehst = 1;
> > +               } else if (*str == 'H') {
> > +                       eg   = 1;
> > +                       ehst = 0; 
> 
> This doesn't match the existing exclude logic, also eH and eG come to
> mind.

OK, eH and eG seems like a better choice. Regarding the logic I
explictly decided to do it this way. The reason is that guest/host
counting is orthogonal to user/kernel/hv counting. You can decide to
only count guest-kernel for example. And if a user just specifies
-e cycles:G this would automatically exlucde user and kernel counting.
This didn't make sense to me so I decided to keep the logic seperate for
guest/host exclusions.

	Joerg



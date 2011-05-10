Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab1EJPiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 11:38:52 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.186]:10169
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756624Ab1EJPiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 11:38:50 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LKZKSK-02-AH5-02
X-M-MSG: 
Date: Tue, 10 May 2011 17:38:55 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/3] perf, core: Introduce attrs to count in either host
 or guest mode
Message-ID: <20110510153855.GE30996@amd.com>
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
 <1305038132-5080-2-git-send-email-joerg.roedel@amd.com>
 <1305038746.2914.94.camel@laptop>
 <20110510145902.GA30996@amd.com>
 <1305040709.2914.99.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1305040709.2914.99.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 11:18:29AM -0400, Peter Zijlstra wrote:
> On Tue, 2011-05-10 at 16:59 +0200, Roedel, Joerg wrote:
> > On Tue, May 10, 2011 at 10:45:46AM -0400, Peter Zijlstra wrote:
> > > On Tue, 2011-05-10 at 16:35 +0200, Joerg Roedel wrote:
> > > > +       /* Can't exclude counting in guest and in host mode */
> > > > +       if (attr.exclude_host && attr.exclude_guest)
> > > > +               return -EINVAL;
> > > 
> > > Why not?
> > 
> > By definition the counter won't count at all. The hardware just ignores
> > the bits if they are both set. My rationale here was that it does not
> > makes sense to setup a counter and exclude guest and host mode.
> 
> I would expect it to 'work' but simply return 0. If that isn't what the
> AMD hardware does you need to fix that in the AMD driver.

By 'work' you mean that userspace can set it up but it doesn't count at
all in this situation? This would certainly be consistent behavior but I
can't imagine any use-case for it so that this code assumes that such a
situation is most likely a bug.
I can certainly change that if wanted, but I think its better to inform
userspace if we get weird values?

Regards,

	Joerg



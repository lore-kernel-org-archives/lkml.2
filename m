Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012Ab1EJQ0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 12:26:34 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:46501 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727Ab1EJQ0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 12:26:32 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzzz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LKZMYX-02-4CC-02
X-M-MSG: 
Date: Tue, 10 May 2011 18:25:58 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/3] perf, core: Introduce attrs to count in either host
 or guest mode
Message-ID: <20110510162558.GH30996@amd.com>
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
 <1305038132-5080-2-git-send-email-joerg.roedel@amd.com>
 <1305038746.2914.94.camel@laptop>
 <20110510145902.GA30996@amd.com>
 <1305040709.2914.99.camel@laptop>
 <20110510153855.GE30996@amd.com>
 <1305043638.2914.113.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1305043638.2914.113.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 12:07:18PM -0400, Peter Zijlstra wrote:
> On Tue, 2011-05-10 at 17:38 +0200, Roedel, Joerg wrote:
> > On Tue, May 10, 2011 at 11:18:29AM -0400, Peter Zijlstra wrote:
> > > On Tue, 2011-05-10 at 16:59 +0200, Roedel, Joerg wrote:
> > > > On Tue, May 10, 2011 at 10:45:46AM -0400, Peter Zijlstra wrote:
> > > > > On Tue, 2011-05-10 at 16:35 +0200, Joerg Roedel wrote:
> > > > > > +       /* Can't exclude counting in guest and in host mode */
> > > > > > +       if (attr.exclude_host && attr.exclude_guest)
> > > > > > +               return -EINVAL;
> > > > > 
> > > > > Why not?
> > > > 
> > > > By definition the counter won't count at all. The hardware just ignores
> > > > the bits if they are both set. My rationale here was that it does not
> > > > makes sense to setup a counter and exclude guest and host mode.
> > > 
> > > I would expect it to 'work' but simply return 0. If that isn't what the
> > > AMD hardware does you need to fix that in the AMD driver.
> > 
> > By 'work' you mean that userspace can set it up but it doesn't count at
> > all in this situation? 
> 
> Right.
> 
> > This would certainly be consistent behavior but I
> > can't imagine any use-case for it so that this code assumes that such a
> > situation is most likely a bug.
> > I can certainly change that if wanted, but I think its better to inform
> > userspace if we get weird values?
> 
> The eternal how much rope to give and what knots to teach argument I
> guess. As it is, I think we allow people to exclude both user- and
> kernel-space, giving a similar situation, so allowing to exclude both
> host and guest is consistent.

Okay, fine. So I change that.

	Joerg



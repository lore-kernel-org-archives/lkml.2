Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab2DQJhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 05:37:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973Ab2DQJhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 05:37:36 -0400
Date: Tue, 17 Apr 2012 12:37:13 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, acme@ghostprotocols.net,
        mingo@redhat.com, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] perf tools: Add 'G' and 'H' modifiers to event parsing
Message-ID: <20120417093713.GD11918@redhat.com>
References: <20120415145948.GK11918@redhat.com>
 <1334502742.28150.13.camel@twins>
 <20120415152300.GL11918@redhat.com>
 <20120416201030.GB11503@m.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120416201030.GB11503@m.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 10:10:30PM +0200, Jiri Olsa wrote:
> On Sun, Apr 15, 2012 at 06:23:00PM +0300, Gleb Natapov wrote:
> > On Sun, Apr 15, 2012 at 05:12:22PM +0200, Peter Zijlstra wrote:
> > > On Sun, 2012-04-15 at 17:59 +0300, Gleb Natapov wrote:
> > > > -modifier_event [ukhp]{1,5}
> > > > +modifier_event [ukhpGH]{1,5} 
> > > 
> > > You'd also need to increase the 5 to 7 I think, unless there's a clear
> > > exclusion with some of the other flags.
> > > 
> > > Hmm, as it stands I think the 5 is already too low: "ukhppp" is 6.
> > > 
> > > We should really write this as ['u'] ['k'] ['h'] ['G'] ['H'] ['p'{1,3}],
> > > not the combined thing.
> 
> you mean to match them strictly in parser, right?
> because what we have now can match also stuff like 'uuu' 'kkuu' ...
> 
> So far it eludes me how to do that purely in flex and
> doing this via rules in bison seems like overkill.
> 
> I'd rather keep it the way we have and do the extra check
> in parse_events_modifier function.. unless someone comes up
> with flex regular expression that would do that (which is
> possible given my regex knowledge..) 
> 
> also we need 8 characters for it, since this seems to be
> valid modifier: ukhGHppp
> 
So want me to resend with 8 to fix missing GH for now? I can't think of
proper regex either.

--
			Gleb.

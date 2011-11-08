Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab1KHOSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:18:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913Ab1KHOSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:18:52 -0500
Date: Tue, 8 Nov 2011 16:18:25 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net
Subject: Re: [PATCHv2 6/9] perf: expose perf capability to other modules.
Message-ID: <20111108141825.GQ3225@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
 <1320323618-10375-7-git-send-email-gleb@redhat.com>
 <1320674870.18053.37.camel@twins>
 <20111108124906.GO3225@redhat.com>
 <1320758811.11519.1.camel@twins>
 <20111108135432.GP3225@redhat.com>
 <1320761547.11519.3.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320761547.11519.3.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 03:12:27PM +0100, Peter Zijlstra wrote:
> On Tue, 2011-11-08 at 15:54 +0200, Gleb Natapov wrote:
> > Isn't it better to introduce mapping between ebx bits and architectural
> > events and do for_each_set_bit loop?
> 
> Probably, but I only thought of that halfway through ;-)
> 
> >  But I wouldn't want to introduce
> > patch as below as part of this series. 
> 
> Well, since you're actually going to frob cpuid10.ebx bits we had better
> deal with it properly.
OK. We need to figure what is the proper way though. How about me
introducing cpuid10_ebx with event_mask bitmask, mapping array, but
not disabling events for now.

> 
> > I do not want to introduce
> > incidental regressions. For instance the patch below will introduce
> > regression on my Nehalem cpu. It reports value 0x44 in cpuid10.ebx which
> > means that unhalted_reference_cycles is not available (bit set means
> > event is not available), but event still works! Actually it is listed as
> > supported by the cpu in Table A-4 SDM 3B. Go figure. 
> 
> We'd better figure out why your machine says that. It could be we need
> another quirk for the nehalem machines, it could be your BIOS is smoking
> crack and there's nothing we can do about it.
> 
I asked Intel a week (or so) ago. Waiting for an answer. Will try to
find other machines with similar cpu to do more checks meanwhile.

--
			Gleb.

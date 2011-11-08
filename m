Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab1KHObc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:31:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:43256 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab1KHOb3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:31:29 -0500
Subject: Re: [PATCHv2 6/9] perf: expose perf capability to other modules.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net
Date: Tue, 08 Nov 2011 15:31:19 +0100
In-Reply-To: <20111108141825.GQ3225@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
	 <1320323618-10375-7-git-send-email-gleb@redhat.com>
	 <1320674870.18053.37.camel@twins> <20111108124906.GO3225@redhat.com>
	 <1320758811.11519.1.camel@twins> <20111108135432.GP3225@redhat.com>
	 <1320761547.11519.3.camel@twins> <20111108141825.GQ3225@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320762679.11519.8.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-08 at 16:18 +0200, Gleb Natapov wrote:
> On Tue, Nov 08, 2011 at 03:12:27PM +0100, Peter Zijlstra wrote:
> > On Tue, 2011-11-08 at 15:54 +0200, Gleb Natapov wrote:
> > > Isn't it better to introduce mapping between ebx bits and architectural
> > > events and do for_each_set_bit loop?
> > 
> > Probably, but I only thought of that halfway through ;-)
> > 
> > >  But I wouldn't want to introduce
> > > patch as below as part of this series. 
> > 
> > Well, since you're actually going to frob cpuid10.ebx bits we had better
> > deal with it properly.
> OK. We need to figure what is the proper way though. How about me
> introducing cpuid10_ebx with event_mask bitmask, mapping array, but
> not disabling events for now.

Ah, only now that you pointed our those bits are in fact inverted do I
realize you propagate the workaround. So by clearing it you say the
event is supported.

OK. maybe we should change the names of the split to reflect their
inverted nature, although I'm clean out of ideas atm.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965366Ab1JGKce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:32:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:53362 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964862Ab1JGKcd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:32:33 -0400
Subject: Re: [PATCH 01/12] perf_events: add generic taken branch sampling
 support
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov
Date: Fri, 07 Oct 2011 12:32:13 +0200
In-Reply-To: <CABPqkBSNyD0R7o7f_X4u9QD+1G=XXc6mwTmeQbeJzFam=4v_Cg@mail.gmail.com>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	 <1317912555-9559-2-git-send-email-eranian@google.com>
	 <1317920241.29658.14.camel@twins>
	 <CABPqkBSNyD0R7o7f_X4u9QD+1G=XXc6mwTmeQbeJzFam=4v_Cg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317983533.31132.3.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 12:28 +0200, Stephane Eranian wrote:
> On Thu, Oct 6, 2011 at 6:57 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, 2011-10-06 at 16:49 +0200, Stephane Eranian wrote:
> >>  struct perf_branch_entry {
> >>         __u64                           from;
> >>         __u64                           to;
> >> +       struct {
> >> +               __u64                   mispred:1,  /* target mispredicted */
> >> +                                       predicted:1,/* target predicted */
> >> +                                       reserved:62;
> >> +       };
> >>  };
> >
> > Why that anonymous structure?
> >
> The interface can return more than source/destination, it can also
> return prediction infos.
> Prediction is boolean, thus we only need a couple of bits. The reason
> there are two bits
> and not just one is to disambiguate between: predicted correctly and
> 'prediction reporting
> unsupported'. For instance, prediction is also supported since
> Nehalem, Core2/Atom do
> not have it.

Right, I got that.

> But maybe you're just commenting of the anonymous vs. named struct for
> that?

I don't see the need for any struct, why can't the bitfield live in
perf_branch_entry proper?

> It is just for convenience. Isn't that the same argument for the
> anonymous bitfield
> in struct perf_event_attr? 

But that isn't wrapped in a structure either is it..

I guess I'm asking, what's wrong with:

struct perf_branch_entry {
	__u64		from;
	__u64		to;
	__u64		mispred:1,
			predicted:1,
			reserved:62;
};

?

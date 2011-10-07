Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965401Ab1JGKoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:44:39 -0400
Received: from smtp-out.google.com ([74.125.121.67]:7956 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965118Ab1JGKoh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:44:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=xQyovh367e/lMWHr7wnAdx/zoK9+42dfvZylVfMoA7BfUQSbpbC+xUBasPUGAiYnR
	tmkLCDtBUprxy+dFB5rnQ==
MIME-Version: 1.0
In-Reply-To: <1317983533.31132.3.camel@twins>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	<1317912555-9559-2-git-send-email-eranian@google.com>
	<1317920241.29658.14.camel@twins>
	<CABPqkBSNyD0R7o7f_X4u9QD+1G=XXc6mwTmeQbeJzFam=4v_Cg@mail.gmail.com>
	<1317983533.31132.3.camel@twins>
Date: Fri, 7 Oct 2011 12:44:34 +0200
Message-ID: <CABPqkBRmgTNzTx8STQuW4M+tMmD-L+6V+aX-Jf1Bh75nBb_TwA@mail.gmail.com>
Subject: Re: [PATCH 01/12] perf_events: add generic taken branch sampling support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 12:32 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2011-10-07 at 12:28 +0200, Stephane Eranian wrote:
>> On Thu, Oct 6, 2011 at 6:57 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Thu, 2011-10-06 at 16:49 +0200, Stephane Eranian wrote:
>> >>  struct perf_branch_entry {
>> >>         __u64                           from;
>> >>         __u64                           to;
>> >> +       struct {
>> >> +               __u64                   mispred:1,  /* target mispredicted */
>> >> +                                       predicted:1,/* target predicted */
>> >> +                                       reserved:62;
>> >> +       };
>> >>  };
>> >
>> > Why that anonymous structure?
>> >
>> The interface can return more than source/destination, it can also
>> return prediction infos.
>> Prediction is boolean, thus we only need a couple of bits. The reason
>> there are two bits
>> and not just one is to disambiguate between: predicted correctly and
>> 'prediction reporting
>> unsupported'. For instance, prediction is also supported since
>> Nehalem, Core2/Atom do
>> not have it.
>
> Right, I got that.
>
>> But maybe you're just commenting of the anonymous vs. named struct for
>> that?
>
> I don't see the need for any struct, why can't the bitfield live in
> perf_branch_entry proper?
>
>> It is just for convenience. Isn't that the same argument for the
>> anonymous bitfield
>> in struct perf_event_attr?
>
> But that isn't wrapped in a structure either is it..
>
> I guess I'm asking, what's wrong with:
>
> struct perf_branch_entry {
>        __u64           from;
>        __u64           to;
>        __u64           mispred:1,
>                        predicted:1,
>                        reserved:62;
> };
>
Ok, I think I missed your original point about the anonymous
struct. What you're suggesting above is certainly fine with me.
I am not just used to bitfields mixed with other fields in a struct.
I'll fix that.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965163Ab1JGK2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:28:52 -0400
Received: from smtp-out.google.com ([74.125.121.67]:1140 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759688Ab1JGK2v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:28:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=oR79T7Diyuw38QvaSRKXfUbWGrIpCS/ZIjQx+/WUhfxYDpxt2i+KGeJdPsW+hYs7y
	AISM3lz5f7vOUJ4Ds5tDA==
MIME-Version: 1.0
In-Reply-To: <1317920241.29658.14.camel@twins>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	<1317912555-9559-2-git-send-email-eranian@google.com>
	<1317920241.29658.14.camel@twins>
Date: Fri, 7 Oct 2011 12:28:47 +0200
Message-ID: <CABPqkBSNyD0R7o7f_X4u9QD+1G=XXc6mwTmeQbeJzFam=4v_Cg@mail.gmail.com>
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

On Thu, Oct 6, 2011 at 6:57 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2011-10-06 at 16:49 +0200, Stephane Eranian wrote:
>>  struct perf_branch_entry {
>>         __u64                           from;
>>         __u64                           to;
>> +       struct {
>> +               __u64                   mispred:1,  /* target mispredicted */
>> +                                       predicted:1,/* target predicted */
>> +                                       reserved:62;
>> +       };
>>  };
>
> Why that anonymous structure?
>
The interface can return more than source/destination, it can also
return prediction infos.
Prediction is boolean, thus we only need a couple of bits. The reason
there are two bits
and not just one is to disambiguate between: predicted correctly and
'prediction reporting
unsupported'. For instance, prediction is also supported since
Nehalem, Core2/Atom do
not have it.
But maybe you're just commenting of the anonymous vs. named struct for that?
It is just for convenience. Isn't that the same argument for the
anonymous bitfield
in struct perf_event_attr?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1HZMCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 08:02:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12732 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1HZMCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 08:02:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=agbxmBFrBW2HeH8aI20IrIPMKJD6supUO+TK637S++T03Z0TbgqTv/x5YVrdVy8MR
	FKi7FHLyNqyn+BByw2U8Q==
MIME-Version: 1.0
In-Reply-To: <1314293560.27911.38.camel@twins>
References: <CABPqkBS_Og3Vbe90xwyzA8S5ftfF08gMtJdtpqQTHFOwm+CAkg@mail.gmail.com>
	<1314293560.27911.38.camel@twins>
Date: Fri, 26 Aug 2011 14:02:02 +0200
Message-ID: <CABPqkBSaW3ShYbJoO6YdFpZ7Rt+OfszP8m-uLSoBjCWZYVQ0Bw@mail.gmail.com>
Subject: Re: [BUG] perf_event: semantic of PERF_SAMPLE_READ unclear
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
        Robert Richter <robert.richter@amd.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 7:32 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2011-08-25 at 19:19 +0200, Stephane Eranian wrote:
>> But the difficulty is that
>> we cannot grab any locks, not sure we need one given the call path.
>
> Nah we should be able to simply iterate all siblings and update them
> in-place, since its group members they should all be co-scheduled. The
> only difficulty is cross pmu group members..
>
Are we allowing event from different PMU to be in the same event group?
If so, is that useful?

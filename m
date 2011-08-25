Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab1HYVYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 17:24:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52439 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab1HYVYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 17:24:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=CpvaG8tk0U2nIWeatqQPef/kndumsN/YP16gl6my3zHJnVq6RqMNOomK5IgHI0akZ
	/K/CLme4dwMV7X7idWlbQ==
MIME-Version: 1.0
In-Reply-To: <1314293560.27911.38.camel@twins>
References: <CABPqkBS_Og3Vbe90xwyzA8S5ftfF08gMtJdtpqQTHFOwm+CAkg@mail.gmail.com>
	<1314293560.27911.38.camel@twins>
Date: Thu, 25 Aug 2011 23:24:10 +0200
Message-ID: <CABPqkBTNx02J__sO89++u4B+zipi5hgCZviiz=drer9FpAMqGQ@mail.gmail.com>
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
Yes, that's what I thought, we should be able to invoke an arch callback
to update the SW counter then we proceed with perf_event_count().

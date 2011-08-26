Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab1HZMIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 08:08:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14944 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab1HZMIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 08:08:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=GYZz5C479KeY3jlo4P2l8uI2j9Ywm0eR1vqtXj6HE0IhhGbnpUugQ3ihTRA6KFR7x
	UDrg8ZTA98lN+xPxDtZOA==
MIME-Version: 1.0
In-Reply-To: <CABPqkBSaW3ShYbJoO6YdFpZ7Rt+OfszP8m-uLSoBjCWZYVQ0Bw@mail.gmail.com>
References: <CABPqkBS_Og3Vbe90xwyzA8S5ftfF08gMtJdtpqQTHFOwm+CAkg@mail.gmail.com>
	<1314293560.27911.38.camel@twins>
	<CABPqkBSaW3ShYbJoO6YdFpZ7Rt+OfszP8m-uLSoBjCWZYVQ0Bw@mail.gmail.com>
Date: Fri, 26 Aug 2011 14:08:07 +0200
Message-ID: <CABPqkBRXJPMqbdxAdapc0YtqKgZZubo2iFEhsV8VxpDG4WM9Sg@mail.gmail.com>
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

Ok, forget what I said, I think the current code is fine.

perf_output_read_group() does call event->pmu->read() which
calls x86_perf_event_update(). And this routine does read the
actual counter. So you do get the latest version possible.


On Fri, Aug 26, 2011 at 2:02 PM, Stephane Eranian <eranian@google.com> wrote:
> On Thu, Aug 25, 2011 at 7:32 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Thu, 2011-08-25 at 19:19 +0200, Stephane Eranian wrote:
>>> But the difficulty is that
>>> we cannot grab any locks, not sure we need one given the call path.
>>
>> Nah we should be able to simply iterate all siblings and update them
>> in-place, since its group members they should all be co-scheduled. The
>> only difficulty is cross pmu group members..
>>
> Are we allowing event from different PMU to be in the same event group?
> If so, is that useful?
>

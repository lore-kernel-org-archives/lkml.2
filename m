Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007Ab1F1PzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:55:05 -0400
Received: from smtp-out.google.com ([74.125.121.67]:57390 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758924Ab1F1Pxg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:53:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=ApkIdYsjZA0rGPBmYtBM4hrFezIGIQpLOOWVHgb4zyIK6UObGvC/VI0SbrnB0EXKE
	RFa97qDUG7SSZ2Y+WMCOw==
MIME-Version: 1.0
In-Reply-To: <20110628154646.GH1159@sun>
References: <20110623124918.GC13050@sun>
	<20110627190358.GQ3765@redhat.com>
	<20110627193201.GB1159@sun>
	<CABPqkBTE_6ma70ZQbbz1NnznCGB7YO74kmL+=fP66qFVvVFLBw@mail.gmail.com>
	<20110628152827.GE1159@sun>
	<20110628153731.GY3765@redhat.com>
	<20110628154422.GG1159@sun>
	<20110628154646.GH1159@sun>
Date: Tue, 28 Jun 2011 17:53:31 +0200
Message-ID: <CABPqkBS4ukQ-asVD68MR_Bb_E89+EcHOcMP3Vv=RMJ9RnuYBSw@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Add hw_watchdog_set_attr() in a sake of
 nmi-watchdog on P4
From: Stephane Eranian <eranian@google.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyril,

#ifdef CONFIG_HARDLOCKUP_DETECTOR
+void __weak hw_nmi_watchdog_set_attr(struct perf_event_attr *wd_attr) { }


The weak function has to remain inside the #ifdef. Remember it's just an
override in case you cannot using the generic cycle event. It is only needed
when you have the HARDLOCK detector, i.e., are using the PMU to detect
deadlocks.

I suspect P4 may be the only one so far which exhibited a problem there.


On Tue, Jun 28, 2011 at 5:46 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Tue, Jun 28, 2011 at 07:44:22PM +0400, Cyrill Gorcunov wrote:
>> On Tue, Jun 28, 2011 at 11:37:31AM -0400, Don Zickus wrote:
>> > On Tue, Jun 28, 2011 at 07:28:27PM +0400, Cyrill Gorcunov wrote:
>> > > On Tue, Jun 28, 2011 at 05:24:36PM +0200, Stephane Eranian wrote:
>> > > ...
>> > > > >
>> > > > > Yeah, not the _best_ place. Not sure too where to put it, patches are welcome ;)
>> > > > >
>> > > > No matter what, this file has to remain in a file that's common to all arch.
>> > >
>> > > well, hard to say, Stephane, nmi-watchdog is x86 specific as far as I know.
>> >
>> > No, other arches have similar mechanisms.  Actually I think sparc
>> > copied-n-pasted an old implementation of the nmi_watchdog on x86.
>>
>> Mind to point me where it lives?
>
> Indeed, at least SPARC has it as well. Thanks for clarification!
>
>>
>> >
>> > It is just all we hear about is the watchdog on x86.
>> >
>> > Cheers,
>> > Don
>>
>>       Cyrill
>
>        Cyrill
>

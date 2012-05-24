Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab2EXI7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 04:59:31 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58521 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752391Ab2EXI73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 04:59:29 -0400
MIME-Version: 1.0
In-Reply-To: <1337846873.9783.66.camel@laptop>
References: <1337828525-1789-1-git-send-email-namhyung.kim@lge.com>
	<1337844471.9783.48.camel@laptop>
	<CABPqkBRcz1a738M7g484B0p-dJrKqP6GSLE7gpPN0H1w-72oWw@mail.gmail.com>
	<1337845936.9783.57.camel@laptop>
	<1337846272.9783.59.camel@laptop>
	<CABPqkBQDpoQChAB_GmhuGStPEdjGUVkAg5cE=zH143L9u8pN-A@mail.gmail.com>
	<1337846873.9783.66.camel@laptop>
Date: Thu, 24 May 2012 10:59:27 +0200
Message-ID: <CABPqkBSbJ4D-CG-HjZjympLxuV7GqjgwCmak5_UX7OcxkXiVvA@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Make cycles:p working on SNB
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 10:07 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2012-05-24 at 10:00 +0200, Stephane Eranian wrote:
>> On Thu, May 24, 2012 at 9:57 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Thu, 2012-05-24 at 09:52 +0200, Peter Zijlstra wrote:
>> >>
>> >> OK, so how about I queue the below and if the u-code updates gets
>> >> released before this hits Linus' tree we'll make it all go away ;-)
>> >>
>> > Also, I suspect the u-code update might make INST_RETIRED.ANY_P
>> > available on SNB again voiding the need to use a different encoding. But
>> > we'll cross that bridge when we'll get to it.
>>
>> The PREC_DIST is by design, it is not a work-around of any sort.
>> It is an attempt at getting a better distribution of samples when sampling
>> with inst_retired.
>
> Oh completely agreed, note that my patch used UOPS_RETIRED.ALL. Only
> Namhyung used PREC_DIST, mostly I suspect because he's not stared at all
> these manuals for long yet ;-)
>
PREC_DIST is only meaningful when used with PEBS. This is where it improves
the sample distribution (compensation some of the PEBS shadow effect).
Otherwise,
you still habe INST_RETIRED:ANY_P.

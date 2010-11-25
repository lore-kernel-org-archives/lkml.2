Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab0KYOHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:07:30 -0500
Received: from smtp-out.google.com ([74.125.121.35]:46450 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab0KYOH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:07:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JOiNKhxpUy8ozVZ/zdtz9gc9yh71sdm0jqM37YzomRS8YajPGdsT80iFjzeoXnZOgt
         7s6tNMVhaPyTo7OMWefw==
MIME-Version: 1.0
In-Reply-To: <1290693720.2145.34.camel@laptop>
References: <1290650053-3486-1-git-send-email-cjashfor@linux.vnet.ibm.com>
	<1290666760.2072.539.camel@laptop>
	<AANLkTinTNAwMCe_zu1snG1U5hSRafdBHQdzAr4e9nuWO@mail.gmail.com>
	<1290693720.2145.34.camel@laptop>
Date: Thu, 25 Nov 2010 15:07:25 +0100
Message-ID: <AANLkTinyL2eEfWoLoZqU-CFwC6Z3hGd0=9HgBhC_+Uef@mail.gmail.com>
Subject: Re: [RFC PATCHv3] perf tools: add event grouping capability to "perf stat"
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Julia Lawall <julia@diku.dk>,
        Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt@console-pimps.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 3:02 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2010-11-25 at 14:19 +0100, Stephane Eranian wrote:
>
>> I think using PERF_SAMPLE_READ may expose a problem in the
>> perf.data format. To correctly parse a sample created with SAMPLE_READ,
>> you need to know the attr.read_format. But for that you need to know the
>> event which caused the sample, but for that you need the SAMPLE_ID,
>> and you don't know if it's there or not. In other words, there is a chicken
>> and egg problem.
>>
>> I think the issue is that PERF_RECORD_SAMPLE is missing a mandatory
>> piece of information: overflow event ID. This must a mandatory field, not
>> optional as it is today. It is okay when you have only one group, but we'd
>> like to go beyond that.
>
>
>
> I'm not sure I get it, there's both PERF_FORMAT_ID and PERF_SAMPLE_ID,
> so afaict there's a working combination for what you want to do.
>
Ok, I had forgotten about PERF_SAMPLE_ID. But that means that if the
number of groups > 1, then if you use PERF_SAMPLE_READ, you MUST
also use PERF_SAMPLE_ID. Otherwise you cannot get back to the event
that generated the sample and thus attr.read_format.

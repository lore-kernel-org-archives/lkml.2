Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab0KWLeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 06:34:04 -0500
Received: from smtp-out.google.com ([74.125.121.35]:5647 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab0KWLeB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 06:34:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hSdZPR76nf0VT+tn20k/KRrgLjeXDPYY08Td8U/HrHxiP6XWwB6zM5sBjyY8xwbJOa
         r3ZuljOrwdkRCPs1VPZg==
MIME-Version: 1.0
In-Reply-To: <AANLkTi=cBpL8oKC-JfLVXJ20gG+M9taWvOq=vRszkuvn@mail.gmail.com>
References: <4ceb9b74.e6edd80a.3271.fffff742@mx.google.com>
	<1290510680.2072.390.camel@laptop>
	<AANLkTi=cBpL8oKC-JfLVXJ20gG+M9taWvOq=vRszkuvn@mail.gmail.com>
Date: Tue, 23 Nov 2010 12:33:59 +0100
Message-ID: <AANLkTikuhX=bFjOCL_DtaPJGTvS0TvQd6i8ayQjP=GJk@mail.gmail.com>
Subject: Re: [PATCH] perf: add support for per-event sampling period or
 frequency in perf record
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 12:33 PM, Stephane Eranian <eranian@google.com> wrote:
> On Tue, Nov 23, 2010 at 12:11 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Tue, 2010-11-23 at 11:45 +0200, Stephane Eranian wrote:
>>> This patch allows specifying a per event sampling period or frequency.
>>> Up until now, the same sampling period or frequency was applied to all
>>> the events specified on the command line of perf record. A sampling
>>> period depends on the event, thus it is necessary to specify it per event.
>>>
>>> With this patch, both the -F and -c options now take a comma separated
>>> list of values. If a value is omitted for an event, it defaults to 1000Hz
>>> frequency mode as before.
>>>
>>> $ perf record -e cycles,instructions -c 100000,200000 -a -- sleep 5
>>
>>
>> I remember an email not too long ago where people proposed to change the
>> syntax so that:
>>
>>  -e evnt1,evnt2     -- create a group containing both events
>>  -e evnt1 -e evnt2  -- create two separate events
>>
> Yes, that would be nice too especially for people interested in event ratios.
>
>> It would be nice to make sure these two proposals will not interfere.
>>
>> Alternatively we extend the event syntax to include the period,
>> something like:
>>
>>  -e evnt1:period=1234
>>
> Yes, that's the other approach. It may be more readable when you
> have more events. I have that working with libpfm4, i.e., the full
> event string is processed by the library. But for now, we could try
> and do this in the tool as well, something like:
>
> -e evtnt1:period=1234 -e evnt2:freq=100
>
Forgot to say, that the reason I did it thru -c and -F was to maintain
backward compatibility.

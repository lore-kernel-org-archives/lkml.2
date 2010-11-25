Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab0KYJQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 04:16:32 -0500
Received: from smtp-out.google.com ([216.239.44.51]:43297 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab0KYJQa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 04:16:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w9Mw0oIjG4OrBYItyLnU3jVzZ/2lLNsX/l3YtAxuldzw+PbYRzjtnq8XAnOzU5GnbF
         8oFdEi/eus861ZYmqv0A==
MIME-Version: 1.0
In-Reply-To: <20101125074629.GC2538@nowhere>
References: <1290650053-3486-1-git-send-email-cjashfor@linux.vnet.ibm.com>
	<1290666760.2072.539.camel@laptop>
	<20101125074629.GC2538@nowhere>
Date: Thu, 25 Nov 2010 10:16:26 +0100
Message-ID: <AANLkTi=VOycbTUmaF2xLuhTGAPBEQKyTjXkPojeQWwLA@mail.gmail.com>
Subject: Re: [RFC PATCHv3] perf tools: add event grouping capability to "perf stat"
From: Stephane Eranian <eranian@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Julia Lawall <julia@diku.dk>, Tom Zanussi <tzanussi@gmail.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 8:46 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Thu, Nov 25, 2010 at 07:32:40AM +0100, Peter Zijlstra wrote:
>> On Wed, 2010-11-24 at 17:54 -0800, Corey Ashford wrote:
>> > Add the ability to create multiple event groups, each with their own leader
>> > using the existing "-e <event>[,<event> ...] [-e <event>[,<event>]]"
>> > syntax.  Each additional -e switch creates a new group, and each event
>> > listed within a -e switch is within that group.
>> >
>> > Changes since v1:
>> > - Because of a flub, v2 did not contain the changes I had intended to make,
>> > and instead, v2 had the same patch contents as v1.
>> > - When perf stat is not supplied any events on the command line, put
>> > each default event in its own group.
>>
>> I like this, but could you also extend this to perf-record? its a bit
>> odd to diverge between the two.
>>
>> Using Stephane's latest syntax changes you could actually do something
>> like:
>>
>> perf record -e task-clock:freq=1000,cycles:period=0
>
My patch would have to be changed slightly to allow period=0.

But yes, lots of people have ask me for the possibility of sampling
on one event but recording the values of others in each sample.
The kernel supports this, I have written a couple of example in libpfm4.
The issue is not so much in perf record, but rather in perf report. How
to report the data? Most of the time this is for post-processing by other
tools.

> Wouldn't this syntax clash with the flags we have on events already?
>
> the u,k,p flags?
>
It does not.

>
>
>
>>
>> Which would create a group with 1 sampling counter and a counting
>> counter (at which point we should probably start flipping
>> PERF_SAMPLE_READ).
>>
>> Matt was working on supporting that (although not through cmdline
>> syntax) and teaching perf-report to cope with such output.
>>
>

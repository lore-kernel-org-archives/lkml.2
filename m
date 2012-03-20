Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964819Ab2CTUEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 16:04:13 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42866 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab2CTUEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 16:04:11 -0400
MIME-Version: 1.0
In-Reply-To: <1332273597.18960.454.camel@twins>
References: <1332271396-21756-1-git-send-email-ashay.r@gmail.com>
	<20120320194241.GA24870@infradead.org>
	<4F68DE88.1040301@gmail.com>
	<1332272870.18960.450.camel@twins>
	<CANn2t1n3fiVGqMKm=a7k3bKgKRzVdo3zu54ZKiCMqtDFbS4MeA@mail.gmail.com>
	<1332273597.18960.454.camel@twins>
Date: Tue, 20 Mar 2012 15:04:10 -0500
Message-ID: <CANn2t1=A8Gz4+YL2+fyBW3fzWzh4FN5Ktx_pBZidAEE5KbkiZQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] Fix number of events displayed in header
From: Ashay Rane <ashay.r@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-perf-users@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Ashay Rane <ashay.rane@tacc.utexas.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, okay. Thanks for the clarification!

However, my reasoning behind including the actual count of the events
was that (as far as I can tell) it is not displayed in any of the perf
report outputs. I understand that the count is not precise (because of
sampling errors) but the sampling frequency (-F) can always be
adjusted to get a more accurate number.

With the inclusion of the count, it then becomes possible to compare
multiple different versions of a program. Hence the patch.

Ashay


2012/3/20 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Tue, 2012-03-20 at 14:51 -0500, Ashay Rane wrote:
>> The problem I am seeing is that the `perf record' output does not
>> comform with the output of `perf stat'. For example, for `hackbench 10
>> process 1000', I see 19 x 10^9 cycles reported by `perf stat'.
>> However, `perf report -n' prints "Events: 2K cycles" and `perf report
>> -n --dso hackbench' prints "Events: 47 cycles".
>
> Ah, read it as if perf report is saying: Samples: 47 of event: cycles.
>
> That is, its telling you the cycles event had 47 overflows causing 47
> samples to be taken (IP, etc..) and written out.
>
> The point of reporting this number is that it puts the accuracy of the
> percentages into perspective. The more samples, the greater the coverage
> and more accurate the actual percentage of time spend in the various
> functions.

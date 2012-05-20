Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab2ETIcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 04:32:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52419 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2ETIcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 04:32:01 -0400
MIME-Version: 1.0
In-Reply-To: <4FB52636.3040604@linux.intel.com>
References: <1337268092-6765-1-git-send-email-h.mitake@gmail.com>
	<4FB52636.3040604@linux.intel.com>
Date: Sun, 20 May 2012 17:32:00 +0900
Message-ID: <CAMO-S2g9fkg_KH0CPOsB_7GQTN2mu8zir+UZDp6=VC+7XDrfrg@mail.gmail.com>
Subject: Re: [PATCH] perf bench: add new benchmark subsystem and suite "futex wait"
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Michel Lespinasse <walken@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 1:24 AM, Darren Hart <dvhart@linux.intel.com> wrote:
> On 05/17/2012 08:21 AM, Hitoshi Mitake wrote:
>> Hi Ingo, Eric and Darren,
>> (CCed perf and futex folks)
>>
>> I wrote this patch for adding new subsystem "futex" and its suite "wait" to perf
>> bench on tip/master. This is based on futextest by Darren Hart.
>>
>> Could you allow me to import your source code of futextest to perf bench, Darren?
>>
>
> I do have some concerns I'd like to address first.
>
> What is advantage of incorporating this into perf as opposed to running
> it with perf?

The main and direct advantage is that perf bench can share useful
utilities stored under tools/perf/util/ directory e.g. parse-options[ch].

>
> Do you intend to port the rest of the futextest testsuite over to perf?
>
> futextest is not by any means complete, and I have been slowly adding to
> it over time. My concern would be getting into a situation where perf
> bench has a small subset of similar (but slightly different) tests,
> which can not be maintained along with futextest.
>
> Would there be a strong motivation to bring all of futextest under perf?
> There are certain parts that I can see as not being a good fit, such as
> some of the functional tests or possibly some of the stress tests (and
> some of the planned randomization stress tests).

I was intending to port only futex_wait.c to perf currently. But
importing other parts of futextest may be worthful. Even if they are
not suitable for perf bench, I think storing them into tools/
directory of linux kernel is valuable because they are good
documentation and example of futex usage.

>
>> Below is the patch, I'd like to hear your comments.
>
> Depending on the answers to the above, I'm concerned about the inlining
> of the various bits and pieces from the futextest header files into a
> single C file - from a maintenance and expansion perspective.
>
> I am not necessarily opposed to the idea, especially as being under the
> perf umbrella is sure to get more futex testing and eyes on the
> futextest code. I would like to make sure we have a long term plan
> before merging headers and C files together from futextest into perf.
>

As you say, if we import other part of futextest into perf or tools/,
embedding some functions like futex_inc, dec, etc are not so good.

How do you think about the idea of storing other part of futextest
into tools/ directory? If you agree this, I'll move some functions
related to futex and atomic operations to tools/include/ directory or
somewhere more suitable.

Thanks,


-- 
Hitoshi Mitake
h.mitake@gmail.com

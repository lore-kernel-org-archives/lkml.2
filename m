Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536Ab0LCIhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 03:37:54 -0500
Received: from smtp-out.google.com ([216.239.44.51]:24687 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab0LCIhw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 03:37:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=X9gR3BsTuFaSAK54Bo/HlxflT86h8UOtffSAwMyR5yUAXM/vJPg8sHet7GL3eltcXR
         JKr88PdFuAQoq8D/1V5A==
MIME-Version: 1.0
In-Reply-To: <1291358909.4378.17.camel@marge.simson.net>
References: <20101121133744.GA10765@elte.hu> <1290700829.4759.16.camel@maggy.simson.net>
 <1290954299.30515.15.camel@marge.simson.net> <4CF5C379.8030204@google.com>
 <1291184173.7466.147.camel@marge.simson.net> <4CF87C14.8000708@google.com> <1291358909.4378.17.camel@marge.simson.net>
From: Paul Turner <pjt@google.com>
Date: Fri, 3 Dec 2010 00:37:19 -0800
Message-ID: <AANLkTin4jZ-0XoH-OHebJYzX2vTNTLiwLocENLUud7-q@mail.gmail.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 2, 2010 at 10:48 PM, Mike Galbraith <efault@gmx.de> wrote:
> On Thu, 2010-12-02 at 21:11 -0800, Paul Turner wrote:
>> On 11/30/10 22:16, Mike Galbraith wrote:
>> > On Tue, 2010-11-30 at 19:39 -0800, Paul Turner wrote:
>> >> On 11/28/10 06:24, Mike Galbraith wrote:
>> >>>
>> >>> Something else is seriously wrong though.  36.1 with attached (plus
>> >>> sched, cgroup: Fixup broken cgroup movement) works a treat, whereas
>> >>> 37.git and tip with fixlet below both suck rocks.  With a make -j40
>> >>> running, wakeup-latency is showing latencies of>100ms, amarok skips,
>> >>> mouse lurches badly.. generally horrid.  Something went south.
>> >>
>> >> I'm looking at this.
>> >>
>> >> The share:share ratios looked good in static testing, but perhaps we
>> >> need a little more wake-up boost to improve interactivity.
>> >
>> > Yeah, feels like a wakeup issue.  I too did a (brief) static test, and
>> > that looked ok.
>> >
>> >     -Mike
>> >
>>
>> Hey Mike,
>>
>> Does something like the below help?
>
> Unfortunately not.  For example, Xorg+mplayer needs (30 sec refresh)..
>
>  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
>  6487 root      20   0  366m  30m 5100 S   31  0.4   2:04.83 2 Xorg
>  4454 root      20   0  318m  28m  15m S   29  0.4   0:38.06 3 mplayer
>
> ..but gets this when a heavy kbuild is running along with them.
>
>  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
>  6487 root      20   0  366m  30m 5136 S   12  0.4   2:25.98 1 Xorg
>  5595 root      20   0  318m  28m  15m R    8  0.4   0:09.31 3 mplayer
>
> There are 4 task groups active at this time, Xorg, mplayer, Amarok and
> konsole where the kbuild is running make -j40.
>

Hmm.. unfortunate.  Ok -- based on the traces of synthetic loads and
the traces of their share on wake-up I think this is the right track
at least, will refine it tomorrow.

Thanks for trying it.

>        -Mike
>
>
>

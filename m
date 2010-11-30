Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab0K3EYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 23:24:21 -0500
Received: from smtp-out.google.com ([74.125.121.35]:13511 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab0K3EYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 23:24:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=t1zKxe0rf6816r/MApQWmnbIxoukJVOi/9jTHt5abo193pVdArl+sPO19FOpQ/2ooR
         EQ0pAojH/bNMdSAu7Tjg==
MIME-Version: 1.0
In-Reply-To: <1291090455.7550.7.camel@marge.simson.net>
References: <20101121133744.GA10765@elte.hu> <1290700829.4759.16.camel@maggy.simson.net>
 <1290954299.30515.15.camel@marge.simson.net> <AANLkTin5Z_WdAPDfcS3V3DCcN40HLDfpzK-o0XeSMiQh@mail.gmail.com>
 <20101128201851.GA20555@elte.hu> <1291031593.32004.19.camel@laptop>
 <AANLkTimQ2Kp2=um9ip7J2=-joskmz4P-0b_SrexFbTh0@mail.gmail.com>
 <1291052268.32004.171.camel@laptop> <1291057565.20709.2.camel@marge.simson.net>
 <20101129192033.GA18372@elte.hu> <AANLkTi=jra_M+F9OKj31uS6EMu+ZkPT++GSrNd_bgXSy@mail.gmail.com>
 <1291090455.7550.7.camel@marge.simson.net>
From: Paul Turner <pjt@google.com>
Date: Mon, 29 Nov 2010 20:23:43 -0800
Message-ID: <AANLkTi=YDHyRcP5NSdVDRMW0_oj1L85aLzGV9hFGw1FN@mail.gmail.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 8:14 PM, Mike Galbraith <efault@gmx.de> wrote:
> On Mon, 2010-11-29 at 19:39 -0800, Paul Turner wrote:
>> On Mon, Nov 29, 2010 at 11:20 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Mike Galbraith <efault@gmx.de> wrote:
>> >
>> >> > I know, from the testing so far we _thought_ it was fairly sane. Apparently
>> >> > there's still some work to do.
>> >>
>> >> Damn thing bisected to:
>> >>
>> >> commit 92fd4d4d67b945c0766416284d4ab236b31542c4
>> >> Merge: fe7de49 e53beac
>> >> Author: Ingo Molnar <mingo@elte.hu>
>> >> Date:   Thu Nov 18 13:22:14 2010 +0100
>> >>
>> >>     Merge commit 'v2.6.37-rc2' into sched/core
>> >>
>> >>     Merge reason: Move to a .37-rc base.
>> >>
>> >>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> >>
>> >> 92fd4d4d67b945c0766416284d4ab236b31542c4 is the first bad commit
>> >
>> > Hm, i'd suggest to double check the two originator points:
>> >
>> >  e53beac - is it really 'bad' ?
>> >  fe7de49 - is it really 'good'?
>> >
>> > Thanks,
>> >
>> >        Ingo
>> >
>>
>> https://lkml.org/lkml/2010/11/29/566
>>
>> Should fix this.
>
> No, I had it in place where pertinent.  Problem with bisection is that
> there are a couple of spots where X doesn't work.  With X, it's obvious,
> less so in text console.  Looks like I must have miscalled one of those.
>
>        -Mike

I've left some machines running tip + fix above + autogroup to see if
anything else emerges.  Hasn't crashed yet, I'll leave it going
overnight.

>
>

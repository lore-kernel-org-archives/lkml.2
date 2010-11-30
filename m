Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab0K3DkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 22:40:03 -0500
Received: from smtp-out.google.com ([74.125.121.35]:56991 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab0K3DkB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 22:40:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=EoVEyMcCPceISYfWWJX1efa5e1ldSSLqSQ2LU2WixyNCQiaWVe8teMs1Hes1TlFale
         8e7/H1VBkRV8bn71Agsw==
MIME-Version: 1.0
In-Reply-To: <20101129192033.GA18372@elte.hu>
References: <20101121133744.GA10765@elte.hu> <1290700829.4759.16.camel@maggy.simson.net>
 <1290954299.30515.15.camel@marge.simson.net> <AANLkTin5Z_WdAPDfcS3V3DCcN40HLDfpzK-o0XeSMiQh@mail.gmail.com>
 <20101128201851.GA20555@elte.hu> <1291031593.32004.19.camel@laptop>
 <AANLkTimQ2Kp2=um9ip7J2=-joskmz4P-0b_SrexFbTh0@mail.gmail.com>
 <1291052268.32004.171.camel@laptop> <1291057565.20709.2.camel@marge.simson.net>
 <20101129192033.GA18372@elte.hu>
From: Paul Turner <pjt@google.com>
Date: Mon, 29 Nov 2010 19:39:27 -0800
Message-ID: <AANLkTi=jra_M+F9OKj31uS6EMu+ZkPT++GSrNd_bgXSy@mail.gmail.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 11:20 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Mike Galbraith <efault@gmx.de> wrote:
>
>> > I know, from the testing so far we _thought_ it was fairly sane. Apparently
>> > there's still some work to do.
>>
>> Damn thing bisected to:
>>
>> commit 92fd4d4d67b945c0766416284d4ab236b31542c4
>> Merge: fe7de49 e53beac
>> Author: Ingo Molnar <mingo@elte.hu>
>> Date:   Thu Nov 18 13:22:14 2010 +0100
>>
>>     Merge commit 'v2.6.37-rc2' into sched/core
>>
>>     Merge reason: Move to a .37-rc base.
>>
>>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>
>> 92fd4d4d67b945c0766416284d4ab236b31542c4 is the first bad commit
>
> Hm, i'd suggest to double check the two originator points:
>
>  e53beac - is it really 'bad' ?
>  fe7de49 - is it really 'good'?
>
> Thanks,
>
>        Ingo
>

https://lkml.org/lkml/2010/11/29/566

Should fix this.  We missed this in testing as the delay between
last-task-exit and group destruction was always sufficiently large as
to ensure that the task_group had aged out of shares updates (as
opposed to requiring explicit removal).

With autogroup obviously the window here is essentially instantaneous
which leads to the buggy removal code being executed.

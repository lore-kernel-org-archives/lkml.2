Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab0JKXnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 19:43:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6165 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab0JKXnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 19:43:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qN0GZ87ZeyifRV6VRbTogLw4O6GKDspwoY/Lv3Kr9fBqu/KGDEgQN+KNLpNxHQbwbr
         EktFzebNjoFvKZo8gj8A==
MIME-Version: 1.0
In-Reply-To: <20101011162356.cd0ddcc1.akpm@linux-foundation.org>
References: <20101008023356.6280.9969.stgit@dungbeetle.mtv.corp.google.com>
	<20101011154348.d3b24fa4.akpm@linux-foundation.org>
	<AANLkTi=Q=09b8UPcNm0sXGebYQKP3cfxroy+kLWP8EQ_@mail.gmail.com>
	<20101011162356.cd0ddcc1.akpm@linux-foundation.org>
Date: Mon, 11 Oct 2010 16:43:00 -0700
Message-ID: <AANLkTimUfWxB_7Y+bpKJKfBemJdy3LDa4f2AT0z2C4kw@mail.gmail.com>
Subject: Re: [PATCH] Fix a complex race in hrtimer code.
From: Salman Qazi <sqazi@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 4:23 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 11 Oct 2010 16:18:52 -0700
> Salman Qazi <sqazi@google.com> wrote:
>
>> On Mon, Oct 11, 2010 at 3:43 PM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>>
>> > Poeple are using BUG waaaaay too often.
>> >
>>
>> If people are attentive about WARN_ON_ONCE, then I suppose that is a
>> better alternative.
>>
>> One of the reasons why I personally like BUG_ON is that it catches
>> problems early and makes people look (i.e. one can't ignore it, just
>> because one didn't notice, understand or care) before it compounds any
>> further.  It is very hard to debug a corrupted radix tree.  It is much
>> easier to understand and fix the fact that our assumptions regarding
>> the hrtimer state and locking are incorrect.
>>
>> I'd rather have a BUG_ON firing 100 times, close to the root cause,
>> instead of one case of unexplained data corruption far from the root
>> cause.  Just my $0.02.
>
> You're assuming that you are the one who observes the BUG_ON.  In a
> large number of cases (probably the majority) it's some random person
> on another continent.  Their box is dead and after a reboot there's
> nothing in the logs.  Now what?
>
>

fair enough.  I'll send a patch with a WARN_ON_ONCE instead.

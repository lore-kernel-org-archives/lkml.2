Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1G2Xoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 19:44:37 -0400
Received: from smtp-out.google.com ([74.125.121.67]:32400 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab1G2Xog convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 19:44:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=WsrJbV7LurJVL7JPyY9ZY2EFKIFvzdA/KxLUGWJ/c+c3pk3AU6TCgSzr4RhSxVATh
	6PRuqVrUopX5lp1LK98JA==
MIME-Version: 1.0
In-Reply-To: <20110729205538.GD14343@redhat.com>
References: <1311271873-10879-1-git-send-email-zakmagnus@google.com>
	<20110722195340.GF3765@redhat.com>
	<CAAuSN93tiSehpNXxjOgrq7oV-U+1ZPi2eqr+2dNSBG0yu0jxmA@mail.gmail.com>
	<20110725124451.GA2866@redhat.com>
	<CAAuSN93Qjk4eEAvm_Xn=O-0t+qhAyKmxy6HyPuyzJ35tX2u_CQ@mail.gmail.com>
	<20110729205538.GD14343@redhat.com>
Date: Fri, 29 Jul 2011 16:12:32 -0700
Message-ID: <CAAuSN93ouWrPn9xWb9Zd3E2Dp0hQxC4JmFH1utbyy1_aMnfkLA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] Make hard lockup detection use timestamps
From: ZAK Magnus <zakmagnus@google.com>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are you saying that any call to printk() will touch the watchdogs? I
wasn't aware of that and it doesn't seem to comply with my
observations too well, either. Then again, at the moment I don't
understand some of the things I'm currently seeing so I could just be
wrong.

On Fri, Jul 29, 2011 at 1:55 PM, Don Zickus <dzickus@redhat.com> wrote:
> On Thu, Jul 28, 2011 at 05:16:00PM -0700, ZAK Magnus wrote:
>> No news?
>>
>> I've been testing and looking into issues and I realized dump_stack()
>> calls touch_nmi_watchdog(). That wrecks what the patch is trying to do
>> so I'm changing it to save the trace and print it later after the
>> stall has completed. This would also resolve some other things you
>> were saying weren't so good. Hopefully the logic is similar enough
>> that some things you may have learned still apply.
>
> So yeah, the acting of printing was resesting the softlockup counter and
> delaying it forever.  In parallel, rcu has its own stall detector that was
> going off after a minute or two.
>
> Once I routed the printk to trace_printk and disabled dump_stack,
> everything started working as expected.
>
> Now the question is how to avoid shooting ourselves in the foot by
> printk'ing a message without resetting the hard/soft lock watchdogs.
>
> I'll have to think about how to do that.  If you can come up with any
> ideas let me know.
>
> We almost need a quiet dump_stack that dumps to a buffer instead of the
> console.  But I am not sure that is worth the effort.
>
> Hmm.
>
> Cheers,
> Don
>

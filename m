Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404Ab1CCP5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 10:57:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757489Ab1CCP5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 10:57:02 -0500
Date: Thu, 3 Mar 2011 16:47:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH v3 1/4] exec: introduce get_arg_ptr() helper
Message-ID: <20110303154706.GA22560@redhat.com>
References: <20110302162650.GA26810@redhat.com> <20110302162712.GB26810@redhat.com> <20110303114952.B94B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303114952.B94B.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03, KOSAKI Motohiro wrote:
>
> > +static const char __user *
> > +get_arg_ptr(const char __user * const __user *argv, int argc)
> > +{
>
> [argc, argv] is natural order to me than [argv, argc].

Yes... in fact, "argc" is misnamed here. It doesn't mean the number of
arguments, it is the index in the array. Perhaps this should be [argv, nr].

> and "get_" prefix are usually used for reference count incrementing
> function in linux. so, i _personally_ prefer to call "user_arg_ptr".

Agreed, the name is ugly. I'll rename and resend keeping your reviewed-by.

[2/4]
> I _personally_ don't like "conditional". Its name is based on code logic.
> It's unclear what mean "conditional". From data strucuture view, It is
> "opaque userland pointer".

I agree with any naming, just suggest a better name ;)

[3/4]
> > +     struct conditional_ptr argv = {
> > +             .is_compat = true, .ptr.compat = __argv,
> > +     };
>
> Please don't mind to compress a line.
>
>         struct conditional_ptr argv = {
>                 .is_compat = true,
>                 .ptr.compat = __argv,
>         };

OK, will do.

Thanks for review!

Oleg.


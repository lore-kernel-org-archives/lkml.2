Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab2BNRwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 12:52:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab2BNRwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 12:52:08 -0500
Date: Tue, 14 Feb 2012 18:45:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] signal: give SEND_SIG_FORCED more power to beat
	SIGNAL_UNKILLABLE
Message-ID: <20120214174528.GA23562@redhat.com>
References: <20120210200004.GA20890@redhat.com> <20120210200021.GA20898@redhat.com> <20120210212532.GL19392@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210212532.GL19392@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 02/10, Tejun Heo wrote:
>
> > --- a/kernel/signal.c
> > +++ b/kernel/signal.c
> > @@ -1059,7 +1059,8 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
> >
> >  	assert_spin_locked(&t->sighand->siglock);
> >
> > -	if (!prepare_signal(sig, t, from_ancestor_ns))
> > +	if (!prepare_signal(sig, t,
> > +			from_ancestor_ns || (info == SEND_SIG_FORCED)))
>
> How about the following indentation instead?  :)
>
> 	if (!prepare_signal(sig, t,
> 	    from_ancestor_ns || (info == SEND_SIG_FORCED)))

Well, I am not sure this looks better, although I do not really mind.
But since this patch is already in -mm, I think I won't send v2 ;)

> Please feel free to add Reviewed-by for 2-4.

Thanks!

Oleg.


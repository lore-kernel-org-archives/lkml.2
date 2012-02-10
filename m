Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760241Ab2BJVZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 16:25:38 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41973 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2BJVZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 16:25:37 -0500
Date: Fri, 10 Feb 2012 13:25:32 -0800
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] signal: give SEND_SIG_FORCED more power to beat
 SIGNAL_UNKILLABLE
Message-ID: <20120210212532.GL19392@google.com>
References: <20120210200004.GA20890@redhat.com>
 <20120210200021.GA20898@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210200021.GA20898@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg,.

I can't provide any meaningful constructive criticism but have one
bike-shedding one.

On Fri, Feb 10, 2012 at 09:00:21PM +0100, Oleg Nesterov wrote:
> diff --git a/kernel/signal.c b/kernel/signal.c
> index c73c428..bfb2b97 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1059,7 +1059,8 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
>  
>  	assert_spin_locked(&t->sighand->siglock);
>  
> -	if (!prepare_signal(sig, t, from_ancestor_ns))
> +	if (!prepare_signal(sig, t,
> +			from_ancestor_ns || (info == SEND_SIG_FORCED)))

How about the following indentation instead?  :)

	if (!prepare_signal(sig, t,
	    from_ancestor_ns || (info == SEND_SIG_FORCED)))

Overall, the changes look sane to me but I haven't really thought
about it deeply.  Please feel free to add Reviewed-by for 2-4.

Thank you.

-- 
tejun

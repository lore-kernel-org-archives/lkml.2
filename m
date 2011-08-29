Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1H2QkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:40:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876Ab1H2QkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:40:20 -0400
Date: Mon, 29 Aug 2011 18:36:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <paul@paulmenage.org>,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH pm-freezer 4/4] freezer: use lock_task_sighand() in
	fake_signal_wake_up()
Message-ID: <20110829163647.GC9973@redhat.com>
References: <20110829140418.GB18871@mtj.dyndns.org> <20110829140509.GC18871@mtj.dyndns.org> <20110829140549.GD18871@mtj.dyndns.org> <20110829140621.GE18871@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829140621.GE18871@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29, Tejun Heo wrote:
>
> --- work.orig/kernel/freezer.c
> +++ work/kernel/freezer.c
> @@ -103,9 +103,10 @@ static void fake_signal_wake_up(struct t
>  {
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&p->sighand->siglock, flags);
> -	signal_wake_up(p, 0);
> -	spin_unlock_irqrestore(&p->sighand->siglock, flags);
> +	if (lock_task_sighand(p, &flags)) {
> +		signal_wake_up(p, 0);
> +		unlock_task_sighand(p, &flags);
> +	}

Yes, this looks correct.

Oleg.


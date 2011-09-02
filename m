Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab1IBRMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 13:12:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab1IBRMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 13:12:19 -0400
Date: Fri, 2 Sep 2011 19:08:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <paul@paulmenage.org>,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH pm-freezer 3/4] freezer: restructure __refrigerator()
Message-ID: <20110902170817.GA8070@redhat.com>
References: <20110831102100.GA2828@mtj.dyndns.org> <20110831102143.GB2828@mtj.dyndns.org> <20110831102210.GC2828@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110831102210.GC2828@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31, Tejun Heo wrote:
>
>  	for (;;) {
>  		set_current_state(TASK_UNINTERRUPTIBLE);
> +
> +		spin_lock_irq(&freezer_lock);
> +		current->flags |= PF_FROZEN;
>  		if (!freezing(current) ||
> -		    (check_kthr_stop && kthread_should_stop()))
> +		    (check_kthr_stop && kthread_should_stop())) {
> +			current->flags &= ~PF_FROZEN;
> +			break;

Argh! sorry I missed this...

This "break" is typo, it should be removed.

Otherwise I believe this is correct.

Oleg.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab1FINco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:32:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35380 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758024Ab1FINcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:32:39 -0400
Date: Thu, 9 Jun 2011 15:32:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, efault@gmx.de,
        Arne Jansen <lists@die-jansens.de>
Subject: Re: [PATCH 3/3] printk: Avoid all wakeups from printk
Message-ID: <20110609133228.GB21100@elte.hu>
References: <20110609130647.937204592@chello.nl>
 <20110609131307.590149293@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609131307.590149293@chello.nl>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> +void console_unlock(void)
> +{
> +	if (console_suspended) {
> +		up(&console_sem);
> +		return;
> +	}
> +
> +	__console_flush();
> +
> +	up(&console_sem);
> +}

Hm, this seems to be a very roundabout way of doing:

void console_unlock(void)
{
	if (!console_suspended)
		__console_flush();

	up(&console_sem);
}

Right?

Thanks,

	Ingo

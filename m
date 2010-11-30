Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab0K3TCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:02:44 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:33275 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab0K3TCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:02:43 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 24.130.172.179
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19lxdAdCB26ecUY3+ItkJEO
Date: Tue, 30 Nov 2010 11:00:58 -0800
From: Tony Lindgren <tony@atomide.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 1/4] drivers: hwspinlock: add generic framework
Message-ID: <20101130190058.GX17222@atomide.com>
References: <1290526740-27624-1-git-send-email-ohad@wizery.com>
 <1290526740-27624-2-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290526740-27624-2-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ohad Ben-Cohen <ohad@wizery.com> [101123 07:27]:
> Add a common, platform-independent, hwspinlock framework.
> 
> Hardware spinlock devices are needed, e.g., in order to access data
> that is shared between remote processors, that otherwise have no
> alternative mechanism to accomplish synchronization and mutual exclusion
> operations.

<snip>

> +  int hwspin_lock(struct hwspinlock *hwlock);
> +   - lock a previously assigned hwspinlock. If the hwspinlock is already
> +     taken, the function will busy loop waiting for it to be released.
> +     Note: if a faulty remote core never releases this lock, this function
> +     will deadlock.
> +     This function will fail only if hwlock is invalid. Otherwise, it will
> +     always succeed (or deadlock; see above) and it will never sleep.
> +     Upon a successful return from this function, preemption is disabled so
> +     the caller must not sleep, and is advised to release the hwspinlock as
> +     soon as possible, in order to minimize remote cores polling on the
> +     hardware interconnect.
...

> +  int hwspin_lock_timeout(struct hwspinlock *hwlock, unsigned long timeout);
> +   - lock a previously-assigned hwspinlock with a timeout limit (specified in
> +     jiffies). If the hwspinlock is already taken, the function will busy loop
> +     waiting for it to be released, but give up when the timeout meets jiffies.
> +     If timeout is 0, the function will never give up (therefore if a faulty
> +     remote core never releases the hwspinlock, it will deadlock).
> +     Upon a successful return from this function, preemption is disabled so
> +     the caller must not sleep, and is advised to release the hwspinlock as
> +     soon as possible, in order to minimize remote cores polling on the
> +     hardware interconnect.
> +     Returns 0 when successful and an appropriate error code otherwise (most
> +     notably -ETIMEDOUT if the hwspinlock is still busy after timeout meets
> +     jiffies). The function will never sleep.

Do we even need the hwspin_lock variants, why can't we always use the
hwspin_lock_timeout variants?

To me the idea of looping waiting for some external system to release
a lock is not a good idea..

Regards,

Tony

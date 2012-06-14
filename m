Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab2FNIhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:37:12 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:42727 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab2FNIhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:37:08 -0400
Message-ID: <4FD9A27A.4040300@linux.vnet.ibm.com>
Date: Thu, 14 Jun 2012 14:06:10 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 1/5] kthread: Implement park/unpark facility
References: <20120613102823.373180763@linutronix.de> <20120613105815.132283147@linutronix.de>
In-Reply-To: <20120613105815.132283147@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12061322-9264-0000-0000-000001B4372F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2012 04:30 PM, Thomas Gleixner wrote:

> To avoid the full teardown/setup of per cpu kthreads in the case of
> cpu hot(un)plug, provide a facility which allows to put the kthread
> into a park position and unpark it when the cpu comes online again.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
> 
>  /**
> + * kthread_should_park - should this kthread return now?
> + *
> + * When someone calls kthread_park() on your kthread, it will be woken
> + * and this will return true.  You should then return, and your return
> + * value will be passed through to kthread_park().
> + *
> + * Similar to kthread_should_stop(), but this keeps the thread alive
> + * and in a park position. kthread_unpark() "restart" the thread and


s/restart/restarts

> + * calls the thread function again.
> + */


Regards,
Srivatsa S. Bhat


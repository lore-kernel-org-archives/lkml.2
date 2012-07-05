Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab2GEQMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 12:12:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab2GEQMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 12:12:32 -0400
Message-ID: <4FF5A4EB.3080502@redhat.com>
Date: Thu, 05 Jul 2012 10:30:03 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux@openhuawei.org
Subject: Re: [PATCH 3/3] [RFC] hrtimer: Update hrtimer base offsets each hrtimer_interrupt
References: <1341382890-42324-1-git-send-email-johnstul@us.ibm.com> <1341382890-42324-4-git-send-email-johnstul@us.ibm.com>
In-Reply-To: <1341382890-42324-4-git-send-email-johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/04/2012 02:21 AM, John Stultz wrote:
> This patch introduces a new funciton which captures the
> CLOCK_MONOTONIC time, along with the CLOCK_REALTIME and
> CLOCK_BOOTTIME offsets at the same moment. This new function
> is then used in place of ktime_get() when hrtimer_interrupt()
> is expiring timers.
> 
> This ensures that any changes to realtime or boottime offsets
> are noticed and stored into the per-cpu hrtimer base structures,
> prior to doing any hrtimer expiration. This should ensure that
> timers are not expired early if the offsets changes under us.
> 
> This is useful in the case where clock_was_set() is called from
> atomic context and have to schedule the hrtimer base offset update
> via a timer, as it provides extra robustness in the face of any
> possible timer delay.
> 
> CC: Prarit Bhargava <prarit@redhat.com>
> CC: stable@vger.kernel.org
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: linux@openhuawei.org
> Signed-off-by: John Stultz <johnstul@us.ibm.com>

Acked-by: Prarit Bhargava <prarit@redhat.com>

P.

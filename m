Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab2GKMPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:15:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab2GKMPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:15:42 -0400
Message-ID: <4FFD6E5A.9060206@redhat.com>
Date: Wed, 11 Jul 2012 08:15:22 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH 1/6] hrtimer: Provide clock_was_set_delayed()
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com> <1341960205-56738-2-git-send-email-johnstul@us.ibm.com>
In-Reply-To: <1341960205-56738-2-git-send-email-johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/10/2012 06:43 PM, John Stultz wrote:
> clock_was_set() cannot be called from hard interrupt context because
> it calls on_each_cpu(). For fixing the widely reported leap seconds
> issue it's necessary to call it from the timer interrupt context.
> 
> Provide a new function which denotes it in the hrtimer cpu base
> structure of the cpu on which it is called and raising the timer
> softirq.
> 
> We then execute the clock_was_set() notificiation in the timer softirq
> context in hrtimer_run_pending().

I wish there was a nicer way to do this ... but looking at the code I can't
figure out a better way.  (no offense John, it's just the way the code is ;) )

P.

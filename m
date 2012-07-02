Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab2GBIxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:53:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:44142 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab2GBIxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:53:13 -0400
Date: Mon, 2 Jul 2012 10:53:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <johnstul@us.ibm.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] [RFC] Fix clock_was_set so it is safe to call from
 atomic
In-Reply-To: <1341167401-31342-2-git-send-email-johnstul@us.ibm.com>
Message-ID: <alpine.LFD.2.02.1207021050500.2793@ionos>
References: <1341167401-31342-1-git-send-email-johnstul@us.ibm.com> <1341167401-31342-2-git-send-email-johnstul@us.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jul 2012, John Stultz wrote:

> NOTE:This is a prerequisite patch that's required to
> address the widely observed leap-second related futex/hrtimer
> issues.
> 
> Currently clock_was_set() is unsafe to be called from atomic
> context, as it calls on_each_cpu(). This causes problems when
> we need to adjust the time from update_wall_time().
> 
> To fix this, introduce a work_struct so if we're in_atomic,
> we can schedule work to do the necessary update after we're
> out of the atomic section.

Shouldn't we queue a timer_list timer with expiry time jiffies + 0
instead. We can call on_each_cpu() from softirq context. And that
ensures that the update happens right away, while a scheduled work
might be delayed arbitrary long.

Thanks,

	tglx

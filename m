Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab1BRVew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 16:34:52 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:39291 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab1BRVet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 16:34:49 -0500
Subject: Re: [PATCH] pps: Make pps_gen_parport depend on BROKEN
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Rodolfo Giometti <giometti@linux.it>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.1102182214190.2701@localhost6.localdomain6>
References: <alpine.LFD.2.00.1102182214190.2701@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 13:34:41 -0800
Message-ID: <1298064881.2431.3.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 22:16 +0100, Thomas Gleixner wrote:
> This driver causes hard lockups, when the active clock soure is
> jiffies. The reason is that it loops with interrupts disabled waiting
> for a timestamp to be reached by polling getnstimeofday(). Though with
> a jiffies clocksource, when that code runs on the same CPU which is
> responsible for updating jiffies, then we loop in circles for ever
> simply because the timer interrupt cannot update jiffies. So both UP
> and SMP can be affected.

Yuck.

Alexander, Rodolfo: Instead of polling on gtod, could you take a
timestamp, calculate the delay and then use udelay()?

thanks
-john



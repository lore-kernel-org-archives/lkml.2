Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab0EKIdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 04:33:49 -0400
Received: from www.tglx.de ([62.245.132.106]:51871 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762Ab0EKIdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 04:33:44 -0400
Date: Tue, 11 May 2010 10:33:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Iram Shahzad <iram.shahzad@jp.fujitsu.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: hrtimer: about hres_active
In-Reply-To: <D1C79E74038141C1BCD3EF70A5032E34@rainbow>
Message-ID: <alpine.LFD.2.00.1005111032200.3401@localhost.localdomain>
References: <20090206060328.181057235@goodmis.org> <9D38EE7159934A5C85505E9517638040@rainbow> <alpine.LFD.2.00.1005101707410.3401@localhost.localdomain> <D1C79E74038141C1BCD3EF70A5032E34@rainbow>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Iram,

please do _NOT_ top post.

On Tue, 11 May 2010, Iram Shahzad wrote:
> > No. The system switches to high resolution mode late in the boot
> > process and it does so only when there is high res capable hardware
> > available.
> 
> So far as I checked, hres_active is set to 1 in hrtimer_switch_to_hres.
> hrtimer_switch_to_hres is only called from hrtimer_run_pending.
> And hrtimer_run_pending is called from timer wheel softirq.
> That is why I concluded that hres_active is set at 1st timer softirq.
> Do you just mean that it is not the 1st softirq, or do you
> mean that in some other place in the late boot process
> there is another code which sets hres_active?

It happens from softirq context, but not from the 1st softirq.
 
> And is it correct that hres_active remains 1 forever once set to it?

Yes. There is no way back.
 
Thanks,

	tglx

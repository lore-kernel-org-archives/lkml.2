Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0IQJf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 05:35:26 -0400
Received: from claranet-outbound-smtp00.uk.clara.net ([195.8.89.33]:45249 "EHLO
	claranet-outbound-smtp00.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752215Ab0IQJfV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 05:35:21 -0400
X-Greylist: delayed 1981 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Sep 2010 05:35:21 EDT
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: intel-gfx@lists.freedesktop.org
Subject: Re: [Intel-gfx] Interrupt latency on some 945GM platforms
Date: Fri, 17 Sep 2010 10:02:08 +0100
User-Agent: KMail/1.13.3 (Linux/2.6.34.1-100.tv.pf.fc13.x86_64; KDE/4.4.4; x86_64; ; )
Cc: Vasily Khoruzhick <anarsoul@gmail.com>,
        Sitsofe Wheeler <sitsofe@yahoo.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
References: <201009132336.17310.anarsoul@gmail.com> <20100914224111.GA14467@sucs.org> <201009161803.10531.anarsoul@gmail.com>
In-Reply-To: <201009161803.10531.anarsoul@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009171002.09187.simon.farnsworth@onelan.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 September 2010, Vasily Khoruzhick <anarsoul@gmail.com> wrote:
> В сообщении от 15 of September 2010 01:41:11 автор Sitsofe Wheeler написал:
> > > >     processor.max_cstate=2
> > > 
> > > Nope, it doesn't work with max_cstate=2
> > 
> > Perhaps intel_idle is being used? Any mention of it in dmesg?
> 
> Sitsofe, maybe you misunderstood me, I mean with max_cstate=1 graphics is
> smooth, with higher values (i.e. max_cstate=2) graphics is jerky.
> 
> Btw, Jesse, any comments/solutions/workarounds except one with
> processor.max_cstate=1 in kernel commandline? Should I file a bug on fdo
> bugzilla?

This looks like a problem I've seen on some hardware.

My workaround has been to use the pm_qos /dev/cpu_dma_latency interface to 
request a maximum latency of 1ms (value chosen as definitely small enough - a 
larger value may be better, but I don't care about power saving at runtime on 
my kit).

If it's happening on other kit, perhaps the i915 driver should make a suitable 
pm_qos request itself. Jesse, can you comment?
-- 
Simon Farnsworth
Software Engineer
ONELAN Limited
http://www.onelan.com/

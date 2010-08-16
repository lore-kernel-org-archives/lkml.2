Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab0HPHsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 03:48:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55384 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab0HPHsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 03:48:40 -0400
Subject: Re: [patch 1/3] sched: init rt_avg stat whenever rq comes online
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, chris@frostnet.net,
        debian00@aliceadsl.fr, hpa@zytor.com, jonathan.protzenko@gmail.com,
        mans@mansr.com, psastudio@mail.ru, rjw@sisk.pl, stephan.eicher@web.de,
        sxxe@gmx.de, thomas@archlinux.org, venki@google.com, wonghow@gmail.com,
        stable@kernel.org
In-Reply-To: <20100813193911.827207098@sbsiddha-MOBL3.sc.intel.com>
References: <20100813190539.410550989@sbsiddha-MOBL3.sc.intel.com>
	 <20100813193911.827207098@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Aug 2010 09:47:34 +0200
Message-ID: <1281944854.1926.948.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-13 at 12:45 -0700, Suresh Siddha wrote:
> plain text document attachment (sched_reset_rt_avg_stat_online.patch)
> TSC's get reset after suspend/resume and this leads to a scenario of
> rq->clock (sched_clock_cpu()) less than rq->age_stamp. This leads
> to a big value returned by scale_rt_power() and the resulting big group
> power set by the update_group_power() is causing improper load balancing
> between busy and idle cpu's after suspend/resume.

ARGH, so i[357] westmere mobile stops TSC on some power state?

Why don't we sync it back to the other CPUs instead?

Or does it simply mark TSCs unstable and leaves it at that?

In any case, this needs to be fixed at the clock level, not like this.



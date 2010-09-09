Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab0IIMvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 08:51:16 -0400
Received: from www.tglx.de ([62.245.132.106]:39271 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab0IIMvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 08:51:13 -0400
Date: Thu, 9 Sep 2010 14:50:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 0/2] [RFC] posix clock tuning
In-Reply-To: <20100909122156.GA2823@riccoc20.at.omicron.at>
Message-ID: <alpine.LFD.2.00.1009091443250.2477@localhost6.localdomain6>
References: <cover.1283504065.git.richard.cochran@omicron.at> <alpine.LFD.2.00.1009091152300.2477@localhost6.localdomain6> <20100909122156.GA2823@riccoc20.at.omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Sep 2010, Richard Cochran wrote:
> From my point of view, the discussion is going round in circles. There

Sorry for coming late and adding more to the general confusion. :)

> seems to be agreement that supporting PTP hardware clocks is a good
> idea. The objections seem to be about the form of the API. In general,
> there are three avenues.
> 
> 1. character device (like hpet)
> 2. posix clock api
> 3. sysfs
> 
> Or possibly some combination of the three.

I fail to see the requirement for any of those. Either the hardware
clock is suitable as a clocksource for general consumption, then it
should just be used as a clock source. If it's not - e.g. because it's
too slow to access - then it just should serve as a reference in the
NTP style and steer the timekeeping into sync.

As I said in the other reply, I know that you want a global
synchronized clock aside of CLOCK_REALTIME, but that's an easy to
solve problem.

See my other reply for details.

Thanks,

	tglx



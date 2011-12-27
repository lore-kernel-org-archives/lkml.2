Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab1L0K5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 05:57:14 -0500
Received: from dgate20.ts.fujitsu.com ([80.70.172.51]:23438 "EHLO
	dgate20.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab1L0K5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 05:57:11 -0500
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.71,414,1320620400"; 
   d="scan'208";a="82191793"
X-IronPort-AV: E=Sophos;i="4.71,414,1320620400"; 
   d="scan'208";a="125714313"
Date: Tue, 27 Dec 2011 11:57:08 +0100
From: Andreas Friedrich <afrie@gmx.net>
To: rabin.vincent@stericsson.com
Cc: john.stultz@linaro.org, gregkh@suse.de, torvalds@osdl.org,
        Wolfgang Erig <Wolfgang.Erig@ts.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: REGRESSION 3.2-rcX: RTC auto poweron after 5 minutes
Message-ID: <20111227105708.GA29960@upset.ux.pdb.fsc.net>
References: <20111226145841.GA26578@upset.ux.pdb.fsc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111226145841.GA26578@upset.ux.pdb.fsc.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo, Dez 26, 2011 at 03:58:41 +0100, Andreas Friedrich wrote:

Hello Rabin,
...
> After shuting down my system (init 0), it powers on automatically
> after 300 seconds!
> 
> I've detected this problem the first time with the stable kernel 3.1.5.
> Bisecting leads me to the following patch:
> 
> "rtc: Disable the alarm in the hardware"
> Stable 3.1.5:     0cbc008c56f7b4a11ba6fe80e196d7ab322baabf
> Mainline 3.2-rcX: c0afabd3d553c521e003779c127143ffde55a16f
...

the 5 minutes auto-poweron problem was caused by the new function
drivers/rtc/interface.c -> rtc_alarm_disable():
   ...
   alarm.time = rtc_ktime_to_tm(ktime_add(rtc_tm_to_ktime(tm),
				        ktime_set(300, 0)));
   alarm.enabled = 0;
   ...

In this function the RTC alarm shall be disabled. Why do you set up a
5 minutes interval just before disabling the alarm?

I have changed
   ktime_set(300, 0)));
to
   ktime_set(0, 0)));
and all worked fine with my notebook.

Please check if this could be a common solution of the problem.

With best regards,
Andreas Friedrich

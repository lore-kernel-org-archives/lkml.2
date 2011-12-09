Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab1LIKBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 05:01:17 -0500
Received: from d1.icnet.pl ([212.160.220.21]:54452 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab1LIKBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 05:01:15 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 5/5 v2] ARM: OMAP1: recalculate loops per jiffy after dpll1 reprogram
Date: Fri, 9 Dec 2011 11:00:01 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1322364751-29980-6-git-send-email-jkrzyszt@tis.icnet.pl> <1322526332-14088-1-git-send-email-jkrzyszt@tis.icnet.pl> <20111209084245.GB14547@n2100.arm.linux.org.uk>
In-Reply-To: <20111209084245.GB14547@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112091100.01690.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 of December 2011 at 09:42:45, Russell King - ARM Linux wrote:
> On Tue, Nov 29, 2011 at 01:25:32AM +0100, Janusz Krzysztofik wrote:
> > However, the result of cpufreq_scale() differs from that of
> > (re)calibrate_delay() by ca. 6%, i.e., 70.40 vs. 74.54. Please advise if
> > this approximation is acceptable.
> 
> You don't say which figure is what.

Hi,
Those were BogoMIPS, which you were talking about in your comment 
(http://www.spinics.net/lists/linux-omap/msg60811.html).
> 
> Note that calibrate_delay() is itself inaccurate - the loops_per_jiffy
> is the number of loops which can be executed between two timer ticks
> _minus_ the time to process the timer interrupt itself.  So, it's
> actually always a little less than the theoretical number of loops
> within that time period.

I see. Then, in case of a machine always booting at, let's say, 12 and then reprogrammed to 150 MHz, we actually scale up that less then the theoretical number, with a side effect of scaling up its error as well. Perhaps in this case, when the machine is going to run at that target rate until rebooted, we should rather decide to recalibrate to keep that error proportionally small compared to the target loops per jiffy value, like it worked in my initial proposal? I think that your argument about unnecessarily wasting 10s of milliseconds has marginal importance here because we will be redoing that calibration only once, at boot time, and never later until next reboot.

Thanks,
Janusz

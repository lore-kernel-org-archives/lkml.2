Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab1BANvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:51:11 -0500
Received: from www.tglx.de ([62.245.132.106]:47068 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab1BANvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:51:09 -0500
Message-Id: <20110201134320.688829863@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:50:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 00/28]  Rework of the PTP support series core code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a rework of Richards PTP support series core code. The PTP
driver patches are unchanged and not included in this series.

The reason for this rework is that I got scared when reviewing:
 [PATCH V10 09/15] posix clocks: cleanup the CLOCK_DISPTACH macro

The patch is really too large and the risk of wreckage too high. So
instead of whipping Richard through another round I reworked the
series in the following way:

1) Split the CLOCK_DISPATCH cleanup in fine grained steps.
   
   That allowed further cleanups and got rid of 200 lines of code and
   made a lot of functions static.
   
   It also fixes subtle changes to the error return codes which happened
   in the large all in one overhaul (EINVAL vs. ENOTSUP).
   
2) Move the patches which add new functionality after the cleanup.

   It does not make sense to add new functionality into the old scheme
   first and then clean it up.

Richard, can you please run that through your testing ? The PTP
drivers apply on top of that.

Thanks,

	tglx


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab1LIIne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 03:43:34 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59366 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab1LIInd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 03:43:33 -0500
Date: Fri, 9 Dec 2011 08:42:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5 v2] ARM: OMAP1: recalculate loops per jiffy after
	dpll1 reprogram
Message-ID: <20111209084245.GB14547@n2100.arm.linux.org.uk>
References: <1322364751-29980-6-git-send-email-jkrzyszt@tis.icnet.pl> <1322526332-14088-1-git-send-email-jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322526332-14088-1-git-send-email-jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 01:25:32AM +0100, Janusz Krzysztofik wrote:
> However, the result of cpufreq_scale() differs from that of
> (re)calibrate_delay() by ca. 6%, i.e., 70.40 vs. 74.54. Please advise if
> this approximation is acceptable.

You don't say which figure is what.

Note that calibrate_delay() is itself inaccurate - the loops_per_jiffy
is the number of loops which can be executed between two timer ticks
_minus_ the time to process the timer interrupt itself.  So, it's
actually always a little less than the theoretical number of loops
within that time period.

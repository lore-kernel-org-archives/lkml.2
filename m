Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab1K1Pln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:41:43 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44843 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1K1Plm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:41:42 -0500
Date: Mon, 28 Nov 2011 15:39:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        linux-kernel@vger.kernel.org, Sameer Nanda <snanda@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/5] init/calibrate.c: allow for recalibration of loops
	per jiffy
Message-ID: <20111128153900.GA16481@n2100.arm.linux.org.uk>
References: <1322364751-29980-1-git-send-email-jkrzyszt@tis.icnet.pl> <1322364751-29980-5-git-send-email-jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322364751-29980-5-git-send-email-jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 04:32:30AM +0100, Janusz Krzysztofik wrote:
> This is required on ARM OMAP1 platform, after DPLL reprogramming has
> been fixed by moving it from setup_arch() to kernel_init().
> 
> Created against linux-3.2-rc2.

Why do you need this?  If you know what the original CPU clock rate and
bogomips were, and the new CPU clock rate, then you simply scale the
bogomips from the original accordingly.  That's what cpufreq does.

You don't have to waste 10s of milliseconds redoing the bogomips
calibration.

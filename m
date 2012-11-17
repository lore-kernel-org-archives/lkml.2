Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab2KQAhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 19:37:20 -0500
Received: from void.printf.net ([89.145.121.20]:38446 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab2KQAhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 19:37:19 -0500
From: Chris Ball <cjb@laptop.org>
To: Trey Ramsay <tramsay@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Rich Rattanni <rattanni@gmail.com>,
        Radovan Lekanovic <lekanovic@gmail.com>
Subject: Re: [PATCH 1/1] mmc: Bad device can cause mmc driver to hang
References: <87k3tpkz53.fsf@octavius.laptop.org>
	<1353079901-8773-1-git-send-email-tramsay@linux.vnet.ibm.com>
	<876255bluf.fsf@octavius.laptop.org> <50A6D1C7.302@linux.vnet.ibm.com>
Date: Fri, 16 Nov 2012 19:37:11 -0500
In-Reply-To: <50A6D1C7.302@linux.vnet.ibm.com> (Trey Ramsay's message of "Fri,
	16 Nov 2012 17:52:39 -0600")
Message-ID: <87mwyh9ia0.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trey, thanks for the analysis,

On Fri, Nov 16 2012, Trey Ramsay wrote:
> Good question.  In regards to the original problem were it was hung in
> mmc_blk_err_check, the new code path will timeout after 10 minutes, log
> an error, issue a hardware reset and abort the request. Is the hardware
> reset enough or will that even work when the device isn't coming out of
> program state? Should we try to refuse all new I/O?

mmc_hw_reset() only works for eMMC devices with a hooked up reset GPIO
-- not SD cards -- and at the moment there's only one system (Intel
Medfield) that supplies a GPIO, so that's not a general solution.

Maybe we should just merge your patch for now; we'll definitely get at
least a pr_err() explaining what's going on, which is an improvement.
Next time someone hits this (if anyone has an SD card that exhibits
this problem, it'd be very valuable for testing) we can look at going
farther, such as immediately setting host->flags |= SDHCI_DEVICE_DEAD.
What do you think?

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child

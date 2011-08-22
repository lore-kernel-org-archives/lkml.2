Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab1HVNrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:47:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55587 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1HVNri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:47:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: sdharia@codeaurora.org
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
Date: Mon, 22 Aug 2011 15:47:14 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Kenneth Heitke" <kheitke@codeaurora.org>,
        "David Brown" <davidb@codeaurora.org>, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, rdunlap@xenotime.net,
        rmk+kernel@arm.linux.org.uk, john.stultz@linaro.org,
        akpm@linux-foundation.org, ohad@wizery.com, gregkh@suse.de,
        stefanr@s5r6.in-berlin.de, lethal@linux-sh.org, linville@tuxdriver.com,
        zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org> <1313724284.19990.136.camel@finisterre.wolfsonmicro.main> <bd22ca4871ed2ce80b881a36dac5061c.squirrel@www.codeaurora.org>
In-Reply-To: <bd22ca4871ed2ce80b881a36dac5061c.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108221547.14657.arnd@arndb.de>
X-Provags-ID: V02:K0:T+dZw7WcMXl0OzSxV2SBgae7719J6lHuQVp4vEspend
 iKH9RHnQs1Pipve/hg/l9TgusNlfSd6sSP5LfgbREwRMJZMffs
 HjCzI/duwL8lxzI0A7vMdWyN0PqjD23+7LRVBlEF5y3pxcjcHH
 Et6xaIZATBiu/LxShR91DH8i3OvRxy4ODJYw2gX9PO5BQ9J75r
 6bMincJt61egS0QjK2s+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 August 2011, Sagar Dharia wrote:
> Another suggestion about probe is having callback to notify when the
> device is ready-to-use after driver probe powers it up. I will change the
> framework accordingly to have this done.

Is this actually needed? If the driver is responsible for powering up the
device, maybe it's enough to have a simple exported function from the
framework that blocks until the device has been probed, using a
'completion' or a similar wait_event() based primitive for waiting for
the device:

1. The bus driver creates the struct slim_device in one of the three ways
   mentioned and does init_completion().
2. The probe function of the driver ensures that the regulators/clocks/...
   are set up correctly and then calls wait_for_completion()
3. When the device shows up on the bus, the slimbus layer calls complete().

Steps 2 and 3 can happen in any order.

	Arnd

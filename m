Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab2K2K07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 05:26:59 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52278 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab2K2K06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 05:26:58 -0500
Date: Thu, 29 Nov 2012 10:25:19 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Chao Xie <chao.xie@marvell.com>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, haojian.zhuang@gmail.com,
        linux-arm-kernel@lists.infradead.org, xiechao.mail@gmail.com
Subject: Re: [PATCH 1/4] rtc: sa1100: enable/disable rtc when probe/remove
	the device
Message-ID: <20121129102519.GG19440@n2100.arm.linux.org.uk>
References: <1354155670-6267-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354155670-6267-1-git-send-email-chao.xie@marvell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 09:21:07PM -0500, Chao Xie wrote:
> The original sa1100_rtc_open/sa1100_rtc_release will be called
> when the /dev/rtc0 is opened or closed.
> In fact, these two functions will enable/disable the clock, and
> register/unregister the irqs.
> User application will use /dev/rtc0 to read the rtc time or set
> the alarm. The rtc should still run indepent of open/close the
> rtc device.
> So only enable clock and register the irqs when probe the device,
> and disable clock and unregister the irqs when remove the device.

NAK.  I don't think you properly understand what's going on here if you
think moving the entire open and release functions into the probe and
remove functions is the right thing to do.

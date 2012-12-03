Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab2LCJtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 04:49:22 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53698 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab2LCJtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 04:49:03 -0500
Date: Mon, 3 Dec 2012 09:48:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Chao Xie <xiechao.mail@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, Chao Xie <chao.xie@marvell.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/4] rtc: sa1100: enable/disable rtc when probe/remove
	the device
Message-ID: <20121203094828.GA14363@n2100.arm.linux.org.uk>
References: <1354155670-6267-1-git-send-email-chao.xie@marvell.com> <20121129102519.GG19440@n2100.arm.linux.org.uk> <CAN1soZxUA2PPy4694ByX1FTyWiJkha8QpKFK5Jc3Wf3zT0huOA@mail.gmail.com> <CADApbejZXach=YaiL5rEWA5+uc+mO8PzQzUKN+k90HfxEsqgtA@mail.gmail.com> <CADApbegrJDe5SiO255WdKYai1U7WjBYfMHuCm-hTNfx5p6Wz-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADApbegrJDe5SiO255WdKYai1U7WjBYfMHuCm-hTNfx5p6Wz-Q@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 10:53:07AM +0800, Chao Xie wrote:
> I want to correct what i said. For the irq register/unregister i think
> can be done at open/release. But for clock enable/disable, i do not
> think so. If clock is disabled, as i think RTC will not work. User API
> still use open->get_time->close for "date" command. It means that RTC
> will not return correct date to user.

"I think" is not good enough for patches like this.  Please test it.

On SA11x0 and PXA platforms, the clock for the sa1100-rtc is a dummy
clock; it has no effect.  For MMP, I don't have access to the TRMs so
that's something you're going to have to find out.

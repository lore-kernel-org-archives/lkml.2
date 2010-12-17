Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab0LQDnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 22:43:51 -0500
Received: from void.printf.net ([89.145.121.20]:37482 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685Ab0LQDnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 22:43:49 -0500
Date: Fri, 17 Dec 2010 03:43:42 +0000
From: Chris Ball <cjb@laptop.org>
To: Philip Rakity <prakity@marvell.com>
Cc: Takashi Iwai <tiwai@suse.de>, Aries Lee <arieslee@jmicron.com>,
        zhangfei gao <zhangfei.gao@gmail.com>, Qiming Wu <wuqm@marvell.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: Test bus-width for old MMC devices (v2)
Message-ID: <20101217034342.GA19673@void.printf.net>
References: <s5hfwtzbj8v.wl%tiwai@suse.de> <20101216234032.GA17239@void.printf.net> <50D31EC8-BD9E-4920-8CEB-2AD10DF9C5C5@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D31EC8-BD9E-4920-8CEB-2AD10DF9C5C5@marvell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philip,

On Thu, Dec 16, 2010 at 06:33:49PM -0800, Philip Rakity wrote:
> It is not possible for bus_width to be not initialized.  This would imply ARRAY_SIZE(bus_widths) is 1.  Certainly not true.

Right, I agree.  We should fix the warning anyway.

> We could just initialize by changing
> +		unsigned idx, bus_width;
> to
> +		unsigned idx, bus_width = 0;

Okay, I've pushed to mmc-next with that change.

> I wonder what compiler are you using so we can avoid this issue in future.

Ah, good point -- I was building with a gcc 4.1.2 ARM cross-compiler,
and using a gcc 4.5.1 cross-build instead avoids the warning.

Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child

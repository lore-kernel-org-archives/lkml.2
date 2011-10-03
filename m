Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab1JCGyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 02:54:06 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:45001 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894Ab1JCGxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 02:53:55 -0400
Subject: Re: [PATCH 02/30] video/omap: fix dependencies
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1317566760-25681-3-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
	 <1317566760-25681-3-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Oct 2011 09:53:50 +0300
Message-ID: <1317624830.2026.6.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Sun, 2011-10-02 at 16:45 +0200, Arnd Bergmann wrote:
> The lcd_2430sdp and lcd_ldp drivers depend on TWL4030, which is not
> well expressed in the Kconfig. Create new configuration options for
> these in order to describe the dependencies correctly.
> 
> In some cases, the driver cannot be a loadable module, so better
> force it to be built-in.
> 
> While we're at it, simplify the Makefile syntax.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> ---
>  drivers/video/omap/Kconfig  |   41 +++++++++++++++++++++++++---
>  drivers/video/omap/Makefile |   64 ++++++++++++++++++++-----------------------
>  2 files changed, 67 insertions(+), 38 deletions(-)

I have ported lcd_2430sdp and lcd_ldp drivers (and also other OMAP2/3
panel drivers, except N800) to the newer omapdss driver
(drivers/video/omap2), and the code is in my for-next branch
(git://gitorious.org/linux-omap-dss2/linux.git for-next).

I have also worked on removing OMAP2/3 support from the old omapfb
driver, thus making it OMAP1 fb driver. This code is not yet ready, and
won't make it in the next merge window.

Your patch will conflict with both of those changes. Is it ok for you to
drop this patch, and I'll make a new one on top of my changes to clean
up the Makefile in a similar way than you did? The new patch wouldn't
make it in the next merge window, though, but I don't think this patch
is fixing any bigger bug, so perhaps it's not so urgent.

 Tomi



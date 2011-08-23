Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab1HWNaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 09:30:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37285 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab1HWNaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 09:30:13 -0400
Date: Tue, 23 Aug 2011 17:30:09 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dima Zavin <dima@android.com>
Subject: Re: [PATCH] pda_power: fix build error if !CONFIG_USB_OTG_UTILS
Message-ID: <20110823133009.GB1352@oksana.dev.rtsoft.ru>
References: <1314102873.16518.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1314102873.16518.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 08:34:33PM +0800, Axel Lin wrote:
> commit 9ad63986c606c60e2e916b1b96f22991f966d9cc
> "pda_power: Add support for using otg transceiver events"
> introduces below build error if !CONFIG_USB_OTG_UTILS.
> 
>   CC      drivers/power/pda_power.o
> drivers/power/pda_power.c: In function 'pda_power_probe':
> drivers/power/pda_power.c:322: error: 'otg_is_usb_online' undeclared (first use in this function)
> drivers/power/pda_power.c:322: error: (Each undeclared identifier is reported only once
> drivers/power/pda_power.c:322: error: for each function it appears in.)
> drivers/power/pda_power.c:325: error: 'otg_is_ac_online' undeclared (first use in this function)
> drivers/power/pda_power.c:371: error: 'otg_handle_notification' undeclared (first use in this function)
> make[2]: *** [drivers/power/pda_power.o] Error 1
> make[1]: *** [drivers/power] Error 2
> make: *** [drivers] Error 2
> 
> This patch adds #ifdef CONFIG_USB_OTG_UTILS guards at necessary places to fix
> build errors.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---

Applied, thanks!

Dima,

I wonder if it is possible to get rid of most #ifdefs by moving
the pda_power's USB_OTG stuff into a function?

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com

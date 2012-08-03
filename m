Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab2HCFMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 01:12:17 -0400
Received: from void.printf.net ([89.145.121.20]:52185 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab2HCFMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 01:12:16 -0400
From: Chris Ball <cjb@laptop.org>
To: "werner" <w.landgraf@ru.ru>
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>
Subject: Re: 3.6-rc1:     twl4030  don't compile   :(
References: <web-777065796@zbackend1.aha.ru>
Date: Fri, 03 Aug 2012 01:12:10 -0400
In-Reply-To: <web-777065796@zbackend1.aha.ru> (werner's message of "Fri, 03
	Aug 2012 00:17:01 -0400")
Message-ID: <87hask8sph.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Aug 03 2012, werner wrote:
>   CC      drivers/power/twl4030_charger.o
> drivers/power/twl4030_charger.c:248:12: error: invalid suffix "b1100"
> on integer constant

drivers/power/twl4030_charger.c:
#define TWL4030_BBSEL_3V0       0b0100
#define TWL4030_BBSEL_3V1       0b1000
#define TWL4030_BBSEL_3V2       0b1100

Werner, your gcc version is too old to support the 0b-prefixed binary
constant syntax.  It was introduced in gcc-4.3.  The kernel compiles
fine here, on gcc-4.7.

Neil Brown added this use of the 0b prefix in 210d4bc8a3128e3e61ac3b
("twl4030_charger: Add backup-battery charging").  Neil, I don't think
we can use this syntax yet -- Documentation/Changes says that we still
support from gcc-3.2 onwards.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child

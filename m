Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab2HISYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 14:24:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53828 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab2HISYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 14:24:48 -0400
Message-ID: <5024001E.3080803@ti.com>
Date: Thu, 9 Aug 2012 23:53:26 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <arm@kernel.org>,
        <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Andrey Porodko <panda@chelcom.ru>
Subject: Re: [PATCH v2 06/10] ARM: davinci: don't use broken ntosd2_init_i2c
References: <1344461278-28245-1-git-send-email-arnd@arndb.de> <1344461278-28245-7-git-send-email-arnd@arndb.de> <201208090800.18321.arnd@arndb.de>
In-Reply-To: <201208090800.18321.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 8/9/2012 1:30 PM, Arnd Bergmann wrote:
> On second thought, there is probably no use in keeping the broken function
> around, and we can just kill it off. If someone wants to add an i2c
> device to the bus, they can always add the init code back as well.
> 
> 8<-----
> Subject: ARM: davinci: don't use broken ntosd2_init_i2c
> 
> ntosd2_init_i2c walks the ntosd2_i2c_info array, which it expects to
> be populated with at least one member. gcc correctly warns about
> the out-of-bounds access here.
> 
> Since this can not possibly work, it's better to disable i2c
> support entirely on this board.
> 
> Without this patch, building davinci_all_defconfig results in:
> 
> arch/arm/mach-davinci/board-neuros-osd2.c: In function 'davinci_ntosd2_init':
> arch/arm/mach-davinci/board-neuros-osd2.c:187:20: warning: array subscript is above array bounds [-Warray-bounds]
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Andrey Porodko <panda@chelcom.ru>

Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar

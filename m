Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab0LGVpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 16:45:09 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54925 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab0LGVpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 16:45:07 -0500
Date: Tue, 7 Dec 2010 16:38:58 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Joe Perches <joe@perches.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>, linux-kernel@vger.kernel.org,
        Peter Stuge <peter@stuge.se>, Felix Fietkau <nbd@openwrt.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] ath: Add and use ath_printk and ath_<level>
Message-ID: <20101207213857.GN2700@tuxdriver.com>
References: <cover.1291333543.git.joe@perches.com>
 <241e75c84fdd26bfae1c7b8806fe64fbac5de627.1291333544.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <241e75c84fdd26bfae1c7b8806fe64fbac5de627.1291333544.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 07:12:35PM -0800, Joe Perches wrote:
> Add ath_printk and ath_<level> similar to
> dev_printk and dev_<level> from device.h
> 
> This allows a more gradual rename of ath_print
> to to ath_dbg or perhaps ath_debug.
> 
> This basically removes debug.h leaving
> only an #define ath_printk ath_dbg
> there and moving all the ATH_DBG_<foo>
> enums to ath.h
> 
> I do not think there's much purpose for struct
> ath_common * being passed to the ath_printk
> functions, but perhaps there might be.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

> +#define ATH_DBG_WARN(foo, arg...) WARN(foo, arg)
> +
> +#else
> +
> +static inline  __attribute__ ((format (printf, 3, 4))) int
> +ath_dbg(struct ath_common *common, enum ATH_DEBUG dbg_mask,
> +	const char *fmt, ...)
> +{
> +	return 0;
> +}
> +#define ATH_DBG_WARN(foo, arg) do {} while (0)

Missing the "..." after "arg" -- I fixed it up...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

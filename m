Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2FLQRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:17:46 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:56402 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753481Ab2FLQRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:17:42 -0400
Message-ID: <4FD76B95.60708@xenotime.net>
Date: Tue, 12 Jun 2012 09:17:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
CC: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mnazarewicz@gmail.com>,
        Benoit Goby <benoit@android.com>, Mike Lockwood <lockwood@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 2/2] drivers: usb: gadget: add multiple definition guards
References: <Pine.LNX.4.44L0.1206071646360.1185-100000@iolanthe.rowland.org> <1339405995-6298-1-git-send-email-andrzej.p@samsung.com>
In-Reply-To: <1339405995-6298-1-git-send-email-andrzej.p@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2012 02:13 AM, Andrzej Pietrasiewicz wrote:

> If f_fs.c and u_serial.c are combined together using #include, which has
> been a common practice so far, the pr_vdebug macro is defined multiple
> times. Define it only once.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  drivers/usb/gadget/f_fs.c     |    4 ++++
>  drivers/usb/gadget/u_serial.c |    4 ++++
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index dcd1c7f..27c841d 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
> @@ -33,11 +33,15 @@
>  /* Debugging ****************************************************************/
>  
>  #ifdef VERBOSE_DEBUG
> +#ifndef pr_vdebug
>  #  define pr_vdebug pr_debug
> +#endif /* pr_vdebug */
>  #  define ffs_dump_mem(prefix, ptr, len) \
>  	print_hex_dump_bytes(pr_fmt(prefix ": "), DUMP_PREFIX_NONE, ptr, len)
>  #else
> +#ifndef pr_vdebug
>  #  define pr_vdebug(...)                 do { } while (0)
> +#endif /* pr_vdebug */
>  #  define ffs_dump_mem(prefix, ptr, len) do { } while (0)
>  #endif /* VERBOSE_DEBUG */
>  
> diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
> index 5b3f5ff..da6d479 100644
> --- a/drivers/usb/gadget/u_serial.c
> +++ b/drivers/usb/gadget/u_serial.c
> @@ -132,11 +132,15 @@ static unsigned	n_ports;
>  
>  
>  #ifdef VERBOSE_DEBUG
> +#ifndef pr_vdebug
>  #define pr_vdebug(fmt, arg...) \
>  	pr_debug(fmt, ##arg)
> +#endif /* pr_vdebug */
>  #else
> +#ifndef pr_vdebig
>  #define pr_vdebug(fmt, arg...) \
>  	({ if (0) pr_debug(fmt, ##arg); })
> +#endif /* pr_vdebug */
>  #endif
>  
>  /*-------------------------------------------------------------------------*/



-- 
~Randy

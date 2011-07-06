Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1GFWvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 18:51:51 -0400
Received: from bar.sig21.net ([80.81.252.164]:50697 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab1GFWvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 18:51:50 -0400
Date: Thu, 7 Jul 2011 00:51:40 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <axboe@kernel.dk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        akpm@linux-foundation.org
Subject: Re: [PATCH] compat_ioctl: fix make headers_check regression
Message-ID: <20110706225140.GA21510@sig21.net>
References: <20110704134842.7ab89126.sfr@canb.auug.org.au>
 <20110704100316.GA15894@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704100316.GA15894@sig21.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -3.7 (---)
X-Spam-21-Report: No, score=-3.7 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.720,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 04, 2011 at 12:03:16PM +0200, Johannes Stezenbach wrote:
> Fix headers_check error introduced by 390192b30057:
> 
> include/linux/fd.h:6: included file 'linux/compat.h' is not exported
> 
> Signed-off-by: Johannes Stezenbach <js@sig21.net>
> ---
> I used the same style as in linux/usbdevice_fs.h, hope
> that's OK.


I just got an "added to -mm tree" mail for the original patch, so I
wonder what's with this fix?


Johannes


>  include/linux/fd.h |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/fd.h b/include/linux/fd.h
> index c6a68d0..72202b1 100644
> --- a/include/linux/fd.h
> +++ b/include/linux/fd.h
> @@ -3,7 +3,6 @@
>  
>  #include <linux/ioctl.h>
>  #include <linux/compiler.h>
> -#include <linux/compat.h>
>  
>  /* New file layout: Now the ioctl definitions immediately follow the
>   * definitions of the structures that they use */
> @@ -378,7 +377,11 @@ struct floppy_raw_cmd {
>  #define FDEJECT _IO(2, 0x5a)
>  /* eject the disk */
>  
> +
> +#ifdef __KERNEL__
>  #ifdef CONFIG_COMPAT
> +#include <linux/compat.h>
> +
>  struct compat_floppy_struct {
>  	compat_uint_t	size;
>  	compat_uint_t	sect;
> @@ -394,5 +397,6 @@ struct compat_floppy_struct {
>  
>  #define FDGETPRM32 _IOR(2, 0x04, struct compat_floppy_struct)
>  #endif
> +#endif
>  
>  #endif

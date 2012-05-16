Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967245Ab2EPNR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 09:17:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58015 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758381Ab2EPNR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 09:17:56 -0400
Date: Wed, 16 May 2012 06:17:51 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, patches@linaro.org,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        arve@android.com, Jesper Juhl <jj@chaosbits.net>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com,
        Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [PATCH 2/6] ramoops: Move to fs/pstore/ram.c
Message-ID: <20120516131751.GA23849@kroah.com>
References: <20120516124109.GA14658@lizard>
 <20120516124308.GB18345@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516124308.GB18345@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 05:43:08AM -0700, Anton Vorontsov wrote:
> Since ramoops was converted to pstore, it has nothing to do with character
> devices nowadays. Instead, today it is just a RAM backend for pstore.
> 
> The patch just moves things around. There are a few changes were needed
> because of the move:
> 
> 1. Kconfig and Makefiles fixups, of course.
> 
> 2. In pstore/ram.c we have to play a bit with MODULE_PARAM_PREFIX, this
>    is needed to keep user experience the same as with ramoops driver
>    (i.e. so that ramoops.foo kernel command line arguments would still
>    work).
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> Acked-by: Marco Stornelli <marco.stornelli@gmail.com>
> Acked-by: Kees Cook <keescook@chromium.org>
> ---
>  Documentation/ramoops.txt  |    2 +-
>  drivers/char/Kconfig       |    9 --
>  drivers/char/Makefile      |    1 -
>  drivers/char/ramoops.c     |  362 --------------------------------------------
>  fs/pstore/Kconfig          |   14 ++
>  fs/pstore/Makefile         |    3 +
>  fs/pstore/ram.c            |  362 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pstore_ram.h |   17 +++
>  include/linux/ramoops.h    |   17 ---
>  9 files changed, 397 insertions(+), 390 deletions(-)
>  delete mode 100644 drivers/char/ramoops.c
>  create mode 100644 fs/pstore/ram.c
>  create mode 100644 include/linux/pstore_ram.h
>  delete mode 100644 include/linux/ramoops.h

This patch fails to apply to my staging-next tree due to problems with
drivers/char/Kconfig and drivers/char/ramoops.c.  What tree are you
making this patch against?

> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -585,15 +585,6 @@ config DEVPORT
>  
>  source "drivers/s390/char/Kconfig"
>  
> -config RAMOOPS
> -	tristate "Log panic/oops to a RAM buffer"
> -	depends on HAS_IOMEM
> -	depends on PSTORE

This "depends on PSTORE" line is not in my staging-next tree, where did
it come from?

I'm guessing that because of this, is why the other conflict happens,
right?

Any ideas on what I can do to resolve it?  As you are moving a file, I
want to make sure I move the correct version of it :)

thanks,

greg k-h

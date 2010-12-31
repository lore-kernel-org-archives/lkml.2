Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514Ab0LaFjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 00:39:18 -0500
Received: from xenotime.net ([72.52.115.56]:49862 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750973Ab0LaFjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 00:39:17 -0500
Date: Thu, 30 Dec 2010 21:39:15 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, aospan@netup.ru
Subject: Re: [PATCH 01/18] Altera FPGA firmware download module.
Message-Id: <20101230213915.3842b3ca.rdunlap@xenotime.net>
In-Reply-To: <201012310726.31851.liplianin@netup.ru>
References: <201012310726.31851.liplianin@netup.ru>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Dec 2010 08:26:31 +0300 Igor M. Liplianin wrote:

> It uses STAPL files and programs Altera FPGA through JTAG.
> Interface to JTAG must be provided from main device module,
> for example through cx23885 GPIO.
> 
> Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>
> ---
>  drivers/misc/Kconfig                     |    1 +
>  drivers/misc/Makefile                    |    1 +
>  drivers/misc/altera-stapl/Kconfig        |    8 +
>  drivers/misc/altera-stapl/Makefile       |    3 +
>  drivers/misc/altera-stapl/altera-comp.c  |  142 ++
>  drivers/misc/altera-stapl/altera-exprt.h |   33 +
>  drivers/misc/altera-stapl/altera-jtag.c  | 1010 ++++++++++++
>  drivers/misc/altera-stapl/altera-jtag.h  |  113 ++
>  drivers/misc/altera-stapl/altera-lpt.c   |   70 +
>  drivers/misc/altera-stapl/altera.c       | 2484 ++++++++++++++++++++++++++++++
>  include/misc/altera.h                    |   49 +
>  11 files changed, 3914 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/altera-stapl/Kconfig
>  create mode 100644 drivers/misc/altera-stapl/Makefile
>  create mode 100644 drivers/misc/altera-stapl/altera-comp.c
>  create mode 100644 drivers/misc/altera-stapl/altera-exprt.h
>  create mode 100644 drivers/misc/altera-stapl/altera-jtag.c
>  create mode 100644 drivers/misc/altera-stapl/altera-jtag.h
>  create mode 100644 drivers/misc/altera-stapl/altera-lpt.c
>  create mode 100644 drivers/misc/altera-stapl/altera.c
>  create mode 100644 include/misc/altera.h
> 
> diff --git a/drivers/misc/altera-stapl/Kconfig b/drivers/misc/altera-stapl/Kconfig
> new file mode 100644
> index 0000000..711a4a2
> --- /dev/null
> +++ b/drivers/misc/altera-stapl/Kconfig
> @@ -0,0 +1,8 @@
> +comment "Altera FPGA firmware download module"
> +
> +config ALTERA_STAPL
> +	tristate "Altera FPGA firmware download module"
> +	depends on I2C
> +	default m
> +	help

Please do not enable random drivers to build by default.


> +static int altera_get_note(u8 *p, s32 program_size,
> +			s32 *offset, char *key, char *value, int length)
> +/*
> +Gets key and value of NOTE fields in the JBC file.
> +Can be called in two modes:  if offset pointer is NULL,
> +then the function searches for note fields which match
> +the key string provided.  If offset is not NULL, then
> +the function finds the next note field of any key,
> +starting at the offset specified by the offset pointer.
> +Returns 0 for success, else appropriate error code	*/
> +{


/*
 * Throughout all source files:
 * The multi-line comment format for Linux kernel is like this multi-line comment.
 */



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/

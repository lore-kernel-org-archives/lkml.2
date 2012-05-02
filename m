Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab2EBOlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 10:41:44 -0400
Received: from mail1.windriver.com ([147.11.146.13]:38529 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab2EBOlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 10:41:40 -0400
Message-ID: <4FA14788.6090000@windriver.com>
Date: Wed, 2 May 2012 10:41:12 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: <linux-serial@vger.kernel.org>, <horms@verge.net.au>, <arnd@arndb.de>,
        <linux-sh@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <swarren@wwwdotorg.org>, <linux-kernel@vger.kernel.org>, <rjw@sisk.pl>,
        <lethal@linux-sh.org>, <olof@lixom.net>, <dan.j.williams@intel.com>,
        <alan@linux.intel.com>
Subject: Re: [PATCH 06/06] serial8250-em: Add Emma Mobile UART driver
References: <20120502124642.30480.41373.sendpatchset@w520> <20120502124736.30480.48207.sendpatchset@w520>
In-Reply-To: <20120502124736.30480.48207.sendpatchset@w520>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-05-02 08:47 AM, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Add a platform driver for Emma Mobile 8250 hardware.


[...]

> +
> +config SERIAL_8250_EM
> +	tristate "Support for Emma Mobile intergrated serial port"
> +	depends on SERIAL_8250

Should we depend on arch=ARM or something similar?  Even if the
driver is written to be arch independent, if the Emma itself is
physically tied to ARM platforms, we probably don't need to be
building it for sparc allyesconfig etc.

P.

> +	help
> +	  Selecting this option will add support for the integrated serial
> +	  port hardware found on the Emma Mobile line of processors.
> +	  If unsure, say N.
> --- 0001/drivers/tty/serial/8250/Makefile
> +++ work/drivers/tty/serial/8250/Makefile	2012-05-02 17:25:19.000000000 +0900
> @@ -18,3 +18,4 @@ obj-$(CONFIG_SERIAL_8250_HUB6)		+= 8250_
>  obj-$(CONFIG_SERIAL_8250_MCA)		+= 8250_mca.o
>  obj-$(CONFIG_SERIAL_8250_FSL)		+= 8250_fsl.o
>  obj-$(CONFIG_SERIAL_8250_DW)		+= 8250_dw.o
> +obj-$(CONFIG_SERIAL_8250_EM)		+= 8250_em.o

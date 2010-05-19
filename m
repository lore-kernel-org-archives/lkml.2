Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab0ESRNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:13:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27178 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab0ESRNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:13:50 -0400
Date: Wed, 19 May 2010 10:13:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "David Dajun Chen" <Dajun.Chen@diasemi.com>
Cc: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>
Subject: Re: [PATCH] MFD of DA9052 Linux device drivers (1/9)
Message-Id: <20100519101327.b57d253b.randy.dunlap@oracle.com>
In-Reply-To: <3495EC08FA53E94AAA00CC4743D5BA7E010C20EB@pandora.diasemi.com>
References: <3495EC08FA53E94AAA00CC4743D5BA7E010C20EB@pandora.diasemi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090203.4BF41C4B.006F:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010 10:16:10 +0100 David Dajun Chen wrote:

Hi,
2 comments from a quick scan:



> diff -Naur linux-2.6.33.2/drivers/mfd/Kconfig linux-2.6.33.2_patch/drivers/mfd/Kconfig
> --- linux-2.6.33.2/drivers/mfd/Kconfig	2010-04-02 04:02:33.000000000 +0500
> +++ linux-2.6.33.2_patch/drivers/mfd/Kconfig	2010-05-18 15:30:37.000000000 +0500
> @@ -348,6 +348,35 @@
>  	  read/write functions for the devices to get access to this chip.
>  	  This chip embeds various other multimedia funtionalities as well.
>  
> +config MFD_DA9052
> +	bool "Dialog Semiconductor DA9052 PMIC Support"

a.  why are all of these drivers "bool" (y/n) instead of tristate (y/m/n)?
i.e., why are they not buildable as loadable modules?


> +	help
> +	  Say yes here to support for Dialog semiconductor Da9052, Power
> +	  Management IC.This option enables the SPI/I2C, EH, and ADC
> +	  features of DA9052.
> +choice
> +	prompt "DA9052 SSC support"
> +	depends on MFD_DA9052
> +config MFD_DA9052_SPI
> +	bool "SPI"
> +	select SPI
> +	select GPIOLIB
> +	help
> +	  Say Y  to select SPI serial interface for DA9052 chip
> +
> +config MFD_DA9052_I2C
> +	bool "I2C"
> +	select I2C
> +	help
> +	  Say Y  to select I2C serial interface for DA9052 chip
> +endchoice
> +
> +config DA9052_ADC_ENABLE
> +	bool "Dialog Semiconductor DA9052 ADC Driver"
> +	depends on MFD_DA9052
> +	help
> +	  Say Y  to enable the ADC driver for the DA9052 chip
> +
>  endmenu
>  
>  menu "Multimedia Capabilities Port drivers"


b.  The .c and .h files have lots of comments in them that begin with "/**",
which in kernel-land means kernel-doc notation... but they are not in kernel-doc
notation.  Please see Documentation/kernel-doc-nano-HOWTO.txt for info on how
to use kernel-doc notation.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

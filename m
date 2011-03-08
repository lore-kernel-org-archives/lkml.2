Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab1CHR7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 12:59:03 -0500
Received: from xenotime.net ([184.105.210.51]:50340 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751378Ab1CHR7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 12:59:01 -0500
Date: Tue, 8 Mar 2011 09:58:42 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: adharmap@codeaurora.org
Cc: davidb@codeaurora.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@sterricsson.com>,
        Thomas Glexiner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Qualcomm PM8921 MFD v2 1/6] mfd: pm8921: Add PMIC 8921 core
 driver
Message-Id: <20110308095842.99aa7efb.rdunlap@xenotime.net>
In-Reply-To: <1299564590-30116-2-git-send-email-adharmap@codeaurora.org>
References: <1299564590-30116-1-git-send-email-adharmap@codeaurora.org>
	<1299564590-30116-2-git-send-email-adharmap@codeaurora.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  7 Mar 2011 22:09:45 -0800 adharmap@codeaurora.org wrote:

> From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
> 
> Add support for the Qualcomm PM8921 PMIC chip. The core driver
> will communicate with the PMIC chip via the MSM SSBI bus.
> 
> 
> Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
> ---
>  drivers/mfd/Kconfig             |   18 +++++
>  drivers/mfd/Makefile            |    1 +
>  drivers/mfd/pm8921-core.c       |  157 +++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/pm8921.h      |   26 +++++++
>  include/linux/mfd/pm8xxx/core.h |   66 ++++++++++++++++
>  5 files changed, 268 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/pm8921-core.c
>  create mode 100644 include/linux/mfd/pm8921.h
>  create mode 100644 include/linux/mfd/pm8xxx/core.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index fd01836..46f0d2f 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -624,6 +624,24 @@ config MFD_WL1273_CORE
>  	  driver connects the radio-wl1273 V4L2 module and the wl1273
>  	  audio codec.
>  
> +config MFD_PM8XXX
> +	tristate
> +
> +config MFD_PM8921_CORE
> +	tristate "Qualcomm PM8921 PMIC chip"
> +	depends on MSM_SSBI
> +	select MFD_CORE
> +	select MFD_PM8XXX
> +	help
> +	  If you say yes to this option, support will be included for the
> +	  built-in PM8921 PMIC chip

end sentence with period, please.

> +
> +	  This is required if your board has a PM8921 and uses its features,
> +	  such as: MPPs, GPIOs, regulators, interrupts, and PWM.
> +
> +	  Say M here if you want to include support for PM8921 chip as a module.
> +	  This will build a module called "pm8921-core.ko".

Drop the ".ko".  We (usually) don't spell that out since "modprobe pm8921-core"
works.

> +
>  endif # MFD_SUPPORT
>  
>  menu "Multimedia Capabilities Port drivers"


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
